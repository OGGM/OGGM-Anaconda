setlocal
cd %~dp0
set CONDA_BLD_PATH=%cd%\..\conda-bld
set ANACONDA_API_TOKEN=%ANACONDA_AUTH_TOKEN%

call:cb %* .\pytest-mpl || exit /B 1
call:cb %* .\motionless || exit /B 1
call:cb %* .\salem || exit /B 1
call:cb %* .\oggm-deps || exit /B 1
call:cb %* .\oggm || exit /B 1

exit /B %ERRORLEVEL%

:cb
if DEFINED CONDA_BUILD_PY (
conda build --python %CONDA_BUILD_PY% --channel conda-forge --channel defaults --override-channels %* || exit /B 1
) else (
conda build --python 3.6 --channel conda-forge --channel defaults --override-channels %* || exit /B 1
)
exit /B 0
