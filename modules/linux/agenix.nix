{ config, pkgs, lib, ... }:
let
  secretsFile = ../../secrets.nix;
in
{
  imports = lib.optional (builtins.pathExists secretsFile) secretsFile;

  age = {
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = lib.mkIf (builtins.pathExists secretsFile) {
      wg0-private = {
        file = ../../secrets/wg0-private.age;
        owner = "root";
        group = "root";
        mode = "600";
      };
    };
  };
}