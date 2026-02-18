import pandas as pd
from sqlalchemy import create_engine
import os

# 1. Database Connection String
# Format: postgresql://username:password@localhost:5432/database_name
# Update 'postgres' and 'your_password' with your actual Postgres credentials
engine = create_engine('postgresql://postgres:superpc@localhost:5432/fakestore_dw')

RAW_DIR = "raw_data"

def load_csv_to_postgres(file_name, table_name):
    file_path = os.path.join(RAW_DIR, f"{file_name}.csv")
    
    if os.path.exists(file_path):
        print(f"Loading {file_path} into table '{table_name}'...")
        # Read CSV
        df = pd.read_csv(file_path)
        
        # Load to Postgres (replace table if it exists)
        # We use 'stg_' prefix for "Staging" tables
        
        df.to_sql(f"stg_{table_name}", engine, if_exists='replace', index=False)
        print(f"Successfully loaded {len(df)} rows.")
    else:
        print(f"File {file_path} not found.")

if __name__ == "__main__":
    load_csv_to_postgres("products", "products")
    load_csv_to_postgres("users", "users")
    load_csv_to_postgres("carts", "carts")
