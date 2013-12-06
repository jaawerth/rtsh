#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: rtsh.pl
#
#        USAGE: ./rtsh.pl  
#
#  DESCRIPTION: Reverse Tunneling Restful API
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 12/06/2013 02:33:42 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use Dancer;
use YAML::XS;

set serializer => 'JSON';
set charset => "UTF-8";

my $rteFile = 'route.yml';
my $route = YAML::XS::LoadFile($rteFile);

get '/' => sub {
	return $route;
};

put '/' => sub {
	my %params = request->params;
	if (defined $params{stamp} || undef $route->{stamp}) {
		return "Error! Stamp mismatch." unless (undef $route->{stamp} || $params{stamp} eq $route->{stamp});
		my $stamp = time;
		$route->{remote} = request->address();
		$route->{port} = (defined $params{port}) ? $params{port} : 22;
		$route->{stamp} = time;
		return {status => "1", stamp => $params{stamp}};
	} else {
		return {error => "Whoops! Missing parameters!"};
	}	
};

get '/view' => sub {
	return<<EOF;
<!DOCTYPE html>
<html>
<head><title>Set Interface</title></head>
<body>
<form action="/" method="put">
<input type="submit" value="send"></form>
</body>
</html>
EOF
};
dance;
