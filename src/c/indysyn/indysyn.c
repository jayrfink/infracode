
#include "indysyn.h"


int main(int argc, char **argv)
{
	int c;                 /* opt counter  */
	short int s_port  = 0; /* single port  */
	short int isup    = 0; /* isup ?       */
	short int gotaddr = 0; /* addr ?       */
	short int flag6   = 0; /* doing 6 scan */
	char *port6;           /* v6 port      */
	char addr6[1024];      /* 6space       */

	struct servent *portinfo; /* OS Port information data */

	/* 
	 * Options parsing:
     * 6 -v6    <port> IPV6 Simgle Port scan
	 * h -host  <host> IP Address or FQDN or hostname
	 * i -isup         Is it up? Then just bail ASAP
	 * p -port  <port> Single port 
	 * u -usage        Usage message (with defaults)
	 */
	while (1) {
		static struct option long_options[] = {
			{"v6", no_argument, 0, '6'},
			{"host", required_argument, 0, 'h'},
			{"isup", no_argument,0,'i'},
			{"port", required_argument, 0, 'p'},
			{"usage", no_argument,0,'u'},
			{0,0,0,0}
		};

		int option_index = 0;

		c = getopt_long(argc, argv, ":6h:ip:u", 
				long_options, &option_index);

		if (c == -1)
			break;

		switch (c) {
		case '6':
			flag6 = 1;
			break;
		case 'h':
			gotaddr = 1;
			if (!flag6)
				indy_setaddr(optarg); /* helper sets the addr to be scanned */
			else
				strncpy(addr6, optarg, 1023);
			break;
		case 'i':
			isup = 1; /* Set this flag to 1. Upon first connect bail out */
			break;
		case 'p':
			if (!flag6)
				s_port = atoi(optarg); /* Only check a single port */
			else
				port6 = optarg;
			break;
		case 'u':
			usage(); /* U r help me? */
			return 0;
			break;
		default:
			usage();
			return 1;
			break;
		}

	}

	/* v6 scan pre-empts everything */
	if (flag6)
		check_port6(addr6,port6,"STREAM");

	if (!gotaddr) { /* XXX-jrf: Would rather divine this */
		printf("No address provided\n");
		usage();
		return 1;
	}
		
	/* 
	 * If only checking one port do so and print yay or nay and bag out
	 */
	if (s_port > 0) {
		if (check_port(s_port)) {
			printf("%d is open\n", s_port);
		} else
			printf("%d unavailable\n", s_port);
		
		return 0;
	}

	c = 0; /* it does not... DOES NOT.. hurt to recycle counters */
	/* base case of 0? then proceed to the next port on the list */
	while (portlist[c+1] != 0) {
		if (check_port(portlist[c])) {
			portinfo = getservbyport(htons(portlist[c]), "tcp");
			printf("%d (%s) open\n", portlist[c],(portinfo == NULL) 
			  ? "UNKNOWN" :	portinfo->s_name);

			if (isup == 1) 
				return 0;
		}

		c++;
	}

	return 0;
}



/*
 * indy_setaddr: Set the address to probe/scan
 */
void indy_setaddr (char *arg)
{
	int o1; /* ipv4 octect 1 */
	int o2; /* ipv4 octect 2 */
	int o3; /* ipv4 octect 3 */
	int o4; /* ipv4 octect 4 */

	struct hostent *host_entry; /* A struct we use internetize an address */

	if (sscanf(arg,"%d.%d.%d.%d",&o1,&o2,&o3,&o4) != 4) {
		host_entry = gethostbyname(arg);
		if (host_entry == NULL) {
			fprintf(stderr,"error: cannot resolve host %s\n",arg);
			exit (0);
		}

		sprintf(indyaddr,"%d.%d.%d.%d",(unsigned char )
			host_entry->h_addr_list[0][0],
			(unsigned char ) host_entry->h_addr_list[0][1],
            (unsigned char ) host_entry->h_addr_list[0][2],
            (unsigned char ) host_entry->h_addr_list[0][3]);
	} else 
		strncpy(indyaddr,arg,(INDY_HOSTLEN-1));
}


/*
 * check_port: Using the global address see if a port can be connected to
 *             If you wish to use this to make your own, a few things to
 *             note. Dealing with blocking is IMPORTANT, that is what all
 *             the fd or FD foo is about. And doing a select test if the
 *             connect is taking awhile is also important. If you don't
 *             then weird things happen, lies basically. 
 */
int check_port (int port)
{
	int s;
	int retval = 0;
	fd_set wset;

	struct sockaddr_in addr;
	struct timeval timeout;

	s = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (s < 0) {
		printf("ERROR: socket() failed\n");
		exit (0);
	}


	addr.sin_family = AF_INET;
	addr.sin_port = htons(port);
	addr.sin_addr.s_addr = inet_addr(indyaddr);

	fcntl(s, F_SETFL, O_NONBLOCK);

	connect(s,(struct sockaddr *) &addr, sizeof(addr));

	timeout.tv_sec = 0;
	timeout.tv_usec = U_TIMEO;
	FD_ZERO(&wset);
	FD_SET(s, &wset);

	if (select(s+1,NULL,&wset,NULL,&timeout) == 1) {
		int so_error;
		socklen_t len = sizeof so_error;

		getsockopt(s, SOL_SOCKET, SO_ERROR, &so_error, &len);

		if (so_error == 0)
			retval++;
	}

    close(s);
	return retval; 
}



static void check_port6(char *addr, char *portstring, char *socktype)
{
	register short int isalive6 = 0;
	struct addrinfo *res;
	struct addrinfo hints;

/* XXX LITMUS
*/
printf("would be scanning addr %s port %s socktype %s\n",
		addr,portstring,socktype);
exit(EXIT_SUCCESS);

	memset(&hints, '\0', sizeof(hints));
	if (socktype == "STREAM")
		hints.ai_socktype = SOCK_STREAM;
	else
		hints.ai_socktype = SOCK_DGRAM;

#ifndef LINUX
	hints.ai_flags = AI_ADDRCONFIG;
#endif

	int e = getaddrinfo(addr, portstring, &hints, &res);
	if (e != 0) {
		printf("Error: %s\n", gai_strerror(e));
		exit(EXIT_FAILURE);
	}

	
    int sock = -1;
    struct addrinfo *r = res;
    for (; r != NULL; r = r->ai_next) {
        sock = socket(r->ai_family, r->ai_socktype, r->ai_protocol);
        if (sock != -1 && connect(sock, r->ai_addr, r->ai_addrlen) == 0) {
            printf("Port %s open on %s\n", portstring, addr);
            ++isalive6;
            break;
        }
    }

    if (sock != -1)
        close(sock);

    freeaddrinfo(res);
    if (sock != -1)
        if (!isalive6) {
            printf
                ("Was able to resolve %s but could not connect to port %s\n",
                 addr, portstring);
            close(sock);
            exit(EXIT_FAILURE);
        }

    close(sock);        /* XXX-jrf: We exit here now as it is 1 port 1 host   */
	exit(EXIT_SUCCESS); /*          mebbe not later to support multiportscans */
}



/*
 * usage - A simple usage print
 */
void usage(void)
{
	printf(PACKAGE " [options][arguments]\n"
		   PACKAGE " [-h|--host addr|host] [-p|--port N]\n"
		   PACKAGE " [-6|-v6] [-i|--isup] [-u|--usage]\n");
}
