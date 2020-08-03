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
	my $client = new Bosch::RCPPlus(
		host => $Host,
		username => $Username,
		password => $Password,
	);

	my $name = $client->cmd(Bosch::RCPPlus::Commands::name());

	if ($name->error) {
		print "name failed\n";
		return -1;
	}

	print 'Name: ' . $name->result . "\n";

	return 0;
}

exit(main());
