{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.gnome-terminal;
in
{
  options = {
    programs.gnome-terminal = {
      keybindings = mkOption {
        description = "You can get currently used by running dconf dump /org/gnome/terminal/legacy/keybindings/";
        default = { };
        example = ''{
          copy = "<Primary>c";
          paste = "<Primary>v";
          }
        '';
        type = types.attrsOf types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    dconf.settings =
      {
        "org/gnome/terminal/legacy/keybindings" = mkIf (cfg.keybindings != { }) cfg.keybindings;
      };
  };
}
