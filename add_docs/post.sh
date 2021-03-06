#!/bin/bash

CORE='bsuva'
FILES='*.xml'
OUTPUT='./'
BASE="http://sds6.itc.virginia.edu:8080/solr"
PROD1='http://sds3.itc.virginia.edu:8080/solr'
PROD2='http://sds4.itc.virginia.edu:8080/solr'
PROD3='http://sds5.itc.virginia.edu:8080/solr'
SERVER=$BASE/$CORE/update
PRODUCTION='quandu_production'

mkdir -p $OUTPUT

for f in $FILES
do
  filename=${f%.*}
  echo "Processing $filename"

  echo Posting $filename to solr server at $SERVER
  curl $SERVER --data-binary @$OUTPUT/$f -H 'Content-type:text/xml; charset=utf-8'

  echo Committing the documents...
  curl $SERVER --data-binary '<commit/>' -H 'Content-type:text/xml; charset=utf-8'

  echo Optimizing
  curl $SERVER --data-binary '<optimize/>' -H 'Content-type:text/xml; charset=utf-8'

done

if [ -z $RAILS_ENV ]; then
  RAILS_ENV='quandu_staging'
fi

echo Environment: $RAILS_ENV

if [ $RAILS_ENV == $PRODUCTION ]; then
  curl $PROD1/admin/cores -F command=RELOAD -F core=$CORE
  curl $PROD2/admin/cores -F command=RELOAD -F core=$CORE
  curl $PROD3/admin/cores -F command=RELOAD -F core=$CORE
else
  curl $BASE/admin/cores -F command=RELOAD -F core=$CORE
fi

echo

