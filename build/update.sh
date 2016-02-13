#!/bin/bash

function getSha() {
	curl -s -k "https://api.github.com/repos/${1}/commits/master" | python -c 'import json,sys;print(json.load(sys.stdin)["sha"])' || exit -1
}

cd "$(dirname "$0")"

SHA_MOTIONLESS="$(getSha fmaussion/motionless)"
SHA_SALEM="$(getSha fmaussion/salem)"
SHA_CLEO="$(getSha fmaussion/cleo)"
SHA_OGGM="$(getSha OGGM/oggm)"

sed -i -r "s|(url: .*/).*|\1${SHA_SALEM}|" salem/meta.yaml || exit -2
sed -i -r "s|(fn: .*-).*(\.tar\.gz)|\1${SHA_SALEM}\2|" salem/meta.yaml || exit -2
sed -i -r "s|(url: .*/).*|\1${SHA_CLEO}|" cleo/meta.yaml || exit -2
sed -i -r "s|(fn: .*-).*(\.tar\.gz)|\1${SHA_CLEO}\2|" cleo/meta.yaml || exit -2
sed -i -r "s|(url: .*/).*|\1${SHA_MOTIONLESS}|" motionless/meta.yaml || exit -2
sed -i -r "s|(fn: .*-).*(\.tar\.gz)|\1${SHA_MOTIONLESS}\2|" motionless/meta.yaml || exit -2
sed -i -r "s|(url: .*/).*|\1${SHA_OGGM}|" oggm/meta.yaml || exit -2
sed -i -r "s|(fn: .*-).*(\.tar\.gz)|\1${SHA_OGGM}\2|" oggm/meta.yaml || exit -2

DATE_STR="$(date +%Y%m%d%H%M)"

for i in salem cleo motionless oggm; do
	if ! git diff --quiet --exit-code "${i}"/meta.yaml; then
		sed -i -r "s|(version: .*\.).*|\1${DATE_STR}\"|" "${i}"/meta.yaml || exit -2
	fi
done

exit 0
