#!/bin/bash
set -xe
cd "$(dirname "$0")/.."

export MPLBACKEND=agg
export CONDA_BLD_PATH="$PWD/conda-bld"

source ./ci/install_miniconda.sh

conda config --set always_yes yes --set changeps1 no

CUR_NO="$(grep number: ./build/"$1"/meta.yaml | head -n1 | cut -d: -f2 | xargs)"
CUR_VER="$(grep version: ./build/"$1"/meta.yaml | cut -d'"' -f2)"
CUR_PY="py"
if [[ "$1" == "oggm-deps" ]]; then
	CUR_PY="oggm"
else
	CUR_NO="${CUR_PY}_${CUR_NO}"
fi
LATEST_VER="$(conda search -c oggm --override-channels "$1" | grep "$CUR_PY" | tail -n1)"

if [[ "$(echo $LATEST_VER | cut -d' ' -f2)" == "$CUR_VER" ]] && [[ "$(echo $LATEST_VER | cut -d' ' -f3)" == "$CUR_NO" ]]; then
	echo "Anaconda already has ${CUR_VER} ${CUR_NO}, exiting early."
	exit 0
fi

conda update -q conda
conda config --set channel_priority strict
conda update -q --all
conda info -a
conda install -q conda-build conda-verify anaconda-client

conda build --no-anaconda-upload --python "${CONDA_BUILD_PY}" --channel oggm --channel conda-forge --channel defaults --override-channels ./build/"$1" &
CONDA_PID=$!

set +x

WAIT_TIME=0
while [ -e /proc/$CONDA_PID ]; do
	sleep 10
	WAIT_TIME=$(( $WAIT_TIME + 10 ))
	if [ $WAIT_TIME -ge 500 ] && [ -e /proc/$CONDA_PID ]; then
		WAIT_TIME=0
		echo "Still waiting..."
	fi
done

wait $CONDA_PID

set -x

for i in conda-bld/*/*.tar.bz2; do
	anaconda -t $ANACONDA_AUTH_TOKEN upload -u oggm $i || true
done
