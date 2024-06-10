#!/bin/bash
set -euo pipefail

init (){
verify_homebrew
install_jq
install_pgformatter
}

## utility functions for dependencies
is_darwin (){
  PLATFORM=$(uname)
  [ "$PLATFORM" == "Darwin" ]
}

has_homebrew (){
  echo 'Checking for homebrew'
  is_darwin && hash brew >/dev/null 2>&1
}

verify_homebrew (){
  echo 'Verifying Homebrew installed'
  if ! has_homebrew
  then
    echo 'Homebrew is not installed'
    is_darwin && echo 'Please install homebrew. https://brew.sh'
    exit 1
  fi
}

install_jq (){
  is_darwin || {
    echo "Please install jq for your platform."
    exit 1
  }

  echo 'Installing jq...'
  brew install jq

  jq -V
}

install_pgformatter (){
  is_darwin || {
    echo "Please install pgFormatter for your platform."
    exit 1
  }

  echo 'Installing pgFormatter...'
  brew install pgformatter

  pg_format -v
}

init

# Copy hook scripts to the .git/hooks directory
SOURCE_DIR="../hooks"
DEST_DIR="../.git/hooks"
echo "Copying hook scripts from $SOURCE_DIR to $DEST_DIR..."
if [ -d "$SOURCE_DIR" ]; then
    cp "$SOURCE_DIR"/* "$DEST_DIR"
    chmod +x "$DEST_DIR"/*
    echo "Hook scripts copied and made executable successfully."
else
    echo "Source directory $SOURCE_DIR does not exist."
fi
