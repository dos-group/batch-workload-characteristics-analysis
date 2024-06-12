import pandas as pd
# Ensure you import the count_tuples function correctly
from .helper_fns import count_tuples

# Load the CSV file
data = pd.read_csv('data/layers.csv')
# Assign appropriate headers to the dataframe
data.columns = ["Title", "Year", "Layers", "BibTex id", "Parameters"]

two_tupel_combinations = count_tuples(data, 2)

three_tupel_combinations = count_tuples(data, 3)


data_layer_combinations = {
    ("Hardware Layer", "Virtualisation Layer", "Performance Layer", "Data Layer"): 1,
    ("Hardware Layer", "Virtualisation Layer", "Performance Layer", "Data Layer", "User Application Layer"): 1,
    ("Hardware Layer", "Big Data Framework Layer"): 3,
    ("Hardware Layer", "Big Data Framework Layer", "Performance Layer"): 4,
    ("Hardware Layer", "Big Data Framework Layer", "Performance Layer", "Data Layer", "User Application Layer"): 3,
    ("Hardware Layer", "Big Data Framework Layer", "Data Layer"): 5,
    ("Hardware Layer", "Big Data Framework Layer", "Data Layer", "User Application Layer"): 2,
    ("Hardware Layer", "Big Data Framework Layer", "User Application Layer"): 2,
    ("Hardware Layer", "Performance Layer"): 5,
    ("Hardware Layer", "Performance Layer", "Data Layer"): 5,
    ("Hardware Layer", "Performance Layer", "User Application Layer"): 1,
    ("Hardware Layer", "Data Layer"): 1,
    ("Hardware Layer", "Virtualisation Layer"): 2,
    ("Virtualisation Layer", "Big Data Framework Layer", "Performance Layer"): 1,
    ("Virtualisation Layer", "Big Data Framework Layer", "Performance Layer", "Data Layer"): 1,
    ("Big Data Framework Layer",): 4,
    ("Big Data Framework Layer", "Performance Layer"): 4,
    ("Big Data Framework Layer", "Performance Layer", "Data Layer"): 1,
    ("Big Data Framework Layer", "Performance Layer", "User Application Layer"): 1,
    ("Big Data Framework Layer", "Data Layer"): 4,
    ("Big Data Framework Layer", "Data Layer", "User Application Layer"): 1,
    ("Big Data Framework Layer", "User Application Layer"): 2,
    ("Big Data Framework Layer", "Virtualisation Layer"): 1,
    ("Performance Layer",): 4,
    ("Performance Layer", "Data Layer"): 1,
    ("Data Layer", "User Application Layer"): 1,
}

## old data with JVM and Cloud Layer
old_data = {
    ("Hardware Layer", "JVM Layer", "Performance Layer", "Data Layer"): 1,
    ("Hardware Layer", "JVM Layer", "Performance Layer", "Data Layer", "User Application Layer"): 1,
    ("Hardware Layer", "Big Data Framework Layer"): 3,
    ("Hardware Layer", "Big Data Framework Layer", "Performance Layer"): 4,
    ("Hardware Layer", "Big Data Framework Layer", "Performance Layer", "Data Layer", "User Application Layer"): 3,
    ("Hardware Layer", "Big Data Framework Layer", "Data Layer"): 5,
    ("Hardware Layer", "Big Data Framework Layer", "Data Layer", "User Application Layer"): 2,
    ("Hardware Layer", "Big Data Framework Layer", "User Application Layer"): 2,
    ("Hardware Layer", "Performance Layer"): 5,
    ("Hardware Layer", "Performance Layer", "Data Layer"): 5,
    ("Hardware Layer", "Performance Layer", "User Application Layer"): 1,
    ("Hardware Layer", "Data Layer"): 1,
    ("Hardware Layer", "Cloud Layer"): 1,
    ("Hardware Layer", "Virtualisation Layer"): 1,
    ("JVM Layer", "Big Data Framework Layer", "Performance Layer"): 1,
    ("JVM Layer", "Big Data Framework Layer", "Performance Layer", "Data Layer", "Cloud Layer"): 1,
    ("Big Data Framework Layer",): 4,
    ("Big Data Framework Layer", "Performance Layer"): 4,
    ("Big Data Framework Layer", "Performance Layer", "Data Layer"): 1,
    ("Big Data Framework Layer", "Performance Layer", "User Application Layer"): 1,
    ("Big Data Framework Layer", "Data Layer"): 4,
    ("Big Data Framework Layer", "Data Layer", "User Application Layer"): 1,
    ("Big Data Framework Layer", "User Application Layer"): 2,
    ("Big Data Framework Layer", "Virtualisation Layer"): 1,
    ("Performance Layer",): 4,
    ("Performance Layer", "Data Layer"): 1,
    ("Data Layer", "User Application Layer"): 1,
}