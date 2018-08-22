#!/usr/bin/perl
#use strict;
#use warnings;

# Multi line regex on a 3 gig file costs too much memory for my machine so we need to do line by line

my $file = 'testpage';
my $commentText = '';
my $commentStart = 0;

open my $info, $file or die "Could not open $file: $!";

while( my $line = <$info>) 
{   
	if($line =~ m/ctl00_CP1_mbdy_dv/g)
	{
		print "Comment Start Found\n";
		$commentStart = 1;
	}

	if($commentStart == 1)
	{
		$commentText = $commentText . $line;
	}

	if($line =~ m/\<div id=\'APS_TXT_LINK_450_X_40/g)
        {
                print "$commentText\n";
                my $commentStart = 0;
		my $commentText = '';
        }

}

close $info;
