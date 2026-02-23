{ config, pkgs, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--disable traefik"
      "--disable metrics-server"
      "--write-kubeconfig-mode 644"
    ];
  };
}
