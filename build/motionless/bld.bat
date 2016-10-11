set PYTHONDONTWRITEBYTECODE=1
pip install "%CD%"
if errorlevel 1 exit 1
