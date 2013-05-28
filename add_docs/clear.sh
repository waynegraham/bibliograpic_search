#!/bin/bash

curl http://sds6.itc.virginia.edu:8080/solr/bsuva//update?commit=true -H "Content-Type: text/xml" --data-binary '<delete><query>*:*</query></delete>'
