setlocal
cd %~dp0
set CONDA_BLD_PATH=%cd%\..\output

call:cb %* .\pytest-runner || exit /B 1
call:cb %* .\python-utils || exit /B 1
call:cb %* .\progressbar2 || exit /B 1
REM call:cb %* .\fiona || exit /B 1
REM call:cb %* .\rasterio || exit /B 1
call:cb %* .\descartes || exit /B 1
call:cb %* .\geopandas || exit /B 1
call:cb %* .\motionless || exit /B 1
call:cb %* .\salem || exit /B 1
call:cb %* .\cleo || exit /B 1
call:cb %* .\oggm || exit /B 1

exit /B %ERRORLEVEL%

:cb
if DEFINED CONDA_BUILD_PY (
conda build --no-anaconda-upload --python %CONDA_BUILD_PY% --channel conda-forge --channel defaults --override-channels %* || exit /B 1
) else (
conda build --no-anaconda-upload --python 3.4 --channel conda-forge --channel defaults --override-channels %* || exit /B 1
)
exit /B 0
