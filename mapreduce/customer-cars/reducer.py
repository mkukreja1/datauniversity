#! /usr/bin/env python

import sys

last_cars = None
cars_count = 0

for line in sys.stdin:

    line = line.strip()
    cars, count = line.split("\t")

    count = int(count)
    # if this is the first iteration
    if not last_cars:
        last_cars = cars

    # if they're the same, log it
    if cars == last_cars:
        cars_count += count
    else:
        # 
        result = [last_cars, cars_count]
        if cars_count > 1:
           print("\t".join(str(v) for v in result))
        last_cars = cars
        cars_count = 1

# this is to catch the final value that we output
print("\t".join(str(v) for v in [last_cars, cars_count]))
