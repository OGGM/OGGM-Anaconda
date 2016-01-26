#!/bin/bash
cd "$(dirname "$0")"
export CONDA_BLD_PATH="$PWD/../build-output"

function cb() {
	conda build --no-anaconda-upload "$@" || exit -1
}

cb descartes
cb geopandas
cb motionless
cb salem
cb cleo
cb oggm

