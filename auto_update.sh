#!/bin/bash

# Variables
REPO="1061924524/demo"  # Change this to the desired GitHub repository
CURRENT_VERSION="$(cat VERSION)"  # Capture current version
API_URL="https://api.github.com/repos/$REPO/releases/latest"

# Check for latest version on GitHub
LATEST_VERSION=$(curl -s $API_URL | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')

# Compare versions and upgrade if necessary
if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
    echo "Upgrading from version $CURRENT_VERSION to $LATEST_VERSION..."

    # Assuming the latest release assets contain the binary
    ASSET_URL=$(curl -s $API_URL | grep 'browser_download_url' | grep -i "your_binary_name" | sed -E 's/.*"browser_download_url": "([^"]+)".*/\1/')

    # Download the latest version
    curl -L -o /tmp/new_binary "$ASSET_URL"

    # Make the new binary executable
    chmod +x /tmp/new_binary

    # Move the new binary to replace the old one
    sudo mv /tmp/new_binary $BINARY_PATH

    echo "Upgrade complete to version $LATEST_VERSION."
else
    echo "You are already on the latest version: $CURRENT_VERSION."
fi
