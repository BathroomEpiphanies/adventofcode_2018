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

my %opmap = (
   0, 2,
   1,14,
   2, 8,
   3,15,
   4,12,
   5, 3,
   6, 6,
   7, 5,
   8, 0,
   9, 4,
  10,13,
  11,10,
  12, 1,
  13,11,
  14, 9,
  15, 7
);
 
my $reg = [0,0,0,0];
my $i = 0;
while (my $line = <STDIN>) {
    printf "%d\n" , $i++;
    chomp($line);
    my @op = $line =~ /(-?\d+)/g;
    $op[0] = $opmap{$op[0]};
    #$op[0] = int($op[0]);
    #print to_json \@op; print "\n";

    $reg = oper($reg,\@op);
    #print to_json $reg; print "\n";
    #print @$reg; print "\n";
}

print "@$reg"; print "\n";
#print to_json $reg , {pretty=>1};
