#!/bin/bash
set -e
cd "$(dirname "$0")/.."

export MPLBACKEND=agg
export CONDA_BLD_PATH="$PWD/conda-bld"
unset TRAVIS

pushd build
conda build --no-anaconda-upload --python "${CONDA_BUILD_PY}" --channel oggm --channel conda-forge --channel defaults --override-channels "$@"
popd

for i in conda-bld/*/*.tar.bz2; do
    anaconda -t $ANACONDA_AUTH_TOKEN upload -u oggm $i || true
done
