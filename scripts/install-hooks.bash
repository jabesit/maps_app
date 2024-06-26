#!/usr/bin/env bash

GIT_DIR=$(git rev-parse --git-dir)

echo "Installing hooks..."
# this command creates symlink to our pre-push script
ln -s ../../scripts/pre-push.bash $GIT_DIR/hooks/pre-push
chmod +x $GIT_DIR/hooks/pre-push
echo "Done"!