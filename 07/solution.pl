use strict;
use warnings;
use List::Util qw(sum any min);
use JSON;

my %prereq = ();
my %remain = ();
my %finish = ();
foreach my $line (<STDIN>) {
    my ($a,$b) = $line =~ /Step ([A-Z]) must be finished before step ([A-Z]) can begin/;
    print "$a -> $b\n";
    
    if(! $prereq{$a}) {
        $prereq{$a} = {};
        $remain{$a} = {};
        $finish{$a} = 1000000;
    }
    $prereq{$b}{$a} = {};
    $remain{$b}{$a} = {};
    $finish{$b} = 1000000;
}

print to_json \%prereq , { pretty => 1 , canonical => 1 };

#while (%remain) {
#    my @avail = grep { scalar(%{$remain{$_}}) == 0 } keys %remain;
#    @avail = sort @avail;
#    my $next = $avail[0];
#    print $next;
#    
#    delete $remain{$next};
#    foreach my $key (keys %remain) {
#        delete $remain{$key}{$next};
#    }
#}
#print "\n";
#exit;

my @queue = (0,0);

my $i = 0;
#while (%remain) {
while ($i < 8) {
    $i++;

    my @avail = grep { scalar(%{$remain{$_}}) == 0 } keys %remain;
    @avail = sort @avail;
    my $next = $avail[0];
    print "$next\n";
    
    my @hej = keys $prereq{$next};
    print "@hej\n";
    
    my $m = (min $finish{keys %{$prereq{$next}}});
    my $t = (shift @queue) + $m + (ord($next) - ord('A') + 1);
    $finish{$next} = $t;
    push @queue , $t;

    
}
print "\n";

print "@queue\n"
