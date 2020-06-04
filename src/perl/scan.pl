#!/usr/bin/perl
use IO::Socket;
sub scandev {
    # XXX Not sure this is needed. 
    $| = 1; # Flushes print buffer
    my $target = shift; # ip addr to scan

    my @portlist = ( 21, 22, 25, 37, 42, 53, 67, 80, 109,
        110, 111, 115, 137, 138, 139, 161, 389, 873, 443);

    foreach(@portlist) {
        #\r will refresh the line
        $port = $_;

        # Connect to port number
        $socket = IO::Socket::INET->new(
            PeerAddr => $target , PeerPort => $port ,
            Proto => 'tcp' , Timeout => 1);

        #Check connection
        if( $socket ) {
            print "\r $port\topen\n" ;
        } else {
            # No-op
        }
    }
}

scandev($_);
