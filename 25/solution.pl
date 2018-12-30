use strict;
use warnings;
use JSON;
use List::Util qw(any);




my @star = ();
foreach my $line (<STDIN>) {
    my ($x,$y,$z,$w) = $line =~ /(-?\d+)/g;
    push @star , {x=>$x,y=>$y,z=>$z,w=>$w};
}

#print to_json \@star,{pretty=>1,canonical=>1};
print "star: @star\n";

sub dist {
    my ($s,$t) = @_;
    return abs($s->{x}-$t->{x}) + abs($s->{y}-$t->{y}) + abs($s->{z}-$t->{z}) + abs($s->{w}-$t->{w});
}

my $count = 0;
while (@star) {
    $count++;

    my @constellation = ();

    my @old = splice @star , 0 , 1;

    my @new = ();
    do {
        @new = ();
        
        my $i = 0;
        while ($i <= $#star) {
            
            if ( any { dist( $star[$i] , $_ ) <= 3 } @old ) {
                my @s = splice @star , $i , 1;
                push @new , @s;
            }
            else {
                $i++;
            }
        }
        push @constellation , splice @old , 0;
        @old = @new;
    } while (@new);

    printf "Constellation:\n%s\n\n" , join "\n" , @constellation;
    #print to_json \@constellation,{pretty=>1}; print "\n";
}

printf "Number of costellations: %d\n" , $count;
