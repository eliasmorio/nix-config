#!/bin/bash

set -e

echo "Building NixOS configuration for thinkserver1..."

# Build the NixOS configuration
nix build .#nixosConfigurations.thinkserver1.config.system.build.toplevel

echo "Build successful!"
echo ""
echo "To apply on the server:"
echo "  1. Copy hardware-configuration.nix to hosts/thinkserver1/"
echo "  2. Transfer the config to the server"
echo "  3. Run: sudo nixos-rebuild switch --flake .#thinkserver1"