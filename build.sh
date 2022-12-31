#!/bin/bash

set -e 		# Quit if xa errorsfs

# Assembles to location $300 (decimal 768)
# This can be changed on lines 8 and 9 below as required

xa -l dist/labels.txt -bt768 -o dist/gu20x8.o65 gu20x8.s 
ebd -f dist/gu20x8.o65 -a 768 > dist/gu20x8.mon
cat dist/labels.txt
