#!/bin/bash

# update_version.sh - Updates pubspec.yaml with semantic version and incremented build number
# Usage: ./update_version.sh <new_semantic_version>
# Example: ./update_version.sh 1.2.6

set -e

NEW_VERSION=$1

if [ -z "$NEW_VERSION" ]; then
    echo "Error: No version provided"
    echo "Usage: $0 <new_semantic_version>"
    exit 1
fi

PUBSPEC_FILE="pubspec.yaml"
README_FILE="README.md"

# Extract current version line
CURRENT_VERSION_LINE=$(grep -E '^version: ' "$PUBSPEC_FILE" | sed -E 's/^version: //')

# Check if build number exists
if [[ "$CURRENT_VERSION_LINE" == *"+"* ]]; then
    # Extract and increment build number
    CURRENT_BUILD=$(echo "$CURRENT_VERSION_LINE" | sed -E 's/.*\+([0-9]+)/\1/')
    NEW_BUILD=$((CURRENT_BUILD + 1))
    FULL_VERSION="${NEW_VERSION}+${NEW_BUILD}"
    echo "Found existing build number: $CURRENT_BUILD, incrementing to: $NEW_BUILD"
else
    # No build number exists, use version without build number
    FULL_VERSION="${NEW_VERSION}"
    NEW_BUILD=""
    echo "No build number found, using version without build number"
fi

echo "Updating $PUBSPEC_FILE to version $FULL_VERSION"

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS requires empty string for -i flag
    sed -i '' "s/^version: .*/version: $FULL_VERSION/" "$PUBSPEC_FILE"
else
    # Linux
    sed -i "s/^version: .*/version: $FULL_VERSION/" "$PUBSPEC_FILE"
fi

echo "Updating $README_FILE..."

# Update README.md - version badge
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS requires empty string for -i flag
    sed -i '' "s/version-[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*-blue/version-$NEW_VERSION-blue/" "$README_FILE"
    if [ -n "$NEW_BUILD" ]; then
        sed -i '' "s/build-[0-9][0-9]*-blue/build-$NEW_BUILD-blue/" "$README_FILE"
    fi
else
    # Linux
    sed -i "s/version-[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*-blue/version-$NEW_VERSION-blue/" "$README_FILE"
    if [ -n "$NEW_BUILD" ]; then
        sed -i "s/build-[0-9][0-9]*-blue/build-$NEW_BUILD-blue/" "$README_FILE"
    fi
fi

if [ -n "$NEW_BUILD" ]; then
    echo "✓ Version updated to $FULL_VERSION (semantic: $NEW_VERSION, build: $NEW_BUILD)"
else
    echo "✓ Version updated to $FULL_VERSION (semantic: $NEW_VERSION)"
fi
echo "✓ Updated $PUBSPEC_FILE and $README_FILE"
