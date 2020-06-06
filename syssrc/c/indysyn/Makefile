# CONFIGURE AS NEEDED
MANPREFIX=/usr/local/share/man/man1
BINDIR=/usr/local/bin

CC=gcc
JUNK=a.out
BINS=indysyn
SRCS=indysyn.c

all: 
	$(CC) -O2 $(SRCS) -o $(BINS)

install: 
	cp $(BINS) $(BINDIR)
#	cp indysyn.1 $(MANPREFIXDIR)

clean:
	rm -f $(JUNK) $(BINS)	

