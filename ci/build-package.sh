#!/bin/bash
set -e

function RQ() {
    echo ">>>" "$@"
    "$@"
}

cd "$(dirname "$0")"/..

PKG="$1"

export CONDA_BLD_PATH="$PWD/conda-bld"
rm -rf "$CONDA_BLD_PATH"

RQ conda build --no-anaconda-upload --no-test --channel oggm --channel conda-forge --channel defaults --override-channels "./build/$PKG"

echo
echo "Done building"
echo

anaconda --version

for i in "$CONDA_BLD_PATH"/*/*.conda; do
    echo
	echo "Uploading $(basename $i)"
    echo
	anaconda -t "$ANACONDA_AUTH_TOKEN" upload -u oggm $i || echo "Upload failed"
done
