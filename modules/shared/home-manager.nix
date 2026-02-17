{ config, pkgs, user, email, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = user;
        email = email;
      };
    };
  };
}
