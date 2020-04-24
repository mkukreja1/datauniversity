#! /usr/bin/env python

import sys

infile= sys.stdin

# Remove the header line
#next(infile)

for line in infile:
    line = line.strip()
    unpacked = line.split("|")
    id, state, candidate = line.split("|")
    results = [candidate, "1"]
    print("\t".join(results))
