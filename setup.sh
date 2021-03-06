#!/bin/bash

# Get the directory where this script is and set ROOT_DIR to that path. This
# allows script to be run from different directories but always act on the
# directory it is within.
ROOT_DIR="$(cd "$(dirname $0)"; pwd)";
PROJECT_NAME="node-chrome-runner"

# A simple bash script to run commands to setup and install all dev dependencies
# (including non-npm ones)
function runAndAssertCmd ()
{
    echo "Running: $1"
    echo
    # We use set -e to make sure this will fail if the command returns an error
    # code.
    set -e && eval $1
}

# Just run the command, ignore errors (e.g. cp fails if a file already exists
# with "set -e")
function runCmd ()
{
    echo "Running: $1"
    echo
    eval $1
}

function clean ()
{
  runCmd "rm -r $ROOT_DIR/node_modules $ROOT_DIR/build"
}

function installDevDependencies ()
{
  runCmd "cd $ROOT_DIR"
  runAndAssertCmd "npm install"
  runAndAssertCmd "node_modules/.bin/tsd reinstall --config ./third_party/tsd.json"
}

if [ "$1" == 'install' ]; then
  installDevDependencies
elif [ "$1" == 'clean' ]; then
  clean
else
  echo "Usage: setup.sh [install|tools]"
  echo "  install       Installs needed development dependencies into build/"
  echo "  clean         Removes all dependencies installed by this script."
  echo
  echo ""
  exit 0
fi
