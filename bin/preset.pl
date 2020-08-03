#! /usr/bin/perl

use strict;
use FindBin qw($Bin);
use lib "$Bin/../lib";

use Getopt::Long;
use Bosch::RCPPlus;
use Bosch::RCPPlus::Commands;

sub usage {
	print "$0 <options> <cmd> <scene>\n";
	print "\n";
	print "    --host=<str>           Hostname and port (192.168.1.87:1386)\n";
	print "    -u --username=<str>    Username (service)\n";
	print "    --password=<str>       Password (123456)\n";
	print "\n";
	print "  Available commands:\n";
	print "    check                  Checks if scene exists\n";
	print "    show                   Shows scene\n";
	print "    set                    Stores scene\n";
	print "\n";
	return 0;
}

my $Host;
my $Username;
my $Password;

GetOptions(
	"host=s" => \$Host,
	"u|username=s" => \$Username,
	"password=s" => \$Password,
) or exit(usage());

unless ($Host and $Username and $Password) {
	print "Should provide credentials\n";
	usage();
	exit 1;
}

sub main
{
	my ($action, $scene) = @ARGV;

	if (!$action) {
		print "No action\n";
		usage();
		return -1;
	}

	unless ($scene) {
		print "No scene\n";
		usage();
		return -1;
	}

	my $client = new Bosch::RCPPlus(
		host => $Host,
		username => $Username,
		password => $Password,
	);

	switch: for ($action) {
		/^check$/ && do {
			print "Scene: $scene ";

			my $cp = $client->cmd(Bosch::RCPPlus::Commands::check_preset($scene));
			if ($cp->error) {
				print "check_preset failed\n";
				return -1;
			}

			my $ipm = $client->cmd(Bosch::RCPPlus::Commands::is_preset_mapped($scene));
			if ($ipm->error) {
				print "is_preset_mapped failed\n";
				return -1;
			}

			if ($cp->result or $ipm->result) {
				print "exists\n";
			} else {
				print "doesnt exist\n";
			}

			return 0;
		};

		/^show$/ && do {
			print "Show scene $scene ";
			my $r = $client->cmd(Bosch::RCPPlus::Commands::show_scene($scene));

			if ($r->error) {
				print 'Error: ' . $r->error . "\n";
				return -1;
			}

			print "Ok\n";
			return 0;
		};

		/^set$/ && do {
			print "Set scene $scene ";
			my $r = $client->cmd(Bosch::RCPPlus::Commands::set_scene($scene));

			if ($r->error) {
				print 'Error: ' . $r->error . "\n";
				return -1;
			}

			print "Ok\n";
			return 0;
		};

		print "Unknown action: $action\n";
		return -1;
	}

	return 0;
}

exit(main());
