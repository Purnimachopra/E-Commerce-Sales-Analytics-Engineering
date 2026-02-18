import subprocess
import os
import sys

def run_task(command, task_name, cwd=None):
    print(f"\n>>> Starting Task: {task_name}...")
    try:
        # check=True will raise an error if the task fails
        subprocess.run(command, shell=True, check=True, cwd=cwd)
        print(f">>> Task {task_name} COMPLETED successfully.")
    except Exception as e:
        print(f"!!! Task {task_name} FAILED: {e}")
        sys.exit(1)

if __name__ == "__main__":
    # Get the absolute path of the folder where THIS script lives
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    
    # If run_pipeline.py is INSIDE fakestore_transform, 
    # then DBT_PROJECT_DIR should just be BASE_DIR.
    DBT_PROJECT_DIR = BASE_DIR 
    
    print(f"=== PIPELINE STARTING (Root: {BASE_DIR}) ===")

    # Step 1: Ingest (Run from the folder where ingest_data.py lives)
    # If ingest_data.py is one folder UP, use: os.path.dirname(BASE_DIR)
    PARENT_DIR = os.path.dirname(BASE_DIR)
    run_task("python ingest_data.py", "INGESTION", cwd=PARENT_DIR)

    # Step 2: Load
    run_task("python load_to_postgres.py", "LOADING", cwd=PARENT_DIR)

    # Step 3: dbt Transform & Test
    run_task("dbt build --store-failures", "DBT TRANSFORM", cwd=DBT_PROJECT_DIR)

    print("\nPIPELINE SUCCESSFUL!")
