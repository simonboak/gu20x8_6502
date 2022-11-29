#!/bin/zsh

xa -l labels.txt -o paint.o65 paint.s
ebd -f paint.o65 -a 768 > PAINT.MON
cat labels.txt
