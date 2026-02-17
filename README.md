# Nix Home Manager Config

## Usage

### Apply configuration
```bash
nix run home-manager/master -- switch
```

### Update configuration
Edit `home.nix` and run:
```bash
nix run home-manager/master -- switch
```

### Update flake inputs
```bash
nix flake update
```

## Structure
- `flake.nix` - Entry point defining home-manager
- `home.nix` - Your dotfile declarations
