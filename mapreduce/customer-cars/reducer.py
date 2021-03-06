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
        if (cars_count > 1 and (last_cars=='BMW' or last_cars=='Mercedes-Benz' or last_cars=='Audi' or last_cars=='Ferrari' or last_cars=='Lexus')):
           print("\t".join(str(v) for v in result))
        last_cars = cars
        cars_count = 1

