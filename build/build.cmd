setlocal
cd %~dp0
set CONDA_BLD_PATH=%cd%\..\conda-bld

call:cb %* .\pytest-mpl || exit /B 1
call:cb %* .\salem || exit /B 1
call:cb %* .\oggm-deps || exit /B 1
call:cb %* .\oggmdev || exit /B 1
call:cb %* .\oggm || exit /B 1

exit /B %ERRORLEVEL%

:cb
if DEFINED CONDA_BUILD_PY (
conda build --python %CONDA_BUILD_PY% --channel conda-forge --channel defaults --override-channels %* || exit /B 1
) else (
conda build --python 3.6 --channel conda-forge --channel defaults --override-channels %* || exit /B 1
)
for /r %%f in (..\conda-bld\win-64\*.tar.bz2) do (
anaconda -t %ANACONDA_AUTH_TOKEN% upload -u oggm %%f
)
exit /B 0
