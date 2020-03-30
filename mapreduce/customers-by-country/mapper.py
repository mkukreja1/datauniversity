#! /usr/bin/env python

import sys

infile= sys.stdin

# Remove the header line
next(infile)

for line in infile:
    line = line.strip()
    unpacked = line.split("|")
    name, city, postalcode, country, maritalstatus, car  = line.split("|")
    results = [country, "1"]
    print("\t".join(results))