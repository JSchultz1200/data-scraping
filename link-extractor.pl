#!/usr/bin/perl
#
# Basic link extraction
# Change filename to your specifications
#

use DBI;
use File::Find;
use Cwd;

use HTML::LinkExtractor;

my $file = 'deep.html';
open my $info, $file or die "Could not open $file: $!";
my $x = 0;

while( my $line = <$info>)
{   

 my $LX = new HTML::LinkExtractor(undef,undef,1);
 $LX->parse(\$line);
 for my $Link( @{ $LX->links } ) {
	if($$Link{href}=~ m/read_msg.aspx/ ) {
            #print "$$Link{_TEXT} URL $$Link{href}\n";
		print "$$Link{href}\n";
	}
    }
}
