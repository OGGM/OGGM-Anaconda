#!/bin/bash
cd "$(dirname "$0")"
export CONDA_BLD_PATH="$PWD/../output"

function cb() {
	if [ -z "${CONDA_BUILD_PY}" ]; then
		conda build --no-anaconda-upload --python 3.5 --channel defaults --channel conda-forge --channel oggm --override-channels "$@" || exit -1
		conda build --no-anaconda-upload --python 2.7 --channel defaults --channel conda-forge --channel oggm --override-channels "$@" || exit -1
	else
		conda build --no-anaconda-upload --python "${CONDA_BUILD_PY}" --channel defaults --channel conda-forge --channel oggm --override-channels "$@" || exit -1
	fi
}

cb ./progressbar2
cb ./descartes
cb ./geopandas
cb ./motionless
cb ./salem
cb ./cleo
cb ./oggm

