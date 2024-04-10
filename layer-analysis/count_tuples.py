# -*- coding: utf-8 -*-
from collections import Counter
from itertools import combinations
from database import data

def count_tuples(data, tuple_length):
    tuple_frequencies = Counter()

    for combination, count in data.items():
        if len(combination) >= tuple_length:  # Consider only combinations with at least the desired length
            for tuple_combination in combinations(combination, tuple_length):
                tuple_frequencies[tuple_combination] += count

    # Find the most common tuples
    most_common_tuples = tuple_frequencies.most_common()

    return most_common_tuples

# counting for 3-tuples
most_common_three_tuples = count_tuples(data, 3)
for tuple in most_common_three_tuples:
    print(tuple)

# counting for 2-tuples
most_common_two_tuples = count_tuples(data, 2)
for tuple in most_common_two_tuples:
    print(tuple)
