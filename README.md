# Nix Home Manager Config

Modular Home Manager configuration for macOS and NixOS.

## Usage

### Apply configuration
```bash
nix run home-manager/master -- switch
```

### Update flake inputs
```bash
nix flake update
```

### Test compilation
```bash
nix build .#homeConfigurations.emorio@macbook-m2-pro.activationPackage
```

## Structure

```
├── flake.nix                 # Entry point with host definitions
├── hosts/
│   ├── macbook-m2-pro/       # macOS host config
│   └── thinkcentre-i5-32gb/  # NixOS host config (root user)
└── modules/
    ├── darwin/               # macOS-specific modules
    │   └── packages.nix
    └── shared/               # Shared modules
        └── home-manager.nix
```

## Configuration

### Add packages
Edit `modules/darwin/packages.nix`:
```nix
home.packages = with pkgs; [
  fzf
  ripgrep
];
```

### Modify host settings
Edit `hosts/<hostname>/home.nix` for host-specific changes.

### Shared settings
Edit `modules/shared/home-manager.nix` for settings used across all hosts.
