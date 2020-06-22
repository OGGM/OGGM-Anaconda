#!/bin/bash
set -e

cd "$(dirname "$0")"
source ./activate-conda.sh

cd ..

export MPLBACKEND=agg
export OGGM_USE_MP_SPAWN=1

PKG_VERSION="$(sed -En 's/.*version: .*"(.*)".*/\1/p' "build/${PKG}/meta.yaml")"
PKG_BUILD="$(sed -En 's/.*number: [^0-9]*([0-9]+)[^0-9]*/\1/p' "build/${PKG}/meta.yaml")"

SALEM_VERSION="$(sed -En 's/.*version: .*"(.*)".*/\1/p' "build/salem/meta.yaml")"
SALEM_BUILD="$(sed -En 's/.*number: [^0-9]*([0-9]+)[^0-9]*/\1/p' "build/salem/meta.yaml")"

SALEM_PKG="salem=${SALEM_VERSION}=py_${SALEM_BUILD}"

if [[ "$PKG" == "oggm" ]]; then
	SALEM_PKG="salem"
fi

RQ conda create -n oggm_env --strict-channel-priority -c oggm -c conda-forge -c defaults "python=$PYVER" "${PKG}=${PKG_VERSION}=py_${PKG_BUILD}" "${SALEM_PKG}" pytest pytest-mpl

echo ">>> conda activate oggm_env"
conda activate oggm_env

if [[ "$PKG" == "oggm" ]]; then
	RQ pytest --pyargs oggm
else
	RQ pytest --mpl-oggm --mpl-upload --pyargs oggm
fi

ENV_FILE_NAME="${PKG}-$(conda list -f -e "$PKG" | tail -n1 | cut -d= -f2)_$(date +%Y%m%d)_py${PYVER/./}.yml"

[[ "$PKG" != "oggm" ]] && RQ conda remove --force "$PKG" || true
RQ conda env export -f "$ENV_FILE_NAME"

RQ git config --global user.email "actions@github.com"
RQ git config --global user.name "Github Actions"

git clone -q "https://${GH_USER}:${GH_AUTH}@github.com/OGGM/OGGM-dependency-list" "/tmp/deplist_repo"

DDIR="/tmp/deplist_repo/${RUNNER_OS}-64"
mkdir -p "$DDIR"
test -f "$DDIR/$ENV_FILE_NAME" && MODEV="Update" || MODEV="Add"
mv "$ENV_FILE_NAME" "$DDIR"
cd "$DDIR"
git add "$ENV_FILE_NAME"

LATEST_ENV_FILE="${PKG}-latest_py${PYVER/./}.yml"
rm -f "$LATEST_ENV_FILE"
cp "$ENV_FILE_NAME" "$LATEST_ENV_FILE"
git add "$LATEST_ENV_FILE"

git commit -m "${MODEV} ${RUNNER_OS}/${ENV_FILE_NAME}" || exit 0

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
