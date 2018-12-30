use strict;
use warnings;
use JSON;

#chomp(my $line = <STDIN>);
#my @data = split / / , $line;

chomp(my @data = split / / , <STDIN>);


#print to_json \@data , { pretty => 1 , canonical => 1 };
#print "@data\n";

sub decode {
    my @data = @{$_[0]};
    #print "@data\n";
    
    my $m = shift @data;
    my $n = shift @data;
    
    
    my $sum = 0;
    for (my $i = 1; $i <= $m; $i++) {
        my ($h,$t) = decode (\@data);
        $sum += $h;
        @data = @{$t};        
    }
    for (my $i = 1; $i <= $n; $i++) {
        $sum += shift @data;
    }
    
    return $sum, \@data;
}

my ($sum,$tail) = decode (\@data);
my @tail = @{$tail};
print "$sum [@tail]\n";





sub decode2 {
    my @data = @{$_[0]};
    #print "@data\n";
    
    my $m = shift @data;
    my $n = shift @data;
    
    
    my $sum = 0;
    my %child = ();
    for (my $i = 1; $i <= $m; $i++) {
        my ($h,$t) = decode2 (\@data);
        $child{$i} = $h;
        @data = @{$t};        
    }
    if ($m == 0) {
        for (my $i = 1; $i <= $n; $i++) {
            $sum += shift @data;
        }
    }
    else {
        for (my $i = 1; $i <= $n; $i++) {
            my $j = shift @data;
            if ($child{$j}) {
                $sum += $child{$j};
            }
        }
    }
    
    return $sum, \@data;
}

($sum,$tail) = decode2 (\@data);
@tail = @{$tail};
print "$sum [@tail]\n";
