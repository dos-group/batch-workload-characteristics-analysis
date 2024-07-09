import pandas as pd
import os
import argparse

# Set up argument parser
parser = argparse.ArgumentParser(description='Process some metrics.')
parser.add_argument('--folder', type=str, required=True, help='The folder containing the data.')
args = parser.parse_args()

# Use the folder argument from the command line
folder = args.folder
iterations = range(1, 11)
number_of_workers = 8

# Define the metrics we want to process
metrics = {
    'cpu_usage_report.csv': ['%idle'],
    'memory_usage_report.csv': ['%memused'],
    'io_usage_report.csv': ['bread/s', 'bwrtn/s'],
    'network_usage_report.csv': ['rxkB/s', 'txkB/s']
}

# Detect applications based on existing folders
detected_applications = set()
for iteration in iterations:
    iteration_path = f'data/{folder}/iteration_{iteration}'
    if os.path.exists(iteration_path):
        for app in os.listdir(iteration_path):
            app_path = os.path.join(iteration_path, app)
            if os.path.isdir(app_path):
                detected_applications.add(app)

detected_applications = list(detected_applications)

# Specify applications manually or use detected ones
# applications = ['wordcount']  # Uncomment and modify this line to specify applications manually
applications = detected_applications  # Comment this line if specifying applications manually

# Create the output base directory if it does not exist
output_base_dir = os.path.join(os.getcwd(), 'median', folder)
os.makedirs(output_base_dir, exist_ok=True)

# Function to process files and calculate median values
def process_files(files, metric_columns, report, application, iteration):
    all_dfs = []
    for file in files:
        df = pd.read_csv(file, sep=';')
        df['timestamp'] = pd.to_datetime(df['timestamp'])
        df['timeline'] = (df['timestamp'] - df['timestamp'].min()).dt.total_seconds()
        df['application'] = application
        
        # Calculate overall CPU utilization if the report is 'cpu_usage_report.csv'
        if report == 'cpu_usage_report.csv':
            df['%cpu_utilization'] = 100 - df['%idle']
            df = df[['timeline', 'application', '%cpu_utilization']]
        else:
            df = df[['timeline', 'application'] + metric_columns]
        
        all_dfs.append(df)
    
    combined_df = pd.concat(all_dfs, ignore_index=True)

    if report == 'cpu_usage_report.csv':
        worker_median_df = combined_df.groupby(['timeline', 'application'])['%cpu_utilization'].median().reset_index()
        worker_median_df['iteration'] = iteration
    else:
        worker_median_df = combined_df.groupby(['timeline', 'application'])[metric_columns].median().reset_index()
        worker_median_df['iteration'] = iteration

    return worker_median_df

# Iterate over applications and metrics to process each file
for report, metric_columns in metrics.items():
    all_iterations_dfs = []
    for application in applications:
        for iteration in iterations:
            files = []
            for worker in range(number_of_workers):
                file_path = f'data/{folder}/iteration_{iteration}/{application}/monitoring_data/worker{worker}/{report}'
                if os.path.exists(file_path):
                    files.append(file_path)
            
            if files:
                median_df = process_files(files, metric_columns, report, application, iteration)
                all_iterations_dfs.append(median_df)
    
    # Combine all iteration dataframes
    if all_iterations_dfs:
        combined_iterations_df = pd.concat(all_iterations_dfs, ignore_index=True)
        
        # Calculate the median across iterations
        if report == 'cpu_usage_report.csv':
            final_median_df = combined_iterations_df.groupby(['timeline', 'application'])['%cpu_utilization'].median().reset_index()
        else:
            final_median_df = combined_iterations_df.groupby(['timeline', 'application'])[metric_columns].median().reset_index()
        
        output_filename = f'{report.replace(".csv", "_combined_median.csv")}'
        output_path = os.path.join(output_base_dir, output_filename)
        final_median_df.to_csv(output_path, sep=';', index=False)
