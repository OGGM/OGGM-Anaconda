#!/bin/bash
set -e

cd "$(dirname "$0")"
source ./activate-conda.sh

if [[ "${RUNNER_OS}" != "Windows" ]]; then
    RQ sudo chown -R "$(id -u):$(id -g)" "$CONDA"
fi

RQ conda config --set always_yes yes --set changeps1 no --set channel_priority strict
RQ conda update -q conda
RQ conda update -c conda-forge -q --all
RQ conda install -c conda-forge -q conda-build conda-verify anaconda-client
RQ conda info -a