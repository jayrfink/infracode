#ifndef INDYSYN_H
#define INDYSYN_H

#include <errno.h>
#include <getopt.h>
#include <unistd.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <fcntl.h>
#include <argp.h>

#include <arpa/inet.h>

#include <netinet/in_systm.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/udp.h>

#include <sys/types.h>
#include <sys/socket.h>

#include <netdb.h>

#define PACKAGE "indysyn" /* Used in other places      */
#define INDY_HOSTLEN 256  /* Maximum len of an address */

int U_TIMEO = 300000;        /* 0.3 seconds seems to work well-mostly */
char indyaddr[INDY_HOSTLEN]; /* The address to be scanned             */

/* A relatively common portlist. A 0 must be at the end! 
   The 0 is used for the base case of a recursive while() */
static int portlist [] = { 22, 80, 445, 25, 37, 53, 111, 113, 139, 21, 42, 67,
                           109, 110, 115, 137, 138, 161, 389, 443, 873, 0 };

/* Protos */
void indy_setaddr (char *); /* Converts FQDN or IP to internet address */
int  check_port   (int);    /* Checks a single remote host port        */
void usage        (void);   /* Ye old "I-is-need-helps stuff           */
static void check_port6 (char *, char *, char *); /* ipv6 single port  */

#endif
