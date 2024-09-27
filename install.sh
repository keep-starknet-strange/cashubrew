#!/bin/bash

set -e

OS="$(uname -s)"
ARCH="$(uname -m)"

# Normalize OS name
case "$OS" in
  Linux*)   PLATFORM="linux";;
  Darwin*)  PLATFORM="macos";;
  CYGWIN*|MINGW*|MSYS_NT*) PLATFORM="windows";;
  *)        echo "Unsupported OS: $OS"; exit 1;;
esac

# Normalize ARCH
case "$ARCH" in
  x86_64|amd64) ARCH="x86_64";;
  arm64|aarch64) ARCH="arm64";;
  *)             echo "Unsupported architecture: $ARCH"; exit 1;;
esac

echo "Detected platform: $PLATFORM"
echo "Detected architecture: $ARCH"

# Get the version to install
if [ -n "$1" ]; then
  VERSION="$1"
else
  # Get latest version
  VERSION=$(curl -s https://api.github.com/repos/keep-starknet-strange/cashubrew/releases/latest | grep '"tag_name"' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')
fi

if [ -z "$VERSION" ]; then
  echo "Failed to get version to install"
  exit 1
fi

echo "Installing version: $VERSION"

# Construct download URL
if [ "$PLATFORM" = "windows" ]; then
  EXT="zip"
else
  EXT="tar.gz"
fi

BINARY_NAME="cashubrew-${PLATFORM}-${ARCH}-${VERSION}.${EXT}"
DOWNLOAD_URL="https://github.com/keep-starknet-strange/cashubrew/releases/download/${VERSION}/${BINARY_NAME}"

echo "Downloading $DOWNLOAD_URL"

# Download the binary
curl -L -o "$BINARY_NAME" "$DOWNLOAD_URL"

# Extract and install
if [ "$EXT" = "tar.gz" ]; then
  tar xzvf "$BINARY_NAME"
elif [ "$EXT" = "zip" ]; then
  unzip "$BINARY_NAME"
else
  echo "Unknown file extension: $EXT"
  exit 1
fi

# Move binary to /usr/local/bin
if [ -d "cashubrew/bin" ]; then
  sudo cp cashubrew/bin/cashubrew /usr/local/bin/
elif [ -f "cashubrew.exe" ]; then
  sudo cp cashubrew.exe /usr/local/bin/
else
  echo "Binary not found after extraction"
  exit 1
fi

# Clean up
rm -rf "$BINARY_NAME" cashubrew cashubrew.exe

echo "✅ Cashubrew installed successfully!"
