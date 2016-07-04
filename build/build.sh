#!/bin/bash
cd "$(dirname "$0")"
export CONDA_BLD_PATH="$PWD/../output"

function cb() {
	[ -n "${CONDA_BUILD_PY}" ] || CONDA_BUILD_PY="3.5"
	conda build --no-anaconda-upload --python "${CONDA_BUILD_PY}" --channel defaults --channel conda-forge --channel oggm --override-channels "$@" || exit -1
}

cb ./progressbar2
cb ./descartes
cb ./geopandas
cb ./motionless
cb ./salem
cb ./cleo
cb ./oggm

