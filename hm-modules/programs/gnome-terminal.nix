{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.gnome-terminal;
in
{
  options = {
    programs.gnome-terminal = {
      keybindings = mkOption {
        default = { };
        type = types.attrsOf str;
      };
    };

    config = mkIf cfg.enable {
      dconf.settings =
        let dconfPath = "org/gnome/terminal/legacy";
        in
        {
          keybindings = cfg.keybindings;
        };
    };
  }
