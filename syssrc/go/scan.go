
/*
 * scan.go - this is very much a work in progress. I found this as public
 *           domain code and changed it to accept an argument. It is 
 *           one of the fastest host portscanners there is.
 */
package main

import (
	"context"
	"container/list"
	"fmt"
	"net"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"sync"
	"time"
)

/*
 * These are data structures for semaphore operations. In this instance
 * we are locking for portreply waits to come back. Based on semaphore.go
 */
type waiter struct {
    n     int64
    ready chan<- struct{} // Closed when semaphore acquired.
}

func New_weighted(n int64) *Weighted {
    w := &Weighted{size: n}
    return w
}

type Weighted struct {
    size    int64
    cur     int64
    mu      sync.Mutex
    waiters list.List
}

/*
 * Simple portscanner data structure
 */
type Portscanner struct {
	ip   string
	lock *Weighted
}

/*
 * Context locking Operations
 */
func (s *Weighted) Acquire(ctx context.Context, n int64) error {
    s.mu.Lock()
    if s.size-s.cur >= n && s.waiters.Len() == 0 {
        s.cur += n
        s.mu.Unlock()
        return nil
    }

    if n > s.size {
        // Don't make other Acquire calls block on one that's doomed to fail.
        s.mu.Unlock()
        <-ctx.Done()
        return ctx.Err()
    }

    ready := make(chan struct{})
    w := waiter{n: n, ready: ready}
    elem := s.waiters.PushBack(w)
    s.mu.Unlock()

    select {
    case <-ctx.Done():
        err := ctx.Err()
        s.mu.Lock()
        select {
        case <-ready:
        // Acquired the semaphore after we were canceled. Rather than trying to
        // fix up the queue, just pretend we didn't notice the cancellation.
            err = nil
        default:
            s.waiters.Remove(elem)
        }
        s.mu.Unlock()
        return err

    case <-ready:
        return nil
    }
}


func (s *Weighted) TryAcquire(n int64) bool {
    s.mu.Lock()
    success := s.size-s.cur >= n && s.waiters.Len() == 0
    if success {
        s.cur += n
    }
    s.mu.Unlock()
    return success
}

func (s *Weighted) Release(n int64) {
    s.mu.Lock()
    s.cur -= n
    if s.cur < 0 {
        s.mu.Unlock()
        panic("semaphore: released more than held")
    }
    for {
        next := s.waiters.Front()
        if next == nil {
            break // No more waiters blocked.
        }

        w := next.Value.(waiter)
        if s.size-s.cur < w.n {
            break
        }

        s.cur += w.n
        s.waiters.Remove(next)
        close(w.ready)
    }
    s.mu.Unlock()
}

func Ulimit() int64 {
	out, err := exec.Command("/bin/sh", "-c", "ulimit -n").Output()
	if err != nil {
		panic(err)
	}

	s := strings.TrimSpace(string(out))

	i, err := strconv.ParseInt(s, 10, 64)
	if err != nil {
		panic(err)
	}

	return i
}

func ScanPort(ip string, port int, timeout time.Duration) {
	target := fmt.Sprintf("%s:%d", ip, port)
	conn, err := net.DialTimeout("tcp", target, timeout)

	if err != nil {
		if strings.Contains(err.Error(), "too many open files") {
			time.Sleep(timeout)
			ScanPort(ip, port, timeout)
/* XXX This is really loud if you are scanning 2-65534 for instance
       only show us the open ports if it doesn't show up we assume closed
		} else {
			fmt.Println(port, "closed")
*/
		}
		return
	}

	conn.Close()
	fmt.Println(port, "\topen")
}

func (ps *Portscanner) Start(f, l int, timeout time.Duration) {
	wg := sync.WaitGroup{}
	defer wg.Wait()

	for port := f; port <= l; port++ {
		ps.lock.Acquire(context.TODO(), 1)
		wg.Add(1)
		go func(port int) {
			defer ps.lock.Release(1)
			defer wg.Done()
			ScanPort(ps.ip, port, timeout)
		}(port)
	}
}

/*
 * Usage: host||ipaddr start_port end_port
 */
func main() {
    arg := os.Args[1]
	fmt.Println("Scanning: ", os.Args[1])
	port_start, err := strconv.Atoi(os.Args[2])
	if err != nil {
		fmt.Println("No start port specified")
		os.Exit(1)
	}
	port_end, err := strconv.Atoi(os.Args[3])
/* XXX-jrf: This does _not_ work. We end up relying on lib failures
	if err == nil {
		port_end = port_start
	}
*/

	ps := &Portscanner{
		ip:   arg,
		lock: New_weighted(Ulimit()),
	}

	ps.Start(port_start, port_end, 500*time.Millisecond)
}
