use strict;
use warnings;
use List::Util qw(sum any min max);
use JSON;

sub game {
    my $N = $_[0];
    my $M = $_[1];

    my %score = ();
    @score{(1..$N)} = (0) x $N;

    my @ring = (0);
    my $pos = 0;
    my $len = 1;
    for (my $m = 1; $m <= $M; $m++) {
	if ($m%100000 == 0) {
	    print "$m\n";
	}
	if ($m%23 == 0) {
	    $pos = ($pos - 7) % $len;
	    $score{$m%$N+1} += $m + splice @ring , $pos , 1;
	    $len--;
	    $pos = $pos % $len;
	}
	else {
	    $pos = ($pos + 1) % $len + 1;
	    splice @ring , $pos , 0 , $m;
	    $len++;
	}
	#print "$pos:   ";
	#print "@ring\n";
    } 

    #print "@ring\n";
    return %score;
}



foreach my $line (<STDIN>) {
    my ($N,$M) = $line =~ /(\d+) players; last marble is worth (\d+) points/;
    print "$N players, $M marbles\n";
    
    my %score = game $N,$M;
    #print to_json \%score , {pretty=>1,canonical=>1};
    
    my $high = max values %score;
    my $winner = grep { $score{$_} == $high } keys %score;
    
    print "The winner is $winner with score: $high\n";
}


