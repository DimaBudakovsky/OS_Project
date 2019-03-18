#!/usr/bin/perl

use strict;
use warnings;
my $start = 1;
$SIG{USR2} = sub { $start = 0};
$SIG{USR1} = sub {
	warn "SIGNAL CATCHED" . "\n";
	ram_clean();
};

sub ram_clean {
	my @ram_stat = `cat /proc/meminfo | head -n 2`;
	my @ram;
	for (@ram_stat) {
		$_ =~ /(\d+)/;
		push @ram, $1;
	}
	my $ram_percentage = 1 - ($ram[1] / $ram[0]);
	my $flag;
	if ($ram_percentage > 0.9) {
		my $user = substr(`whoami`, 0, 7);
		chomp $user;
		my $ps_output = `ps axo pid,rss,user,comm | sort -k2,2 -n -r | grep $user | grep -v "nautilus" | grep -v "gnome" | head -n 1`;
		$ps_output =~ /(\d+)\s/;
		if ($1 != $$) {
			$flag = system("kill -KILL $1");
			unless ($flag) {
				print "Success"."\n";
			}
		}
	}
}


while ($start) {
	ram_clean();
	sleep 1;
}
