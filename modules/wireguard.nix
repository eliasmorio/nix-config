{ config, pkgs, ... }:
let
  cfg = config.services.wireguard-server;
in
{
  options.services.wireguard-server = {
    enable = pkgs.lib.mkEnableOption "WireGuard VPN server";
    interface = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      default = "eth0";
      description = "External network interface for NAT/masquerading";
    };
  };

  config = pkgs.lib.mkIf cfg.enable {
    boot.kernel.sysctl."net.ipv4.ip_forward" = true;

    networking.wireguard.interfaces.wg0 = {
      ips = [ "10.8.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = config.age.secrets.wg0-private.path;

      postSetup = ''
        iptables -t nat -A POSTROUTING -o ${cfg.interface} -j MASQUERADE
        iptables -A FORWARD -i wg0 -j ACCEPT
        iptables -A FORWARD -o wg0 -j ACCEPT
      '';

      postShutdown = ''
        iptables -t nat -D POSTROUTING -o ${cfg.interface} -j MASQUERADE
        iptables -D FORWARD -i wg0 -j ACCEPT
        iptables -D FORWARD -o wg0 -j ACCEPT
      '';

      peers = [
        {
          publicKey = "WjuGGEje57nyD7oBXc2TXB2xH+ljsXu33Fma7vn0gEU=";
          allowedIPs = [ "10.8.0.2/32" ];
        }
        {
          publicKey = "TOzQ2XWKkCBswpwDbq6LQ7c0inOVuI3IAWKkfqE5jhA=";
          allowedIPs = [ "10.8.0.3/32" ];
        }
      ];
    };
  };
}
