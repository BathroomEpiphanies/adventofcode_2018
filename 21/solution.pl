use strict;
use warnings;
use List::Util qw(sum);
use Time::HiRes qw(usleep);

#my @r = (int 986758,int 0,int 0,int 0,int 0,int 0);
my @r = (int 0,int 0,int 0,int 0,int 0,int 0);

sub oper {
    if    ($_[0] eq'addr') { $r[$_[3]] = int( $r[$_[1]] +  $r[$_[2]]      ); }      
    elsif ($_[0] eq'addi') { $r[$_[3]] = int( $r[$_[1]] +     $_[2]       ); }      
    elsif ($_[0] eq'mulr') { $r[$_[3]] = int( $r[$_[1]] *  $r[$_[2]]      ); }      
    elsif ($_[0] eq'muli') { $r[$_[3]] = int( $r[$_[1]] *     $_[2]       ); }      
    elsif ($_[0] eq'banr') { $r[$_[3]] = int( $r[$_[1]] &  $r[$_[2]]      ); }      
    elsif ($_[0] eq'bani') { $r[$_[3]] = int( $r[$_[1]] &     $_[2]       ); }      
    elsif ($_[0] eq'borr') { $r[$_[3]] = int( $r[$_[1]] |  $r[$_[2]]      ); }      
    elsif ($_[0] eq'bori') { $r[$_[3]] = int( $r[$_[1]] |     $_[2]       ); }      
    elsif ($_[0] eq'setr') { $r[$_[3]] = int( $r[$_[1]]                   ); }      
    elsif ($_[0] eq'seti') { $r[$_[3]] = int(    $_[1]                    ); }      
    elsif ($_[0] eq'gtir') { $r[$_[3]] = int(    $_[1]  >  $r[$_[2]]? 1: 0); }
    elsif ($_[0] eq'gtri') { $r[$_[3]] = int( $r[$_[1]] >     $_[2]?  1: 0); }
    elsif ($_[0] eq'gtrr') { $r[$_[3]] = int( $r[$_[1]] >  $r[$_[2]]? 1: 0); }
    elsif ($_[0] eq'eqir') { $r[$_[3]] = int(    $_[1]  == $r[$_[2]]? 1: 0); }
    elsif ($_[0] eq'eqri') { $r[$_[3]] = int( $r[$_[1]] ==    $_[2]?  1: 0); }
    elsif ($_[0] eq'eqrr') { $r[$_[3]] = int( $r[$_[1]] == $r[$_[2]]? 1: 0); }
}

my $ip = <STDIN>; 
chomp $ip;
$ip =~ s/#ip (\d+)/$1/;

my @program = map { [$_ =~ /(\w+)\s+(\d+)\s+(\d+)\s+(\d+)/] } (<STDIN>);


print "$ip\n";
print "@{$_}\n" foreach @program;

my @count = split // , (0 x @program);

my %set = ();
while ($r[$ip] < @program) {
    #print "ip=$r[$ip] [@r] @{$program[$r[$ip]]}";
    $count[$r[$ip]]++;

    
    if($r[$ip]==28) {
        printf "%d\n" , $r[3];
        if ($set{$r[3]}) {
            printf "found repeated value for r3\n"; 
            exit;
        }
        else {
            $set{$r[3]} = {};
        }
    }
    
    oper(@{$program[$r[$ip]]});
    #print " [@r]\n";
    $r[$ip]++;

    #for (my $i = 0; $i < @program; $i++) {
    #    printf "% 3d % 6d\n" , $i , $count[$i];
    #}
    #print "\n";

    #usleep 1000000;
}

for (my $i = 0; $i < @program; $i++) {
    printf "% 3d % 6d\n" , $i , $count[$i];
}
print "\n";

print "\n@r\n";
printf "%d\n" , sum @count;
