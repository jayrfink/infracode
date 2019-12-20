#include "portcheck.h"

#define USAGE "Usage: portcheck port address"

static int isalive(struct sockaddr_in scanaddr)
{
    short int sock;          /* our main socket */
    long arg;                /* for non-block */
    fd_set wset;             /* file handle for bloc mode */
    struct timeval timeout;  /* timeout struct for connect() */

    sock = -1;

    sock = socket(AF_INET, SOCK_STREAM, 0);

    if( (arg = fcntl(sock, F_GETFL, NULL)) < 0) { 
        fprintf(stderr,
        "Error fcntl(..., F_GETFL) (%s)\n",
            strerror(errno));
        return 1;
    }

    arg |= O_NONBLOCK;
    if(fcntl(sock, F_SETFL, arg) < 0) {
        fprintf(stderr,
        "Error fcntl(..., F_SETFL)  (%s)\n",                                            strerror(errno));
        return 1;
    }

    /* 
     * set result stat then try a select if it can take
     * awhile. This is dirty but works 
     */
    int res = connect(sock,(struct sockaddr *)&scanaddr,
                      sizeof(scanaddr));

    if (res < 0) {
        if (errno == EINPROGRESS) {
            timeout.tv_sec = DEFAULT_TIMEOUT;
            timeout.tv_usec = 0;
            FD_ZERO(&wset);
            FD_SET(sock, &wset);
            int rc = select(sock + 1,NULL,
            &wset,NULL,&timeout);

            /* This works great on dead hosts */
            if (rc == 0 && errno != EINTR) {
				printf("Error connecting\n");
				close (sock);
                return 1;
            }
        }
    }
    close(sock);
    return 0;
}


int main(int argc, char **argv)
{
    u_short port;               /* user specified port number */
    short int sock = -1;        /* the socket descriptor */
    struct hostent *host_info;  /* host info structure */
    struct sockaddr_in address; /* address structures */
    char addr[1023];            /* copy of address from stdin */

    if (argv[1])
        if (!strcmp(argv[1], "-u")) {
            printf("%s\n", USAGE);
            return 0;
        }

    if (argv[1]) 
    	port = atoi(argv[1]);
    else {
        fprintf(stderr, "No port specified\n");
		fprintf(stderr,"%s\n", USAGE);
		return 1;
    }

    if (argv[2])
        strncpy(addr, argv[2], 1023);
    else {
        fprintf(stderr, "No address specified\n");
		fprintf(stderr,"%s\n", USAGE);
		return 1;
    }

    bzero((char *)&address, sizeof(address));  /* init addr struct */
    address.sin_addr.s_addr = inet_addr(addr); /* assign the address */
    address.sin_port = htons(port);            /* translate int2port num */

	/* Hostname resolution */
	if ((host_info = gethostbyname(addr))) 
		bcopy(host_info->h_addr,(char *)&address.sin_addr,host_info->h_length);
	else if ((address.sin_addr.s_addr = inet_addr(argv[2])) == INADDR_NONE) {
		fprintf(stderr, "Could not resolve host\n" );
		return 1;
	}

    /*
     *     1. Make sure the host is alive
     *     2. Connect to hostbyport works? print success
     */
	if (isalive(address)) return 0;

	/* So far so good - the host exists and is up; check the port and report */
	close (sock);
    sock = socket(AF_INET, SOCK_STREAM, 0);
	if(connect(sock,(struct sockaddr *)&address,sizeof(address)) == 0)
		printf("%i is open on %s\n", port, argv[2]);
	else
		printf("%i is not open on %s\n", port, argv[2]);

    close(sock);

    return 0;
}

