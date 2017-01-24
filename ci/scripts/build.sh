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
COMMIT=$(git rev-parse HEAD)

echo $ARTIFACT > ../artifact/release_name.txt
echo $(git log --format=%B -n 1 $COMMIT) > ../artifact/release_notes.md
echo $COMMIT > ../artifact/release_commitish.txt

cp ./build/libs/$ARTIFACT ../artifact
cp ./manifest.yml ../artifact

echo "----------------------------------------------"
echo "Build Complete"
ls -lah ../artifact
echo "----------------------------------------------"
