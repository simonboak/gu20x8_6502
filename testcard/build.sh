#!/bin/bash

set -e 		# Quit if xa errorsfs

xa -l labels.txt testcard.s
ebd -f a.o65 -a 768 > testcard.mon
rm a.o65
cat labels.txt
