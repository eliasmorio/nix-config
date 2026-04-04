# AGENTS.md

Guidelines for AI agents working in this NixOS configuration repository.

## Repository Overview

Flake-based NixOS configuration with Home Manager integration and deploy-rs for remote deployments.

- **Hosts**: `thinkserver1` (x86_64-linux), `radxa-rock5b-1` (aarch64-linux)
- **Flake inputs**: nixpkgs (unstable), home-manager, deploy-rs
- **Home Manager**: Integrated as NixOS module (not standalone)

## Build Commands

### Development Shell

```bash
nix develop    # Provides: nil, nixfmt, statix
```

### Format & Lint

```bash
nix fmt                             # Format all .nix files
nix fmt -- --check .                # Check only
nix run nixpkgs#statix -- check .   # Lint
nix run nixpkgs#statix -- fix .     # Auto-fix
```

### Validate Single Host

```bash
nix eval .#nixosConfigurations.thinkserver1.config.system.build.toplevel.drvPath
nix eval .#nixosConfigurations.radxa-rock5b-1.config.system.build.toplevel.drvPath
```

### Build & Deploy

```bash
nixos-rebuild build --flake .#thinkserver1          # Build only
sudo nixos-rebuild switch --flake .#thinkserver1    # Build and switch

# Remote deploy (use --skip-checks from macOS)
nix run github:serokell/deploy-rs -- .#thinkserver1 --skip-checks
nix run github:serokell/deploy-rs -- . --skip-checks  # All hosts
```

### Update Dependencies

```bash
nix flake update
```

## Pre-commit Hook

```bash
git config core.hooksPath .githooks
```

Runs: format check, statix lint, nix eval for all hosts.

## Code Style Guidelines

### File Header

Every `.nix` file starts with a single-line comment:

```nix
# Hardened OpenSSH server configuration
```

### Module Function Signature

Include only arguments you need:

```nix
{ config, lib, pkgs, ... }:   # When using config, lib, pkgs
{ pkgs, ... }:                # When using only pkgs
_:                            # When using no arguments
```

### Imports

Use relative paths:

```nix
imports = [
  ./hardware-configuration.nix
  ../../modules/nixos/common.nix
];
```

### Formatting

- **Formatter**: `nixfmt` (official)
- **Indentation**: 2 spaces (enforced by nixfmt)
- Always run `nix fmt` before committing

### Package Lists

Use `with pkgs;` pattern:

```nix
environment.systemPackages = with pkgs; [
  vim
  git
  htop
];
```

### String Interpolation

```nix
home-manager.users.emorio = import ./hosts/${hostName}/home.nix;
ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel run";
```

### Override Control

```nix
nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";           # Default
users.users.emorio.extraGroups = lib.mkAfter [ "networkmanager" ];  # Append
```

### Comments

Place above the block, explain "why" not "what":

```nix
# Automatic garbage collection
nix.gc = {
  automatic = true;
  dates = "weekly";
};
```

### Naming Conventions

- **Hosts**: lowercase with hyphens (`thinkserver1`, `radxa-rock5b-1`)
- **Modules**: lowercase with hyphens (`ssh-server.nix`)
- **Variables**: camelCase (`x86System`, `homeManagerModule`)

## Directory Structure

```
nix-config/
├── flake.nix              # Main flake definition
├── hosts/<hostname>/
│   ├── configuration.nix  # NixOS config
│   ├── hardware-configuration.nix
│   └── home.nix           # Home Manager config
└── modules/
    ├── nixos/             # NixOS modules (common.nix, users/)
    ├── home-manager/      # Home Manager modules
    └── *.nix              # Service modules (k3s, cloudflared)
```

## Adding a New Host

1. Create `hosts/<hostname>/` with `configuration.nix`, `hardware-configuration.nix`, `home.nix`
2. Add `nixosConfigurations.<hostname>` and `deploy.nodes.<hostname>` to `flake.nix`
3. Validate: `nix eval .#nixosConfigurations.<hostname>.config.system.build.toplevel.drvPath`

## Common Mistakes

- Forgetting `nix fmt` before committing
- Using `{ }:` instead of `_:` when no arguments used
- Hardcoding paths instead of `${pkgs.package}/bin/`
- Missing `lib.mkAfter` when appending to lists from other modules
