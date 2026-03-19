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

## Optional: Cloudflare Tunnel (`*.eliasmorio.fr`)

This repo uses a remotely-managed tunnel token (`home-tunnel`) and keeps secrets out of Git.

1) In Cloudflare Zero Trust, configure tunnel `home-tunnel` with:

- Public hostname `*.eliasmorio.fr`
- Service `http://192.168.2.201:80`

2) On the host, create the token env file (do not commit it):

```bash
sudo install -m 0750 -d /etc/cloudflared
sudo install -m 0600 /dev/null /etc/cloudflared/cloudflared.env
sudo sh -c 'printf "%s\n" "TUNNEL_TOKEN=<YOUR_TOKEN>" > /etc/cloudflared/cloudflared.env'
```

3) Apply system config:

```bash
sudo nixos-rebuild switch --flake .#thinkserver1
```

4) Verify service and tunnel:

```bash
systemctl status cloudflared
journalctl -u cloudflared -n 100 --no-pager
```

## Optional: enable Git pre-commit Nix eval hook

```bash
git config core.hooksPath .githooks
```

This runs `nix eval` for both the NixOS and Home Manager flake outputs before each commit.
