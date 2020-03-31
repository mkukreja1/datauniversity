#! /usr/bin/env python

import sys

infile= sys.stdin

for line in infile:
    line = line.strip()
    unpacked = line.split("|")
    name, city, postalcode, country, maritalstatus, car  = line.split("|")
    results = [car, "1"]
    print("|".join(results))
