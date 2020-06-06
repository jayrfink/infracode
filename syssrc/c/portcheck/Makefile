CC=cc

all: portcheck 

portcheck:
	${CC} $@_main.c -o $@

clean:
	rm -f a.out portcheck 

rebuild: clean all
