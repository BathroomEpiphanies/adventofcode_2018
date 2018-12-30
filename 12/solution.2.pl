use strict;
use warnings;
use JSON;
use List::Util qw(sum);

my $line = <STDIN>;
my @plant = $line =~ /([.#])/g;
<STDIN>;
my %pattern = ();
foreach $line (<STDIN>) {
    my ($p,$q) = $line =~ /([.#]+) => ([.#])/;
    $pattern{$p} = $q;
}

print to_json \%pattern , {pretty=>1,canonical=>1};
splice @plant , 0 , 0 , split('',"..");
printf "%4d " , 0; print join '' , @plant; print "\n";

for (my $i = 1; $i <= 130; $i++) {
    splice @plant , 0 , 0 , split('',"..");
    splice @plant , @plant , @plant , split('',"....");
    #print "@plant\n";
    my @next = ();
    for (my $j = 2; $j <= $#plant - 2; $j++) {
	if ( ! $pattern{join '' , @plant[$j-2..$j+2]} ) {
	    @next[$j-2] = '.';
	}
	else {
	    @next[$j-2] = $pattern{join '' , @plant[$j-2..$j+2]};
	}
	
    }
    @plant = @next;

    my @pot = grep { ord(@plant[$_]) == ord('#') } (0..$#plant);
    my $sum = sum(@pot) - 2*@pot;

    printf "%4d " , $i; print join '' , @plant; print " $sum\n";
    #print "$i "; print " $sum\n";
}
