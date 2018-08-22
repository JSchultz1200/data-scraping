#!/usr/bin/perl
#
# If you choose to separate all variables into different files then you can use this script to insert them into the database
# Make sure you double check your data integrity, so that one missing line doesn't screw up the rest of your records. 
#
#
use DBI;
use File::Find;
use Cwd;
use Date::Parse qw(str2time);
use DateTime::Format::Strptime qw( );

require "config.pl";

	my $comments_wc = `cat comments | wc -l`;
	my $headlines_wc = `cat headlines | wc -l`;
	my $dates_wc = `cat dates | wc -l`;
	
	if(($comments_wc eq $headlines_wc) && ($comments_wc eq $dates_wc))
	{
		$dates_wc =~ s/\n//;
		print "$dates_wc Matching Comments, Headlines, and Dates...\n";

		my $file = 'dates';
		open $fh, $file or die "Could not open $file: $!";
		my @dates = <$fh>;

		my $file = 'headlines';
		open $fh, $file or die "Could not open $file: $!";
		my @headlines = <$fh>;

        	my $file = 'comments';
        	open $fh, $file or die "Could not open $file: $!";
        	my @comments = <$fh>;
	
		my $file = 'users';
                open $fh, $file or die "Could not open $file: $!";
                my @comments = <$fh>;

		for($x=0; $x<$dates_wc; $x++)
		{
	        	my ($strQuery);
			my $strCategories = "";
			my $dateStatus = @dates[$x];
			$dateStatus =~ s/\n//;

			my $format = DateTime::Format::Strptime->new(
			   pattern   => '%b %d, %Y %I:%M %p',
			   time_zone => 'local',
				on_error  => 'croak',
			);

			my $dateStatusStamp = $format->parse_datetime($dateStatus);
			$dateStatusStamp =~ s/T/ /;

			my $strHeadline = @headlines[$x];
			$strHeadline =~ s/\n//;

			my @arrHeadline = split('\t', $strHeadline);
			my $strUrl = @arrHeadline[0];
			$strUrl =~ s/\n//;

			my $strTitle = @arrHeadline[1];
			$strTitle =~ s/\n//;

			my $intComments = @comments[$x];
			$intComments =~ s/\n//;

	        	# Connect to the database
	        	$dbh = DBI->connect($dsn, $username, $password);

		        # Construct the query
	        	$strQuery = "INSERT INTO stats VALUES('', '" . $dateStatusStamp . "','" . $strUrl . "','" . $strTitle . "','" . $intComments . "','" . $strCategories . "')";

		        # Execute the query
	        	$dbh->do($strQuery);
			print "$x ... $strQuery\n";

		}
	        # Disconnect from the db
        	$dbh->disconnect();
	}
