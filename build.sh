#!/bin/zsh

xa -v -l labels.txt testcard.s
ebd -f a.o65 -a 768 > target.mon
rm a.o65
cat labels.txt
