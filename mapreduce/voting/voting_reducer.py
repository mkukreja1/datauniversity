#! /usr/bin/env python

import sys

last_candidate = None
candidate_count = 0

for line in sys.stdin:

    line = line.strip()
    candidate, count = line.split("\t")

    count = int(count)
    # if this is the first iteration
    if not last_candidate:
        last_candidate = candidate

    # if they're the same, log it
    if candidate == last_candidate:
        candidate_count += count
    else:
        # 
        result = [last_candidate, candidate_count]
        if candidate_count > 1:
           print("\t".join(str(v) for v in result))
        last_candidate = candidate
        candidate_count = 1

# this is to catch the final value that we output
print("\t".join(str(v) for v in [last_candidate, candidate_count]))
