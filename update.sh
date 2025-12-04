#!/usr/bin/env bash
set -euo pipefail

# Get current version from package.nix
CURRENT=$(grep 'version = ' package.nix | head -1 | sed 's/.*"\(.*\)".*/\1/')
echo "Current version: $CURRENT"

# Prompt for new version
read -p "Enter new version (e.g., 0.3.34-1): " VERSION

if [ -z "$VERSION" ]; then
    echo "No version provided, aborting."
    exit 1
fi

URL="https://installers.lmstudio.ai/linux/x64/${VERSION}/LM-Studio-${VERSION}-x64.AppImage"

echo "Fetching hash for $URL..."
HASH=$(nix-prefetch-url "$URL" 2>&1 | tail -1)
SRI_HASH=$(nix hash convert --to sri --hash-algo sha256 "$HASH")

echo "New hash: $SRI_HASH"

# Update package.nix
sed -i "s/version = \".*\"/version = \"$VERSION\"/" package.nix
sed -i "s|hash = \"sha256-.*\"|hash = \"$SRI_HASH\"|" package.nix

echo "Updated package.nix to version $VERSION"
echo ""
echo "Testing build..."
nix build .#lmstudio --accept-flake-config --impure

echo ""
echo "Build successful! Don't forget to commit and push:"
echo "  git add package.nix"
echo "  git commit -m \"Update lmstudio to $VERSION\""
echo "  git push"
