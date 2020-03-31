#! /usr/bin/env python

import sys

last_cars = None
cars_count = 0

for line in sys.stdin:

    line = line.strip()
    cars, count = line.split("|")
    count = int(count)
    # if this is the first iteration

    if not last_cars:
        last_cars = cars
    # if they're the same, log it
    if cars.strip() == last_cars.strip():
        cars_count += count
    else:
        result = [last_cars, cars_count]
		
        if cars_count > 0: 
           print("|".join(str(v) for v in result))
        last_cars = cars
        cars_count = 1

print("|".join(str(v) for v in [last_cars, cars_count]))
