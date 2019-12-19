

// TODO: Pull input off the command line && groups
package main

import (
    "fmt"
    "os"
    "os/user"
)

func main() {

    user, err := user.Current()
    argsWithoutProg := os.Args[1:]

    arg := os.Args[1]

    fmt.Println(argsWithoutProg)
    fmt.Println(arg)

    if err != nil {
        panic(err)
    }

    // Current User
    fmt.Println("Hi " + user.Name + " (id: " + user.Uid + ")")
    fmt.Println("Username: " + user.Username)
    fmt.Println("Home Dir: " + user.HomeDir)

    fmt.Println("Real User: " + os.Getenv("SUDO_USER"))
}
