{ config, pkgs, ... }: {
  systemd.services.docker-compose-home-assistant = {
    description = "Home Assistant Docker Compose Service";
    after = [ "docker.service" "network.target" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/home/emorio/nix-config/hosts/thinkserver1";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f docker-compose.yml up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f docker-compose.yml down";
      User = "root";
    };
  };
}
