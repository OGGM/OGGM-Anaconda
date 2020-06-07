#!/bin/bash
set -e

cd "$(dirname "$0")"
source ./activate-conda.sh

cd ..

PKG="$1"
MF="./build/$1/meta.yaml"

CUR_NO="$(grep number: "$MF" | head -n1 | cut -d: -f2 | xargs)"
CUR_VER="$(grep version: "$MF" | cut -d'"' -f2)"

CUR_PY="py"
if [[ "$PKG" == "oggm-deps" ]]; then
	CUR_PY="oggm"
else
	CUR_NO="${CUR_PY}_${CUR_NO}"
fi

LATEST_VER="$(conda search -c oggm --override-channels "$PKG" | grep "$CUR_PY" | tail -n1)"

if [[ "$(echo $LATEST_VER | cut -d' ' -f2)" == "$CUR_VER" ]] && [[ "$(echo $LATEST_VER | cut -d' ' -f3)" == "$CUR_NO" ]]; then
	echo "Anaconda already has ${CUR_VER} ${CUR_NO}, exiting early."
	exit 0
fi

export CONDA_BLD_PATH="$PWD/conda-bld"
rm -rf "$CONDA_BLD_PATH"

RQ conda build --no-anaconda-upload --no-test --channel oggm --channel conda-forge --channel defaults --override-channels "./build/$PKG"

echo
echo "Done building"
echo

for i in "$CONDA_BLD_PATH"/*/*.tar.bz2; do
    echo
	echo "Uploading $(basename $i)"
    echo
	anaconda -t "$ANACONDA_AUTH_TOKEN" upload -u oggm $i || echo "Upload failed"
done
