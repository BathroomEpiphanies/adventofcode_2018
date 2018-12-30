use strict;
use warnings;

# Sum up prime factors of $r2

my $r0 = 0;
#my $r2 = 10551386;
my $r2 = 986;

for (my $r5 = 1; $r5<=$r2; $r5++) {
    for (my $r3 = 1; $r3<=$r2; $r3++) {
        if ($r3*$r5 == $r2) {
            print "$r3 $r5\n";
            $r0 += $r5;
        }
    }    
}

print "$r0\n";

