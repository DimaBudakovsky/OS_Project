#!/usr/bin/perl

use strict;
use warnings;

$SIG{USR1} = sub {
	warn "SIGNAL CATCHED!!!!";
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
		my $user = `whoami`;
		my $ps_output = `ps axo pid,rss,user | sort -k2,2 -n -r | grep vlad | head -n 1`;
		$ps_output =~ /\s?(\d{4})/;
		$flag = system("kill -KILL $1");
		unless ($flag) {
			print "Success"."\n";
		}
	}
}


while (1) {
	ram_clean();
	sleep 1;
}
