#!/bin/bash

# Basic script to continue crawling a site after a crash or accidental DOS
#

filename="diff"

while read -r line
do
    name="$line"
    wget "https://website-to-scrape.com$name" -o deep.log -O - >> deep.html
    sleep 1
done < "$filename"
