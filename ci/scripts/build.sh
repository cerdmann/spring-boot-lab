#!/usr/bin/env bash

set -e
export TERM=${TERM:-dumb}

echo "=============================================="
echo "Beginning build of Spring Boot application"
echo "$(java -version)"
echo "$(gradle -version)"
echo "=============================================="

cd git-repo

./gradlew clean build

ARTIFACT=$(cd ./build/libs && ls lab*.jar) 

cp ./build/libs/$ARTIFACT ../artifact
cp ./manifest.yml ../artifact

echo "----------------------------------------------"
echo "Build Complete"
ls -lah ../artifact
echo "----------------------------------------------"
