#!/usr/bin/perl
#use strict;
#use warnings;

# Parse a series of page variables to SQL INSERT queries.
# Mass insert and ssh console logging is faster and easier to debug. 
#
#
use DBI;
use File::Find;
use Cwd;
use Date::Parse qw(str2time);
use DateTime::Format::Strptime qw( );

require "config.pl";

# Multi line regex on a 3 gig file costs too much memory for my machine so we need to do line by line

my $file = 'boards/hrdn/hrdn-totals.html';
#my $file = 'testpage';

my $dateTime = "";
my $headLine = "";
my $userName = "";
my $postNumber = "";
my $messageID = "";
my $forumName = "";
my $pageID = "";
my $debug = 0;

open my $info, $file or die "Could not open $file: $!";

while( my $line = <$info>)
{
        if($line =~ m/<td style="white-space:nowrap;">(.*)<\/td>/g)
        {
		my $dateTimeRaw = $1;
		
		# Date Format Reference: https://metacpan.org/pod/DateTime::Format::Strptime
		#
		my $format = DateTime::Format::Strptime->new(
                           pattern   => '%D %I:%M:%S %P',
                           time_zone => 'local',
                                on_error  => 'croak',
                        );

                my $dateStatusStamp = $format->parse_datetime($dateTimeRaw);
		$dateTime = $dateStatusStamp;

		if($debug == 1)
		{
			print "$dateTime\n";
		}
        }

	if($line =~ m/\<a id=\"ctl00_CP1_gv_ctl(.*)_hlSub(.*)message_id=(.*)\"\>(.*)\<\/a\>/g)
 	{
		$headLine = $4;
		$headLine =~ s/'/\\'/g;
                $headLine =~ s/"/\\"/g;
		$headLine =~ s/\&\#39\;/\\'/g;
		$headLine =~ s/[^\w:\!\@\#\$\%\^\&\*\(\)\-\=\+\[\]\{\}\'\"\;\;\/\.\,\>\<\s\?]//g;

		$messageID = $3;

		if($debug == 1)
		{
			print "$headLine\n";
			print "$messageID\n";
		}
 	}

	if($line =~ m/\<a id=\"ctl00_CP1_gv_ctl(.*)_hlPost(.*)\"\>(.*)\<\/a\>/g)
        {
		$userName = $3;
		$userName =~ s/'/\\'/g;
                $userName =~ s/"/\\"/g;

		if($debug == 1)
		{
			print "$userName\n";
		}
        }

        if($line =~ m/\<span id=\"ctl00_CP1_gv_ctl(.*)_lpost\"\>(.*)\<\/span\>/g)
        {
                $postNumber = $2;
		$postNumber =~ s/\#//g;
		
		if($debug == 1)
		{
			print "$postNumber\n";
		}
      	}

	if($line =~ m/<a id="ctl00_CP1_btop_hlBoard"(.*)href="\/(.*)\/"/g)
	{
		$forumName = $2;
		
		if($debug == 1)
		{
			print "$forumName\n";
		}
	}

	# Construct the query
	if(length($postNumber) >0 && length($forumName) >0 && length($userName) >0 && length($headLine) >0 && length($dateTime) >0 && length($messageID) >0)
	{
                my $strQuery = "INSERT INTO post_previews VALUES('$postNumber', '$forumName', '$headLine', '$userName', '$dateTime', '$messageID');";

		print "$strQuery\n";

		$dateTime = "";
		$headLine = "";
		$userName = "";
		$postNumber = "";
		$messageID = "";
		#Assume existing forum name is okay here
	}
}

