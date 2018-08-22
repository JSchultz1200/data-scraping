
# Easy Data Scraping Utils

Requires Perl and bash. Data scraping may violate the law and risk you personal litigation. Be smart.


crawl.sh 

> Downloads your pages into one huge html document.


continueCrawl.sh

> If your download gets cancelled you can use this to continue it after you parse out the list of links not downloaded.


link-extractor.pl - Extract only html a href tag links.

parse-dates.pl - Extract the dates.

parse-headlines.pl - Extract headline code by regex.



parseMessageToDB.pl - Extract all "messages" (user comments) from a file and return a series of SQL insert statements.

parsePreviewToDB.pl - Extract a series of variables from a file and return a series of SQL insert statements.

Downloading all message data from a forum, or website, requires significantly more bandwidth.
