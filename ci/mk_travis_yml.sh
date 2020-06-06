#!/bin/bash
cd "$(dirname "$0")"/..

cat .travis_head.yml > .travis.yml

function echo_stage() {
	stage="$1"
	os="$2"
	CONDA_BUILD_PY="$3"
	stagename="$stage"

	if [[ "$stage" == "oggmdev" ]]; then
		stagename="oggm"
	fi

	echo "    - stage: ${stagename}" >> .travis.yml
	echo "      script: ./ci/travis_stage_script.sh $stage" >> .travis.yml
	echo "      env: SUB_STAGE=$stage" >> .travis.yml
	echo "      os: $os" >> .travis.yml
	if [[ "$os" == "osx" ]]; then
		echo "      osx_image: xcode11.5" >> .travis.yml
	fi
}

STAGES="motionless salem pytest-mpl oggm-deps oggm oggmdev"
CONDA_BUILD_PYS="3.6 3.7 3.8"

for stage in $STAGES; do
	for os in linux; do
		echo_stage $stage $os
	done
done

for stage in oggm oggmdev; do
	for os in linux osx windows; do
		for CONDA_BUILD_PY in $CONDA_BUILD_PYS; do
			echo "    - stage: make_env" >> .travis.yml
			echo "      script: ./ci/travis_make_env_script.sh" >> .travis.yml
			echo "      env: CONDA_BUILD_PY=$CONDA_BUILD_PY SUB_STAGE=$stage" >> .travis.yml
			echo "      os: $os" >> .travis.yml
			if [[ "$os" == "osx" ]]; then
				echo "      osx_image: xcode11.5" >> .travis.yml
			fi
		done
	done
done

