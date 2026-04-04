# Single-node k3s cluster configuration
{ pkgs, ... }:

{
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--disable=traefik"
      "--disable=metrics-server"
      "--write-kubeconfig-mode=0644"
    ];
  };

  environment.systemPackages = with pkgs; [
    k3s
    kubectl
    fluxcd
  ];

  networking.firewall.allowedTCPPorts = [ 6443 ];
  networking.firewall.allowedUDPPorts = [ 8472 ];
}
