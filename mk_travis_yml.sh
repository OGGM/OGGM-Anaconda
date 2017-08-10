#!/bin/bash
cd "$(dirname "$0")"

cat .travis_head.yml > .travis.yml

echo "jobs:" >> .travis.yml
echo "  include:" >> .travis.yml

for stage in motionless salem oggm oggm-deps; do
	for os in linux osx; do
		for CONDA_BUILD_PY in 3.5 3.6; do
			echo "    - stage: $stage" >> .travis.yml
			echo "      script: ./ci/travis_stage_script.sh $stage" >> .travis.yml
			echo "      env: CONDA_BUILD_PY=$CONDA_BUILD_PY" >> .travis.yml
			echo "      os: $os" >> .travis.yml
		done
	done
done
