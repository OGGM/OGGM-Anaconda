#!/bin/bash

set -xe
cd "$(dirname "$0")/.."

export MPLBACKEND=agg
export OGGM_USE_MP_SPAWN=1

source ./ci/install_miniconda.sh

conda config --set always_yes yes --set changeps1 no 
conda update -q conda
conda update -q --all

SUB_STAGE_VERSION="$(sed -En 's/.*version: .*"(.*)".*/\1/p' "build/${SUB_STAGE}/meta.yaml")"
SUB_STAGE_BUILD="$(sed -En 's/.*number: [^0-9]*([0-9]+)[^0-9]*/\1/p' "build/${SUB_STAGE}/meta.yaml")"

SALEM_VERSION="$(sed -En 's/.*version: .*"(.*)".*/\1/p' "build/salem/meta.yaml")"
SALEM_BUILD="$(sed -En 's/.*number: [^0-9]*([0-9]+)[^0-9]*/\1/p' "build/salem/meta.yaml")"

conda create -n oggm_env --strict-channel-priority -c oggm -c conda-forge -c defaults "python=$CONDA_BUILD_PY" "${SUB_STAGE}=${SUB_STAGE_VERSION}=py_${SUB_STAGE_BUILD}" "salem=${SALEM_VERSION}=py_${SALEM_BUILD}" pytest pytest-mpl
source activate oggm_env

if [[ "$SUB_STAGE" == "oggm" ]]; then
	pytest --mpl-oggm --mpl-upload -k "not test_googlemap" --pyargs oggm
else
	pytest --mpl-oggm --mpl-upload --pyargs oggm
fi

ENV_FILE_NAME="${SUB_STAGE}-$(conda list -f -e "$SUB_STAGE" | tail -n1 | cut -d= -f2)_$(date +%Y%m%d)_py${CONDA_BUILD_PY/./}.yml"

[[ "$SUB_STAGE" != "oggm" ]] && conda remove --force "$SUB_STAGE" || true
conda env export -f "$ENV_FILE_NAME"

git config --global user.email "travis@travis-ci.com"
git config --global user.name "Travis CI"

set +x
git clone -q "https://${GH_TOKEN}@github.com/OGGM/OGGM-dependency-list" "/tmp/deplist_repo"

DDIR="/tmp/deplist_repo/${TRAVIS_OS_NAME}-64"
mkdir -p "$DDIR"
test -f "$DDIR/$ENV_FILE_NAME" && MODEV="Update" || MODEV="Add"
mv "$ENV_FILE_NAME" "$DDIR"
cd "$DDIR"
git add "$ENV_FILE_NAME"

LATEST_ENV_FILE="${SUB_STAGE}-latest_py${CONDA_BUILD_PY/./}.yml"
rm -f "$LATEST_ENV_FILE"
cp "$ENV_FILE_NAME" "$LATEST_ENV_FILE"
git add "$LATEST_ENV_FILE"

git commit -m "$MODEV $TRAVIS_OS_NAME/$ENV_FILE_NAME" || exit 0

CNT=0
while ! git push -q; do
	CNT=$(( $CNT + 1 ))
	if [[ $CNT -gt 5 ]]; then
		echo "Max push retries exceeded"
		exit 1
	fi
	sleep 5
	echo "Push failed, trying pull --rebase"
	git pull -q --rebase
done
