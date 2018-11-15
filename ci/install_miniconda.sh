#!/bin/bash
unset TRAVIS

if [[ "$TRAVIS_OS_NAME" == "windows" ]]; then
	wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe -O miniconda.exe
	chmod +x miniconda.exe
	./miniconda.exe /InstallationType=JustMe /RegisterPython=1 /S /D=$(cygpath -w -a $HOME/miniconda)
	rm miniconda.exe
else
	rvm get head || true
	if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O miniconda.sh; fi
	if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh; fi
	bash miniconda.sh -b -p $HOME/miniconda
	rm miniconda.sh
fi

export PATH="$HOME/miniconda/bin:$PATH"
hash -r
