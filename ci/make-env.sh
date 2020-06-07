#!/bin/bash
set -e

cd "$(dirname "$0")"
source ./activate-conda.sh

cd ..

export MPLBACKEND=agg
export OGGM_USE_MP_SPAWN=1