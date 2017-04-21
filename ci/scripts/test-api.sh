#!/usr/bin/env bash

set -e
export TERM=${TERM:-dumb}

echo "=============================================="
echo "Beginning Test of API"
echo "=============================================="

RESPONSE_CODE=$(curl --write-out %{http_code} -k --silent --output /dev/null https://lab-application-preachy-vortices.app.52.176.42.10.cf.pcfazure.com/)
echo "Response Code: "$RESPONSE_CODE

if [ "$RESPONSE_CODE" -ne "200" ]; then
	echo "Bad Response Code"
	exit 1
fi

echo "----------------------------------------------"
echo "Test Complete"
echo "----------------------------------------------"
