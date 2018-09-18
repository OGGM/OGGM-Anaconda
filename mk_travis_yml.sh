#!/bin/bash
cd "$(dirname "$0")"

cat .travis_head.yml > .travis.yml

for stage in motionless salem pytest-mpl oggm-deps oggm; do
	for os in linux osx; do
		for CONDA_BUILD_PY in 3.5 3.6 3.7; do
			echo "    - stage: ${stage}" >> .travis.yml
			echo "      script: ./ci/travis_stage_script.sh $stage" >> .travis.yml
			echo "      env: CONDA_BUILD_PY=$CONDA_BUILD_PY" >> .travis.yml
			echo "      os: $os" >> .travis.yml
			if [[ "$os" == "osx" ]]; then
				echo "      osx_image: xcode10" >> .travis.yml
			fi
		done
	done
done
