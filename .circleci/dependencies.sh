#!/bin/bash
# Setup terraform and aws credentials

# Defaults
TERRAFORM_CACHED_VERSION='0'
TERRAFORM_DIR="$HOME/terraform"

# Get current state version
TERRAFORM_VERSION='0.10.8'

# Check cached terraform version
if [ -f "$TERRAFORM_DIR/VERSION" ]; then
    TERRAFORM_CACHED_VERSION=`cat "$TERRAFORM_DIR/VERSION"`
fi

# Compare terraform versions
if [ "$TERRAFORM_VERSION" != "$TERRAFORM_CACHED_VERSION" ]; then
    # Download latest version of terraform
    wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
    # Create dir if necessary
    if [ ! -d "$TERRAFORM_DIR" ]; then
        mkdir "$TERRAFORM_DIR"
    fi
    # Unzip and overright existing files
    unzip -o "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d "$TERRAFORM_DIR"
    # Update VERSION file
    echo "$TERRAFORM_VERSION" > "$TERRAFORM_DIR/VERSION"
fi
