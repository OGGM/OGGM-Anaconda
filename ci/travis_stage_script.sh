#!/bin/bash
set -xe
cd "$(dirname "$0")/.."

export MPLBACKEND=agg
export CONDA_BLD_PATH="$PWD/conda-bld"
unset TRAVIS

if [[ "$TRAVIS_OS_NAME" == "windows" ]]; then
	wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe -O miniconda.exe
	chmod +x miniconda.exe
	./miniconda.exe "/InstallationType=JustMe" "/AddToPath=0" "/RegisterPython=0" "/NoRegistry=1" "/S" "/D=$(cygpath -w -a $HOME/miniconda)"
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

conda config --set always_yes yes --set changeps1 no
conda update -q conda
conda update -q --all
conda info -a
conda install -q conda-build conda-verify anaconda-client

conda build --no-anaconda-upload --python "${CONDA_BUILD_PY}" --channel oggm --channel conda-forge --channel defaults --override-channels ./build/"$1"

for i in conda-bld/*/*.tar.bz2; do
	anaconda -t $ANACONDA_AUTH_TOKEN upload -u oggm $i || true
done
