#!/usr/bin/env bash
# Quick validation of the Nix flake setup

echo "Checking Nix flake files..."

# Check if flake.nix exists
if [ ! -f "flake.nix" ]; then
    echo "❌ flake.nix not found"
    exit 1
fi
echo "✓ flake.nix exists"

# Check if package-lock.json exists
if [ ! -f "package-lock.json" ]; then
    echo "❌ package-lock.json not found"
    exit 1
fi
echo "✓ package-lock.json exists"

# Check if .envrc exists
if [ ! -f ".envrc" ]; then
    echo "⚠️  .envrc not found (optional)"
else
    echo "✓ .envrc exists"
fi

# Check if NIX_SETUP.md exists
if [ ! -f "NIX_SETUP.md" ]; then
    echo "⚠️  NIX_SETUP.md not found (optional)"
else
    echo "✓ NIX_SETUP.md exists"
fi

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    echo ""
    echo "⚠️  Nix is not installed on this system"
    echo "   To install Nix: https://nixos.org/download.html"
    echo ""
    echo "Files are ready, but you'll need Nix to build and run."
    echo ""
    echo "Next steps on a system with Nix:"
    echo "  1. Run: ./update-nix-hash.sh"
    echo "  2. Run: nix build"
    echo "  3. Run: nix run"
    exit 0
fi

echo "✓ Nix is installed"

# Check flake syntax
echo ""
echo "Checking flake syntax..."
if nix flake check 2>&1 | grep -q "error:"; then
    echo "❌ Flake has syntax errors"
    nix flake check
    exit 1
else
    echo "✓ Flake syntax is valid"
fi

# Check if hash needs to be updated
if grep -q "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" flake.nix; then
    echo ""
    echo "⚠️  npm dependencies hash needs to be updated"
    echo "   Run: ./update-nix-hash.sh"
    echo "   Or manually: nix run nixpkgs#prefetch-npm-deps package-lock.json"
    exit 0
fi

echo ""
echo "✓ All checks passed!"
echo ""
echo "You can now:"
echo "  - Build: nix build"
echo "  - Run: nix run"
echo "  - Develop: nix develop"

