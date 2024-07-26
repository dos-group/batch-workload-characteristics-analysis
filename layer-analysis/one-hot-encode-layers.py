import pandas as pd

# Load the CSV file
input_file_path = 'data/layers.csv'
output_file_path = 'data/layers_one_hot_encoded.csv'

# Read the data
data = pd.read_csv(input_file_path)

# Assign appropriate headers to the dataframe
data.columns = ["Title", "Year", "Layers", "BibTex id", "Parameters"]

# One-hot encode the 'Layers' column
layers_expanded = data['Layers'].str.get_dummies(sep=',')

# Combine the one-hot encoded layers with the original dataframe
data_one_hot_encoded = pd.concat([data, layers_expanded], axis=1).drop(columns=['Layers'])

# Save the transformed data to a new CSV file
data_one_hot_encoded.to_csv(output_file_path, index=False)

print(f"One-hot encoded data saved to {output_file_path}")
