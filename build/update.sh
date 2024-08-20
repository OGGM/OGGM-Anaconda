#!/bin/bash

function getSha() {
	curl -s -k "https://api.github.com/repos/${1}/commits/master" | python -c 'import json,sys;print(json.load(sys.stdin)["sha"])' || exit -1
}

cd "$(dirname "$0")"

SHA_OGGM="$(getSha OGGM/oggm)"

sed -i -r "s|( git_rev: ).*|\1${SHA_OGGM}|" oggmdev/meta.yaml || exit -2

DATE_STR="$(date +%Y%m%d%H%M)"

for i in oggmdev; do
	if ! git diff --quiet --exit-code "${i}"/meta.yaml; then
		sed -i -r "s|(version: .*\.).*|\1${DATE_STR}\"|" "${i}"/meta.yaml || exit -2
	fi
done

exit 0
