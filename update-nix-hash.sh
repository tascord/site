#!/usr/bin/env bash
# Helper script to update the npm dependencies hash in flake.nix

set -e

echo "Calculating npm dependencies hash..."

# Try using prefetch-npm-deps if available
if command -v prefetch-npm-deps &> /dev/null; then
    HASH=$(prefetch-npm-deps package-lock.json)
    echo "Hash calculated: $HASH"
else
    echo "prefetch-npm-deps not found. Trying nix build method..."
    
    # Try building and extract hash from error
    if ! BUILD_OUTPUT=$(nix build .#site 2>&1); then
        HASH=$(echo "$BUILD_OUTPUT" | grep -oP 'got:\s+\K\S+' | head -1)
        if [ -n "$HASH" ]; then
            echo "Hash calculated: $HASH"
        else
            echo "Error: Could not extract hash from build output"
            echo "Build output:"
            echo "$BUILD_OUTPUT"
            exit 1
        fi
    else
        echo "Build succeeded - hash might already be correct!"
        exit 0
    fi
fi

# Update flake.nix with the correct hash
if [ -n "$HASH" ]; then
    echo "Updating flake.nix..."
    sed -i "s|npmDepsHash = \"sha256-[^\"]*\";|npmDepsHash = \"$HASH\";|" flake.nix
    echo "Done! Hash updated in flake.nix"
    echo "You can now run: nix build"
else
    echo "Error: No hash calculated"
    exit 1
fi
