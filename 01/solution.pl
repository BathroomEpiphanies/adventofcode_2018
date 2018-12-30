use strict;
use List::Util qw(sum);

my @inc = ();
foreach my $i (<STDIN>) {
    push @inc , $i;
}
    
printf "Sum of incs: %d\n" , (sum @inc);

my $freq = 0;
my %seen = ();
for (my $i = 0; ! exists $seen{"$freq"}; $i++) {
    $seen{"$freq"} = ();
    $freq += $inc[$i % scalar(@inc)];
}

print "Repeated frequency: $freq\n";
