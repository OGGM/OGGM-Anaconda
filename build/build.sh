#!/bin/bash
cd "$(dirname "$0")"
export CONDA_BLD_PATH="$PWD/../conda-bld"

function cb() {
	[ -n "${CONDA_BUILD_PY}" ] || CONDA_BUILD_PY="3.6"
	conda build --no-anaconda-upload --python "${CONDA_BUILD_PY}" --channel conda-forge --channel defaults --override-channels "$@" || exit -1
}

unset TRAVIS

cb ./motionless
cb ./salem
cb ./pytest-mpl
cb ./oggm-deps
cb ./oggmdev
cb ./oggm

