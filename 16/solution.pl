use strict;
use warnings;
use Switch;
use JSON;

sub oper {
    my ($r,$o) = @_;
    #print "oper:\n@$r\n@$o\n";
    switch($o->[0]) {
        case  0 { $r->[$o->[3]] = $r->[$o->[1]] +  $r->[$o->[2]]; }         # addr
        case  1 { $r->[$o->[3]] = $r->[$o->[1]] +       $o->[2];  }         # addi
        case  2 { $r->[$o->[3]] = $r->[$o->[1]] *  $r->[$o->[2]]; }         # mulr
        case  3 { $r->[$o->[3]] = $r->[$o->[1]] *       $o->[2];  }         # muli
        case  4 { $r->[$o->[3]] = $r->[$o->[1]] &  $r->[$o->[2]]; }         # banr
        case  5 { $r->[$o->[3]] = $r->[$o->[1]] &       $o->[2];  }         # bani
        case  6 { $r->[$o->[3]] = $r->[$o->[1]] |  $r->[$o->[2]]; }         # borr
        case  7 { $r->[$o->[3]] = $r->[$o->[1]] |       $o->[2];  }         # bori
        case  8 { $r->[$o->[3]] = $r->[$o->[1]];                  }         # setr
        case  9 { $r->[$o->[3]] =      $o->[1];                   }         # seti
        case 10 { $r->[$o->[3]] =      $o->[1]  >  $r->[$o->[2]]? 1: 0; }   # gtir
        case 11 { $r->[$o->[3]] = $r->[$o->[1]] >       $o->[2]?  1: 0; }   # gtri
        case 12 { $r->[$o->[3]] = $r->[$o->[1]] >  $r->[$o->[2]]? 1: 0; }   # gtrr
        case 13 { $r->[$o->[3]] =      $o->[1]  == $r->[$o->[2]]? 1: 0; }   # eqir
        case 14 { $r->[$o->[3]] = $r->[$o->[1]] ==      $o->[2]?  1: 0; }   # eqri
        case 15 { $r->[$o->[3]] = $r->[$o->[1]] == $r->[$o->[2]]? 1: 0; }   # eqrr
    }
    #print "@$r\n";
    return $r;
}


my %opmap = ();
for (my $i=0; $i<16; $i++) {
    for (my $j=0; $j<16; $j++) {
        $opmap{$i}{$j} = {};
    }
}

my $N = 0;
while (my $line = <STDIN>) {
    chomp($line);
    next if (length $line) == 0;
   
    my @in = $line =~ /(-?\d+)/g;
    $line = <STDIN>; chomp($line);
    my @op = $line =~ /(-?\d+)/g;
    $line = <STDIN>; chomp($line);
    my @ou = $line =~ /(-?\d+)/g;

    #print "@in\n@op\n@ou\n";

    my $pp = $op[0];
    my $n = 0;
    foreach my $i (0..15) {
        @op[0] = $i;
        my @ii = ();
        push @ii , @in;
        my $r = oper(\@ii,\@op);
        my $test = 1;
        for (my $j = 0; $j < 4; $j++) {
            $test &&= $r->[$j] == $ou[$j];
        }
        if ($test) {
            #printf "op $i\n";
            $n++;
        }
        else {
            delete $opmap{$pp}{$i};
        }
    }
    if ($n >= 3) {
        $N++;
        print "$n\n";
    }

}

print to_json \%opmap , {pretty=>1};
#exit;
my $change = 0;
do {
    $change = 0;
    for (my $i = 0; $i < 16; $i++) {
        my @key = keys %{$opmap{$i}};
        if (scalar @key == 1) {
            
            for (my $j = 0; $j < 16; $j++) {
                next if $i == $j;
                if($opmap{$j}{$key[0]}) {
                    print "deleteing $i $j\n";
                    delete $opmap{$j}{$key[0]};
                    $change = 1;
                }
            }
        }
    }
    print to_json \%opmap , {pretty=>1};
} while ($change);
    
    

print "$N\n";

#my $reg = [0,0,0,0];
#my $i = 0;
#while (my $line = <STDIN>) {
#    printf "%d\n" , $i++;
#    chomp($line);
#    my @op = $line =~ /(-?\d+)/g;
#    $op[0] = 
#    #$op[0] = int($op[0]);
#    #print to_json \@op; print "\n";
#
#    my $reg = oper($reg,\@op);
#    #print to_json $reg; print "\n";
#    #print @$reg; print "\n";
#}
#
#print "@$reg"; print "\n";
