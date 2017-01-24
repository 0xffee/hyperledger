#!/usr/bin/env perl
use REST::Client;
use JSON;
use Data::Dumper;

my $url  = "http://localhost:7050"; # port 7051 for json api
my $rc = REST::Client->new({
	host => $url,
	timeout => 10,
});

my $callobj = {
	jsonrpc => "2.0",
	method => "deploy",
	params  => {
		type => 1,
		chaincodeID => {
			path => "github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02" },
		ctorMsg => {
			Function => "init",
			Args => ["a","1000","b","2000"]
			}	
		},
	id     => 1
};
#print encode_json($callobj)."\n";
#$rc->addHeader('Content-Type','application/json');
#$rc->POST('/chaincode',encode_json($callobj));
#print $rc->responseContent()."\n";
#$res = decode_json($rc->responseContent());
#print $res->{"result"}->{"message"};
#print "\n";

#print "=================The above is REST::Client Solution =================\n";

use Mojo::UserAgent;
my $ua = Mojo::UserAgent->new;
my $tx = $ua->post("$url/chaincode" => {Accept => '*/*'} => json => $callobj);
my $res = decode_json($tx->res->body);
my $cc_id = $res->{"result"}->{"message"};
print "Now query chaincode \n";
my $callobj = {
	jsonrpc => "2.0",
	method => "query",
	params  => {
		type => 1,
		chaincodeID => {
			name => $cc_id
		},
		ctorMsg => {
			function => "query",
			Args => ["b"]
		}	
	},
	id => 5
};
my $tx = $ua->post("$url/chaincode" => {Accept => '*/*'} => json => $callobj);
my $res = decode_json($tx->res->body);
my $balance = $res->{"result"}->{"message"};
print "For SmartContract $cc_id \n";
print Dumper($tx->res->body)." \n";
print "Account A is $balance \n";

print "Now Invoke chaincode \n";
my $callobj = {
	jsonrpc => "2.0",
	method => "invoke",
	params  => {
		type => 1,
		chaincodeID => {
			name => $cc_id
		},
		ctorMsg => {
			Function => "invoke",
			Args => ["a","b","100"]
		}	
	},
	id => 3
};
my $tx = $ua->post("$url/chaincode" => {Accept => '*/*'} => json => $callobj);
my $res = decode_json($tx->res->body);
my $invoked_id = $res->{"result"}->{"message"};
print Dumper($tx->res->body)." \n";
print "invoked is $invoked_id";
print "\n";
