#!/bin/bash

# Basic pagination crawling script
#
#

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ]
then
	echo "Example Url: https://www.website-to-scrape.com/forum/?start=$p"
	echo "That URL will translate to: https://www.website-to-scrape.com/URL_INLINE/?start=START_NUM"
	echo ""
	echo "Usage: crawl.sh START_NUM END_NUM INCREMENT_BY URL_INLINE outfile"
	exit -1
fi

# START_NUM argument
#
p=$1

# Loop by INCREMENT_BY and continue until we hit the END_NUM
#
while [ $p -le $2 ];
do

# Change the followng URL to your specifications.
#
	wget "https://www.website-to-scrape.com/$4/?start=$p" -O - >> $5

	echo "Downloading page $p..."

# Increment page counter by INCREMENT_BY argument
#
	p=$((p+$3))

# So we don't get banned
#
	sleep 1
done
