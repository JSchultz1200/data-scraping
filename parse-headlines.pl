#!/usr/bin/perl
#use strict;
#use warnings;

my $file = 'testpage';
my $headlineText = '';
my $commentStart = 0;

open my $info, $file or die "Could not open $file: $!";

while( my $line = <$info>) 
{   
	if($line =~ m/ctl00_CP1_h1(.*)>(.*)<\/h1>/g)
	{
		print "$2\n";
        }

}

close $info;
