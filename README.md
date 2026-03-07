# NixOS Configuration

Minimal steps to reproduce this host setup (`thinkserver1`).

## 1) Clone

```bash
git clone <repo-url>
cd nix-config
```

## 2) Create WireGuard server key (required once)

```bash
sudo install -m 0700 -d /etc/wireguard
wg genkey | sudo tee /etc/wireguard/wg0.key | wg pubkey | sudo tee /etc/wireguard/wg0.pub
sudo chmod 600 /etc/wireguard/wg0.key
```

## 3) Apply system config

```bash
sudo nixos-rebuild switch --flake .#thinkserver1
```

## 4) Apply Home Manager config

```bash
home-manager switch --flake .#emorio@thinkserver1
```

## Optional

```bash
nix flake update
```
