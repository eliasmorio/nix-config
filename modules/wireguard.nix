{ ... }:
{
  networking.firewall.allowedUDPPorts = [ 51820 ];

  boot.kernel.sysctl."net.ipv4.ip_forward" = true;

  networking.nat = {
    enable = true;
    externalInterface = "enp0s31f6";
    internalInterfaces = [ "wg0" ];
  };

  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.50.0.1/24" ];
    listenPort = 51820;
    privateKeyFile = "/etc/wireguard/wg0.key";

    peers = [
      {
        publicKey = "CLE_PUBLIQUE_CLIENT";
        allowedIPs = [ "10.50.0.2/32" ];
      }
    ];
  };
}
