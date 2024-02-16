#!/usr/bin/env bash

echo "Running tests"

flutter test

if [ $? -ne 0 ]; then
 echo "Tests must pass before push!"
 exit 1
fi

echo "All tests passed. Now pushing."
exit 0
