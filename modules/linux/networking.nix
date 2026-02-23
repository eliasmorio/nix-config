{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 22 8123 6443 ];
}
