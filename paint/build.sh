#!/bin/bash

# Quit if an error comes from xa
set -e

# Compile the object file from source, also generates the labels file
xa -l labels.txt -o paint.o65 paint.s

# Create a monitor file from the object code to load at $300
ebd -f paint.o65 -a 768 > PAINT.MON

# Print the labels to the terminal for quick ref
cat labels.txt
