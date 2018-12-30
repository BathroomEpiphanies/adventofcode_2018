use strict;
use warnings;
use List::Util qw(sum max);
use JSON;

my ($guard, $fall, $wake, %sleep);
foreach my $line (<STDIN>) {
    if ($line =~ m/Guard/) {
        ($guard) = $line =~ /.*#(\d+)/;
    }
    elsif($line =~ m/falls/) {
        ($fall) = $line =~ /\[\d+-\d+-\d+ \d+:(\d+)\].*/;
    }
    elsif($line =~ m/wakes/) {
        ($wake) = $line =~ /\[\d+-\d+-\d+ \d+:(\d+)\].*/;
        #print "$guard $fall-$wake\n";
        for (my $m = $fall; $m < $wake; $m++) {
            $sleep{$guard}{$m}++;
        }
    }
}

# Find sleepiest guard
my %total;
foreach $guard (keys %sleep) {
    $total{$guard} = sum (values %{$sleep{$guard}});
}

#print to_json \%sleep, {pretty => 1, canonical => 1};

($guard) = grep { $total{$_} == max values %total } 
           keys %total;

print "Sleepiest guard: #$guard\nTotal slept minutes: $total{$guard}\n";


# Find his sleepiest minute
my ($minute) = grep { $sleep{$guard}{$_} == max values %{$sleep{$guard}} } 
                    keys %{$sleep{$guard}};

print "His sleepies minute was: 00:$minute\nWhen he slept: $sleep{$guard}{$minute} times\n";
printf "This is encoded as: %d\n\n" , $guard * $minute;


# Find the guard with the sleepiest minute
my %maximum;
foreach $guard (keys %sleep) {
    $maximum{$guard} = max values %{$sleep{$guard}};
}

($guard) = grep { $maximum{$_} == max values %maximum } keys %maximum;
($minute) = grep { $sleep{$guard}{$_} == max values %maximum } keys %{$sleep{$guard}};

print "#$guard was the guard who slept the most\ntimes during a particular minute,\n$sleep{$guard}{$minute} times during 00:$minute\n";
printf "This is encoded as: %d\n" , $guard * $minute;
