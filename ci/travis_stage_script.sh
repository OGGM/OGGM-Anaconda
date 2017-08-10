#!/bin/bash
set -xe
cd "$(dirname "$0")/.."

export MPLBACKEND=agg
export CONDA_BLD_PATH="$PWD/conda-bld"
unset TRAVIS

rvm get head || true
if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then wget https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O miniconda.sh; fi
if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh; fi
bash miniconda.sh -b -p $HOME/miniconda
rm miniconda.sh
export PATH="$HOME/miniconda/bin:$PATH"
hash -r

conda config --set always_yes yes --set changeps1 no
conda install -q -c conda-forge ca-certificates
conda update -q --all
conda update -q conda
conda info -a
conda install -q conda-build anaconda-client
export SSL_CERT_FILE="$HOME/miniconda/ssl/cacert.pem"

conda build --no-anaconda-upload --python "${CONDA_BUILD_PY}" --channel oggm --channel conda-forge --channel defaults --override-channels ./build/"$1"

for i in conda-bld/*/*.tar.bz2; do
    anaconda -t $ANACONDA_AUTH_TOKEN upload -u oggm $i || true
done
