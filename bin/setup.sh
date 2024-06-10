#!/bin/bash

#install pgFormatter
./pgformatter.sh

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