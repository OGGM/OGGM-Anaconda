#!/bin/bash

set -xe
cd "$(dirname "$0")/.."

export MPLBACKEND=agg

source ./ci/install_miniconda.sh

conda config --set always_yes yes --set changeps1 no

conda create -n oggm_env -c oggm -c conda-forge "python=$CONDA_BUILD_PY"
source activate oggm_env

conda install -c oggm -c conda-forge "$SUB_STAGE" pytest pytest-mpl

if [[ "$SUB_STAGE" == "oggm" ]]; then
	pytest --mpl-oggm -k "not test_googlemap" --pyargs oggm
else
	pytest --mpl-oggm --run-download --pyargs oggm
fi

ENV_FILE_NAME="${SUB_STAGE}_$(date +%Y%m%d)_py${CONDA_BUILD_PY/./}.yml"
conda env export -f "$ENV_FILE_NAME"

# TODO: Upload file somewhere
cat "$ENV_FILE_NAME"
