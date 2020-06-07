#!/bin/bash
source "${CONDA}/etc/profile.d/conda.sh"
conda activate base

function RQ() {
	echo ">>>" "$@"
	"$@"
}
