{ config, pkgs, ... }:
{
  services.home-assistant = {
    enable = true;
    extraComponents = [ "default_config" "met" "esphome" "radio_browser" ];
    config = {
      homeassistant = {
        name = "home assistant";
        time_zone = "Europe/Paris";
        unit_system = "metric";
      };
      frontend = {};
    };
  };
}
