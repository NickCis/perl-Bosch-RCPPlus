#! /usr/bin/perl

use strict;
use FindBin qw($Bin);
use lib "$Bin/../lib";

use Getopt::Long;
use Bosch::RCPPlus;
use Bosch::RCPPlus::Commands;

sub usage {
	print "$0 <options> <in/out>\n";
	print "\n";
	print "    --host=<str>           Hostname and port (192.168.1.87:1386)\n";
	print "    -u --username=<str>    Username (service)\n";
	print "    --password=<str>       Password (123456)\n";
	print "    -s --sleep=<integer>   Sleep time between start and end movement\n";
	print "\n";
	return 0;
}

my $Host;
my $Username;
my $Password;
my $Sleep = 2;

GetOptions(
	"host=s" => \$Host,
	"u|username=s" => \$Username,
	"password=s" => \$Password,
	"s|sleep=i" => \$Sleep,
) or exit(usage());

unless ($Host and $Username and $Password) {
	print "Should provide credentials\n";
	usage();
	exit 1;
}

sub main
{
	my ($zoom) = @ARGV;

	if (!$zoom) {
		print "No zoom\n";
		return -1;
	}

	my $client = new Bosch::RCPPlus(
		host => $Host,
		username => $Username,
		password => $Password,
	);

	switch: for ($zoom) {
		/^in$/ && do {
			print 'Zoom in ';

			my $r = $client->cmd(Bosch::RCPPlus::Commands::zoom_in());
			if ($r->error) {
				print "failed\n";
				return -1;
			}

			print "ok\n";

			print "sleeping $Sleep\n";
			sleep $Sleep;

			print 'Movement stop ';
			$r = $client->cmd(Bosch::RCPPlus::Commands::ptz_stop());
			if ($r->error) {
				print "failed \n";
				return -1;
			}

			print "ok\n";
			return 0;
		};

		/^out$/ && do {
			print 'Zoom out ';

			my $r = $client->cmd(Bosch::RCPPlus::Commands::zoom_out());
			if ($r->error) {
				print "failed\n";
				return -1;
			}

			print "ok\n";

			print "sleeping $Sleep\n";
			sleep $Sleep;

			print 'Movement stop ';
			$r = $client->cmd(Bosch::RCPPlus::Commands::ptz_stop());
			if ($r->error) {
				print "failed \n";
				return -1;
			}

			print "ok\n";
			return 0;
		};

		print "Unknown zoom: $zoom\n";
		return -1;
	}

	return 0;
}

exit(main());
