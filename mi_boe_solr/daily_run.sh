#!/bin/sh

DAY=`date '+%d'`
MONTH=`date '+%m'`
YEAR=`date '+%Y'`

perl run_scraper.pl $DAY $MONTH $YEAR