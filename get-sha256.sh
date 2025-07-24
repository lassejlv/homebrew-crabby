#!/bin/bash

# Script to calculate SHA256 hashes for Crabby releases
# Usage: ./get-sha256.sh <version>
# Example: ./get-sha256.sh 0.0.1

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 0.0.1"
    exit 1
fi

VERSION=$1
BASE_URL="https://github.com/lassejlv/crabby-rs/releases/download/v${VERSION}"

echo "Calculating SHA256 hashes for Crabby v${VERSION}..."
echo ""

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "Downloading ARM64 version..."
ARM64_FILE="Crabby_${VERSION}_aarch64.dmg"
curl -L -o "$ARM64_FILE" "${BASE_URL}/${ARM64_FILE}"

echo "Downloading x64 version..."
X64_FILE="Crabby_${VERSION}_x64.dmg"
curl -L -o "$X64_FILE" "${BASE_URL}/${X64_FILE}"

echo ""
echo "Calculating SHA256 hashes..."
echo ""

ARM64_SHA=$(shasum -a 256 "$ARM64_FILE" | cut -d' ' -f1)
X64_SHA=$(shasum -a 256 "$X64_FILE" | cut -d' ' -f1)

echo "=== SHA256 Hashes for v${VERSION} ==="
echo ""
echo "ARM64 (Apple Silicon):"
echo "  File: $ARM64_FILE"
echo "  SHA256: $ARM64_SHA"
echo ""
echo "x64 (Intel):"
echo "  File: $X64_FILE"
echo "  SHA256: $X64_SHA"
echo ""

echo "=== For Homebrew Cask (Casks/crabby.rb) ==="
echo ""
echo "  sha256 arm:   \"$ARM64_SHA\","
echo "         intel: \"$X64_SHA\""
echo ""

echo "=== For Homebrew Formula (Formula/crabby.rb) ==="
echo ""
echo "ARM64 block:"
echo "      sha256 \"$ARM64_SHA\""
echo ""
echo "x64 block:"
echo "      sha256 \"$X64_SHA\""
echo ""

# Cleanup
cd - > /dev/null
rm -rf "$TEMP_DIR"

echo "✅ Done! Copy the appropriate SHA256 values to your Homebrew formula/cask."
