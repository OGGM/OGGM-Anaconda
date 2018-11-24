#!/bin/bash
[[ "$TRAVIS_EVENT_TYPE" == "pull_request" ]] && exit 0
exec curl \
	-H "Authorization: Bearer $APPVEYOR_TOKEN" \
	-H "Content-Type: application/json" \
	--request POST \
	--data "{'accountName':'TimoRoth','projectSlug':'oggm-anaconda','branch':'$TRAVIS_BRANCH','commitId':'$TRAVIS_COMMIT'}" \
	https://ci.appveyor.com/api/account/TimoRoth/builds
