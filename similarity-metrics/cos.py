import numpy as np
from sklearn.metrics.pairwise import cosine_similarity

# Formel zur bestimmung der sinusähnlichkeit
def cosine_similarity(hist1, hist2):
    # Convert lists to numpy arrays
    hist1 = np.array(hist1)
    hist2 = np.array(hist2)
    
    # Calculate the dot product and the norms (magnitudes) of the histograms
    dot_product = np.dot(hist1, hist2)
    norm_hist1 = np.linalg.norm(hist1)
    norm_hist2 = np.linalg.norm(hist2)

    # Calculate the cosine similarity
    # Skalarprodukt / (Länge des Vektors 1 * Länge des Vektors 2)
    similarity = dot_product / (norm_hist1 * norm_hist2)
    
    return similarity

# Example histograms for CPU %idle (first 10 bins) and memory utilization (next 10 bins)
job1_histogram = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105]
job2_histogram = [12, 18, 22, 28, 32, 38, 42, 48, 52, 58, 62, 68, 72, 78, 82, 88, 92, 98, 102, 108]

# Definiere die Arrays
x = np.linspace(-2 * np.pi, 2 * np.pi, 20)
y = np.linspace(-2 * np.pi, 2 * np.pi, 20)

# Umformen der Arrays in die Form (1, n), da cosine_similarity 2D-Arrays erwartet

# Calculate and print the cosine similarity
similarity = cosine_similarity(x, y)
print(f"Cosine Similarity: {similarity}")
