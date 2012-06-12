#1/bin/bash

CORE='bsuva'
FILES='*.xml'
OUTPUT='./add_docs'
BASE="http://sds6.itc.virginia.edu:8080/solr"
SERVER=$BASE/$CORE/update
PRODUCTION='quandu_production'

for f in $OUTPUT/$FILES
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
  echo production stuff
else
  curl $BASE/admin/cores -F command=RELOAD -F core=$CORE
fi

echo
