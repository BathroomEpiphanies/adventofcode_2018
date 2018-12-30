use strict;
use warnings;
use List::Util qw(sum any min);
use JSON;

my %prereq = ('@',{});
foreach my $line (<STDIN>) {
    my ($a,$b) = $line =~ /Step ([A-Z]) must be finished before step ([A-Z]) can begin/;
    #print "$a -> $b\n";
    
    if(! $prereq{$a}) {
        $prereq{$a} = {'@',{}};
    }
    $prereq{$b}{$a} = {};
    $prereq{$b}{'@'} = {};
}


my %finish = ('@',0);
my %start  = ('@',-60);
#print to_json \%prereq , { pretty => 1 , canonical => 1 };

my @elfq = (-60,-60,-60,-60,-60);

my @order = ();
my $i = 0;
#while ($i<4) {
while (%prereq) {
    $i++;
     
    my @jobq = grep { scalar(%{$prereq{$_}}) == 0 } keys %prereq;
    print "jobq: @jobq\n";
    print "elfq: @elfq\n";
 
    my $elft = shift @elfq;


    @jobq = grep { $start{$_} <= $elft } @jobq;
    print "jobq: @jobq\n";
    if (scalar(@jobq) == 0) {
        print "hej\n";
        my @time = ();
        @jobq = grep { scalar(%{$prereq{$_}}) == 0 } keys %prereq;
        foreach my $k (@jobq) {
            my $t = $start{$k};
            print "$k $t\n";
            push @time , $start{$k};
        }
        @time = sort { $a <=> $b } @time;
        @jobq = grep { $start{$_} == $time[0] } @jobq;
    }
    @jobq = sort @jobq;
    print "jobq: @jobq\n";

    
    my $next = $jobq[0];
    push @order , $next;
    #my %time = $finish{@jobq};

    print "next: $next\n";
    
    my $t = 0;
    if( $start{$next} < $elft ) {
        $t = 60 + (ord($next)-ord('@')) + $elft;
    }
    else {
        $t = 60 + $start{$next} + (ord($next)-ord('@'));
    }
    
    $finish{$next} = $t;
    push @elfq , $t;
    @elfq = sort { $a <=> $b } @elfq;
    delete $prereq{$next};
    
    foreach my $k (keys %prereq) {
        if ($prereq{$k}{$next}) {
            delete $prereq{$k}{$next};
            if(! $start{$k} || $start{$k} < $t) {
                $start{$k} = $t;
            }
        }
    }


    print to_json \%prereq , { pretty => 1 , canonical => 1 };
    print to_json \%start  , { pretty => 1 , canonical => 1 };
    print to_json \%finish , { pretty => 1 , canonical => 1 };
        
}

print "@order\n";
print "@elfq\n";
