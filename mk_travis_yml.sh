#!/bin/bash
cd "$(dirname "$0")"

cat .travis_head.yml > .travis.yml

function echo_stage() {
	stage="$1"
	os="$2"
	CONDA_BUILD_PY="$3"
	stagename="$stage"

	if [[ "$stage" == "oggmdev" ]]; then
		stagename="oggm"
	fi
	if [[ "$stage" == "oggm" ]] && [[ "$CONDA_BUILD_PY" == "3.7" ]]; then
		return
	fi

	echo "    - stage: ${stagename}" >> .travis.yml
	echo "      script: ./ci/travis_stage_script.sh $stage" >> .travis.yml
	echo "      env: CONDA_BUILD_PY=$CONDA_BUILD_PY SUB_STAGE=$stage" >> .travis.yml
	echo "      os: $os" >> .travis.yml
	if [[ "$os" == "osx" ]]; then
		echo "      osx_image: xcode10" >> .travis.yml
	fi
}

STAGES="motionless salem pytest-mpl oggm-deps oggm oggmdev"
CONDA_BUILD_PYS="3.5 3.6 3.7"

for stage in $STAGES; do
	for os in linux; do
		for CONDA_BUILD_PY in $CONDA_BUILD_PYS; do
			echo_stage $stage $os $CONDA_BUILD_PY
		done
	done
done

