setlocal
cd %~dp0
set CONDA_BLD_PATH=%cd%\..\output

call:cb %* .\descartes || exit /B 1
call:cb %* .\geopandas || exit /B 1
call:cb %* .\motionless || exit /B 1
call:cb %* .\salem || exit /B 1
call:cb %* .\cleo || exit /B 1
call:cb %* .\oggm || exit /B 1

exit /B %ERRORLEVEL%

:cb
conda build --no-anaconda-upload --python 3.5 --channel defaults --channel ioos --channel oggm --override-channels %* || exit /B 1
conda build --no-anaconda-upload --python 2.7 --channel defaults --channel ioos --channel oggm --override-channels %* || exit /B 1
exit /B 0
