import requests
import pandas as pd
import os

# Use absolute path relative to the script location
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
RAW_DIR = os.path.join(SCRIPT_DIR, "raw_data")

if not os.path.exists(RAW_DIR):
    os.makedirs(RAW_DIR)
    print(f"Created folder at: {RAW_DIR}")



def fetch_and_save(endpoint):
    url = f"https://fakestoreapi.com/{endpoint}"
    print(f"Fetching {endpoint}...")
    
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        # Convert JSON to DataFrame
        df = pd.DataFrame(data)
        # Save as CSV
        file_path = os.path.join(RAW_DIR, f"{endpoint}.csv")
        df.to_csv(file_path, index=False)
        print(f"Successfully saved {len(df)} rows to {file_path}")
    else:
        print(f"Failed to fetch {endpoint}. Status: {response.status_code}")

# Execute for all main endpoints
if __name__ == "__main__":
    endpoints = ["products", "users", "carts"]
    for e in endpoints:
        fetch_and_save(e)
