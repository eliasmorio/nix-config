# Tainted k3s agent configuration for additional worker nodes
{ pkgs, ... }:

{
  services.k3s = {
    enable = true;
    role = "agent";
    serverAddr = "https://192.168.2.201:6443";
    tokenFile = "/etc/rancher/k3s/token";
    nodeTaint = [ "node-role.kubernetes.io/arm-worker=true:NoSchedule" ];
  };

  environment.systemPackages = with pkgs; [
    k3s
    kubectl
  ];

  systemd.tmpfiles.rules = [
    "d /etc/rancher/k3s 0750 root root -"
  ];

  networking.firewall.allowedTCPPorts = [ 10250 ];
  networking.firewall.allowedUDPPorts = [ 8472 ];
}
