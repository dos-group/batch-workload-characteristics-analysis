# -*- coding: utf-8 -*-
from collections import Counter
from itertools import combinations

def count_tuples(data, tuple_length):
    layers_list = data['Layers'].apply(lambda x: x.split(', '))
    tuple_frequencies = Counter()

    for combination in layers_list:
        if len(combination) >= tuple_length:  # Consider only combinations with at least the desired length
            for tuple_combination in combinations(combination, tuple_length):
                # Sort the tuple to ensure order is not important
                sorted_tuple = tuple(sorted(tuple_combination))
                tuple_frequencies[sorted_tuple] += 1

    # Find the most common tuples
    most_common_tuples = tuple_frequencies.most_common()

    return most_common_tuples
