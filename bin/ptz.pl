#! /usr/bin/perl

use strict;
use FindBin qw($Bin);
use lib "$Bin/../lib";

use Getopt::Long;
use Bosch::RCPPlus;
use Bosch::RCPPlus::Commands;

sub usage {
	print "$0 <options>\n";
	print "\n";
	print "    --host=<str>           Hostname and port (192.168.1.87:1386)\n";
	print "    -u --username=<str>    Username (service)\n";
	print "    --password=<str>       Password (123456)\n";
	print "    -p --pan=<float>       Pan movement (-1 to 1)\n";
	print "    -t --tilt=<float>      Tilt movement (-1 to 1)\n";
	print "    -z --zoom=<float>      Zoom movement (-1 to 1)\n";
	print "    -s --sleep=<integer>   Sleep time between start and end movement\n";
	print "\n";
	return 0;
}

my $Host;
my $Username;
my $Password;
my $Pan = 0;
my $Tilt = 0;
my $Zoom = 0;
my $Sleep = 2;

GetOptions(
	"host=s" => \$Host,
	"u|username=s" => \$Username,
	"password=s" => \$Password,
	"p|pan=f" => \$Pan,
	"t|tilt=f" => \$Tilt,
	"z|zoom=f" => \$Zoom,
	"s|sleep=i" => \$Sleep,
) or exit(usage());

unless ($Host and $Username and $Password) {
	print "Should provide credentials\n";
	usage();
	exit 1;
}

sub main
{
	my $client = new Bosch::RCPPlus(
		host => $Host,
		username => $Username,
		password => $Password,
	);

	print "Checking PTZ";
	my $r = $client->cmd(Bosch::RCPPlus::Commands::ptz_available());
	if ($r->error) {
		print " failed\n";
		return -1;
	}
	print ": " . $r->result . " (will continue ignoring this value)\n";

	print "PTZ($Pan, $Tilt, $Zoom)";
	$r = $client->cmd(Bosch::RCPPlus::Commands::ptz($Pan, $Tilt, $Zoom));
	if ($r->error) {
		print " failed\n";
		return -1;
	}

	print " ok\n";

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
}

exit(main());
