# NixOS Configuration

Simple NixOS and Home Manager configuration for thinkserver1.

## Services

- **Home Assistant**: Home automation running on port 8123

## Hosts

- **thinkserver1**: NixOS server with Home Assistant

## Usage

### Apply NixOS system configuration
```bash
sudo nixos-rebuild switch --flake .#thinkserver1
```

### Apply Home Manager configuration
```bash
home-manager switch --flake .#emorio@thinkserver1
```

### Update flake inputs
```bash
nix flake update
```

## Structure

```
├── flake.nix                          # Entry point with host definitions
├── hosts/
│   └── thinkserver1/
│       ├── configuration.nix            # NixOS system configuration
│       ├── hardware-configuration.nix    # Hardware-specific configuration
│       └── home.nix                   # Home Manager user configuration
└── modules/
    └── home-assistant.nix              # Home Assistant module
```

## Network Configuration

- **IP**: 192.168.2.201
- **Gateway**: 192.168.2.254
- **DNS**: 1.1.1.1, 8.8.8.8

## Access Services

- **SSH**: `ssh emorio@thinkserver1`
- **Home Assistant**: http://192.168.2.201:8123
