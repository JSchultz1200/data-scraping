#!/usr/bin/perl
#use strict;
#use warnings;
use DBI;
use File::Find;
use Cwd;
use Date::Parse qw(str2time);
use DateTime::Format::Strptime qw( );

require "config.pl";

# Multi line regex on a 3 gig file costs too much memory for my machine so we need to do line by line

my $file = 'deep.html';
#my $file = 'testpage';

my $commentText = '';
my $commentStart = 0;
my $commentFinal = "";
my $dateTime = "";
my $headLine = "";
my $userName = "";
my $postNumber = "";
my $messageID = "";

open my $info, $file or die "Could not open $file: $!";

while( my $line = <$info>)
{
        if($line =~ m/ctl00_CP1_mbdy_dv/g)
        {
                #print "Comment Start Found\n";
                $commentStart = 1;
        }

        if($line =~ m/\<div id=\'APS_TXT_LINK_450_X_40/g)
        {
                #print "$commentText\n";
                $commentStart = 0;
		$commentFinal = $commentText;
                $commentText = '';

		#$commentFinal =~ s/'/\\'/g;

		$commentFinal =~ s/[^\w:\!\@\#\$\%\^\&\*\(\)\-\=\+\[\]\{\}\'\"\;\;\/\.\,\>\<\s\?]//g;
		$commentFinal =~ s/'/\\'/g;
		$commentFinal =~ s/"/\\"/g;
		$commentFinal =~ s/;/\\;/g;
		$commentFinal =~ s/\)/\\)/g;

		$commentFinal =~ s/\r\n/\\r\\n/g;
		$commentFinal =~ s/\&\#39\;/\\'/g;

	        # Construct the query
                my $strQuery = "INSERT INTO posts VALUES('$messageID', '$userName', '$postNumber', '$dateTime', '$headLine', '$commentFinal');";

                print "$strQuery\n\n";

                $commentText = "";
                $dateTime = "";
                $headLine = "";
                $userName = "";
                $postNumber = "";
                $messageID = "";


        }

        if($commentStart >= 1)
        {
                if($commentStart > 1)
                {
                        $commentText = $commentText . $line;
                }

                $commentStart = $commentStart + 1;
        }


        if($line =~ m/ctl00_CP1_mh1_lblDate(.*)>(.*)<\/span>/g)
        {
		my $dateTimeRaw = $2;
		
		# Date Format Reference: https://metacpan.org/pod/DateTime::Format::Strptime
		#
		my $format = DateTime::Format::Strptime->new(
                           pattern   => '%A, %D %I:%M:%S %P',
                           time_zone => 'local',
                                on_error  => 'croak',
                        );

                my $dateStatusStamp = $format->parse_datetime($dateTimeRaw);
		$dateTime = $dateStatusStamp;

		#print "$dateTime\n";
        }

	if($line =~ m/ctl00_CP1_h1(.*)>(.*)<\/h1>/g)
 	{
		$headLine = $2;
		$headLine =~ s/'/\\'/g;
                $headLine =~ s/"/\\"/g;
		$headLine =~ s/\&\#39\;/\\'/g;
		#print "$headLine\n";
 	}

        if($line =~ m/ctl00_CP1_msb_hlAuthor(.*)>(.*)<\/a>/g)
        {
		$userName = $2;
		$userName =~ s/'/\\'/g;
                $userName =~ s/"/\\"/g;
		#print "$userName\n";
        }

        if($line =~ m/ctl00_CP1_mn1_lbSU(.*)postnum=(.*)\">Last/g)
        {
                $postNumber = $2;
		#print "$postNumber\n";
      	}

	if($line =~ m/<form name=\"aspnetForm\"(.*)message_id=(.*)\" id=\"aspnetForm\">/g)
        {
                $messageID = $2;
		#print "$messageID\n";
        }
}

