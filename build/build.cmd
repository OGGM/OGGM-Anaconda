cd %~dp0
set CONDA_BLD_PATH=%cd%\..\build-output

call:cb descartes || exit /B 1
call:cb geopandas || exit /B 1
call:cb motionless || exit /B 1
call:cb salem || exit /B 1
call:cb cleo || exit /B 1
call:cb oggm || exit /B 1

pause
exit /B %ERRORLEVEL%

:cb
conda build --no-anaconda-upload --python 3.4 --channel defaults --channel oggm --override-channels %* || exit /B 1
exit /B 0