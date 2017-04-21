#!/usr/bin/env bash

set -e
export TERM=${TERM:-dumb}

echo "=============================================="
echo "Beginning Test of API"
echo "=============================================="

cd git-repo

RESPONSE_CODE=$(curl --write-out %{http_code} --silent --output /dev/null https://lab-application-hyperbarbarous-paperiness.app.52.176.42.10.cf.pcfazure.com/)
echo $RESPONSE_CODE

echo "----------------------------------------------"
echo "Test Complete"
echo "----------------------------------------------"
