#/usr/bin/env perl

use strict;
use warnings;

use REST::Client;
use JSON;
use Data::Dumper;

my $url = "http://localhost:7050";
my $rc = REST::Client->new(
	host => $url,
	timeout => 10,
);

my $BlockNumber_url = '/chain';
my $BlockSerialNumber_url = '/chain/blocks';
#$rc->GET('/network/peers');
$rc->GET('/chain');
print $rc->responseContent(),"\n";
my $Hash_BlockNumber = decode_json($rc->responseContent());
my $BlockNumber = $Hash_BlockNumber->{'height'};
for( my $i=1 ;$i < $BlockNumber+1;$i++) {
	print "====  The Serial $i Block =============\n";
	my $SerialNumber_url = $BlockSerialNumber_url."/"."$i";
	$rc->GET("$SerialNumber_url");
	print Dumper(decode_json($rc->responseContent())),"\n";
}
