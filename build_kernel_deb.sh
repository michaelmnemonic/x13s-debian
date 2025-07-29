#!/bin/bash

# Build Debian package for Linux kernel in the 'linux/' subdirectory

# Check if we're in the root of the project
if [ -d "linux" ]; then
    cd "linux" || { echo "Failed to enter 'linux' directory"; exit 1; }
else
    echo "Error: 'linux' directory not found. This script must be run from the project root."
    exit 1
fi

set revision=git rev-parse --abbrev-ref HEAD | grep -oP '(?<=wip/).*'

# Create config
if [ ! -f .config ]; then
    make johan_defconfig || { echo "Failed to create config"; exit 1; }
else
    echo "Config already exists. This script assumes an unconfigured kernel."
fi

# Compile the kernel
echo "Compiling kernel..."
make -j$(nproc) bindeb-pkg || { echo "Kernel compilation failed"; exit 1; }

echo "Debian package created successfully."
