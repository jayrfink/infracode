package main

import (
	"fmt"
	"net"
)

func ListInterfaces()  {
	interfaces, err := net.Interfaces()

	if err == nil {

		for _, i := range interfaces {
			if i.Flags&net.FlagUp != 0 {
					fmt.Println(i)

			}
		}
	}
}


func main() {
	ListInterfaces()
}
