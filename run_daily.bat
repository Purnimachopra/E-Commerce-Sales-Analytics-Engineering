@echo off
cd /d "C:\Purnima\data engineering"
call venv\Scripts\activate
cd /d "C:\Purnima\data engineering\fakestore_transform"
python run_pipeline.py
pause
