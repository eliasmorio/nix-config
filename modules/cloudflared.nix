{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cloudflared
  ];

  systemd.tmpfiles.rules = [
    "d /etc/cloudflared 0750 root root -"
  ];

  systemd.services.cloudflared = {
    description = "Cloudflare Tunnel (remote managed token)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      EnvironmentFile = "/etc/cloudflared/cloudflared.env";
      ExecStart = "${pkgs.bash}/bin/bash -ec '${pkgs.cloudflared}/bin/cloudflared tunnel run --no-autoupdate --token \"$TUNNEL_TOKEN\"'";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
