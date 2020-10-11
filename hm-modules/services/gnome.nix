{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.gnome3;

  extensionsUuids = map (x: if (strings.isStorePath x) then x.uuid else x) cfg.extensions;
  extensionsPackages = builtins.filter strings.isStorePath cfg.extensions;

  mapGnomeSettings = n: v: nameValuePair ("org/gnome/" + n) v;
in
{
  options = {
    gnome3 = {
      extensions = mkOption {
        description = "List of Gnome extensions to be installed and enabled.";
        type = with types; listOf (either package str);
        default = [ ];
        example = ''with pkgs.gnomeExtensions; [
            dash-to-panel
            arc-menu
            "
        ]
        '';
      };
      settings = mkOption {
        description = "Gnome settings";
        default = { };
      };
    };
  };
  config = {
    home.packages = extensionsPackages;

    dconf.settings = {
      "org/gnome/shell".enabled-extensions = extensionsUuids;
    } // (mapAttrs' mapGnomeSettings cfg.settings);
  };
}
