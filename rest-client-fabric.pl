#/usr/bin/env perl

use strict;
use warnings;

use REST::Client;
use Data::Dumper;

my $url = "http://localhost:7050";
my $rc = REST::Client->new(
	host => $url,
	timeout => 10,
);

$rc->GET('/network/peers');
print $rc->responseContent(),"\n";

