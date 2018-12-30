use strict;
use warnings;
use List::Util qw(sum any);

my @boxes = ();
my $A = 0;
my $B = 0;
foreach my $box (<>) {
    push @boxes , $box;
    my %chars = ();
    foreach my $char (split // , $box) { 
        $chars{$char}++;
    }
    $A += any { $_ == 2 } (values %chars);
    $B += any { $_ == 3 } (values %chars);
}
printf "%d\n" , $A*$B;

foreach my $box1 (@boxes) {
    foreach my $box2 (@boxes) {
        if( ( $box1 ^ $box2 ) =~ tr/\0//c == 1 ) {
            print "$box1$box2\n";
        }
    }
}
