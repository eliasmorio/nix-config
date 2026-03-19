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
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
