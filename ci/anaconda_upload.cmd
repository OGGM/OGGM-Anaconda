setlocal
cd %~dp0
cd ..
for /r %%f in (output\win-64\*.tar.bz2) do ( anaconda -t %ANACONDA_AUTH_TOKEN% upload -u oggm %%f )
exit 0
