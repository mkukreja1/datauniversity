#! /usr/bin/env python

import sys

last_country = None
country_count = 0

for line in sys.stdin:

    line = line.strip()
    country, count = line.split("\t")

    count = int(count)
    # if this is the first iteration
    if not last_country:
        last_country = country

    # if they're the same, log it
    if country == last_country:
        country_count += count
    else:
        # 
        result = [last_country, country_count]
        if country_count > 1:
           print("\t".join(str(v) for v in result))
        last_country = country
        country_count = 1

# this is to catch the final value that we output
print("\t".join(str(v) for v in [last_country, country_count]))
