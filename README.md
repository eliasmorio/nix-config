# NixOS Configuration

Multi-host NixOS configuration with Home Manager integration and deploy-rs for remote deployments.

## Hosts

| Host             | Architecture  | Description                                |
| ---------------- | ------------- | ------------------------------------------ |
| `thinkserver1`   | x86_64-linux  | Main server with k3s and Cloudflare tunnel |
| `radxa-rock5b-1` | aarch64-linux | ARM64 single-board computer                |

## Quick Start

### 1. Clone

```bash
git clone <repo-url>
cd nix-config
```

### 2. Create WireGuard server key (required once per host)

```bash
sudo install -m 0700 -d /etc/wireguard
wg genkey | sudo tee /etc/wireguard/wg0.key | wg pubkey | sudo tee /etc/wireguard/wg0.pub
sudo chmod 600 /etc/wireguard/wg0.key
```

### 3. Set user password (required after first deploy)

```bash
sudo passwd emorio
```

### 4. Apply configuration

Home Manager is now integrated into NixOS, so a single command deploys everything:

```bash
sudo nixos-rebuild switch --flake .#thinkserver1
```

### K3S reset

```bash
sudo systemctl stop k3s
sudo rm -rf /var/lib/rancher/k3s
sudo nixos-rebuild switch --flake .#thinkserver1
sudo systemctl start k3s
```

## Remote Deployment with deploy-rs

Deploy to remote hosts:

```bash
# Deploy to a specific host
nix run github:serokell/deploy-rs -- .#thinkserver1 --skip-checks
nix run github:serokell/deploy-rs -- .#radxa-rock5b-1 --skip-checks

# Deploy to all hosts
nix run github:serokell/deploy-rs -- . --skip-checks
```

> **Note:** Use `--skip-checks` when deploying from macOS since the checks require Linux to build.

## Development

Enter development shell with Nix tooling:

```bash
nix develop
```

This provides:

- `nil` - Nix language server
- `nixfmt` - Nix formatter
- `statix` - Nix linter

### Format code

```bash
nix fmt
```

### Check for issues

```bash
nix run nixpkgs#statix -- check .
```

### Update flake inputs

```bash
nix flake update
```

## Pre-commit Hook

Enable the Git pre-commit hook to validate changes before committing:

```bash
git config core.hooksPath .githooks
```

This runs:

1. Format check (`nix fmt --check`)
2. Linting (`statix check`)
3. Nix evaluation for all configurations

## Cloudflare Tunnel (`*.eliasmorio.fr`)

This repo uses a remotely-managed tunnel token (`home-tunnel`).

### Setup

1. In Cloudflare Zero Trust, configure tunnel `home-tunnel` with:
   - Public hostname `*.eliasmorio.fr`
   - Service `http://192.168.2.201:80`

2. On the host, create the token env file (do not commit):

```bash
sudo install -m 0750 -d /etc/cloudflared
sudo install -m 0600 /dev/null /etc/cloudflared/cloudflared.env
sudo sh -c 'printf "%s\n" "TUNNEL_TOKEN=<YOUR_TOKEN>" > /etc/cloudflared/cloudflared.env'
```

3. Apply configuration and verify:

```bash
sudo nixos-rebuild switch --flake .#thinkserver1
systemctl status cloudflared
```

## Directory Structure

```
nix-config/
├── flake.nix              # Main flake with all host definitions
├── flake.lock             # Locked dependencies
├── hosts/
│   ├── thinkserver1/
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── home.nix
│   └── radxa-rock5b-1/
│       └── ...
├── modules/
│   ├── nixos/
│   │   ├── common.nix         # Shared NixOS settings
│   │   ├── locale-fr.nix      # French locale
│   │   ├── ssh-server.nix     # Hardened SSH
│   │   └── users/
│   │       └── emorio.nix     # User definition
│   ├── home-manager/
│   │   ├── common.nix         # Shared packages
│   │   ├── git.nix            # Git config
│   │   └── shell.nix          # Bash aliases
│   ├── k3s.nix                # Kubernetes (k3s)
│   └── cloudflared.nix        # Cloudflare tunnel
└── .githooks/
    └── pre-commit             # Validation hook
```
