{ config, lib, pkgs, ... }:
let
  inherit (builtins) concatStringsSep;
  inherit (lib) mkOption;
  renderKeys = conf:
    concatStringsSep "\n\n"
      (
        map
          (x:
            (concatStringsSep "\n" x.identifier)
            + "\n"
            + (concatStringsSep "\n" (lib.mapAttrsToList (n: v: " KEYBOARD_KEY_${n}=${v}") x.keys))
          )
          conf
      );
in
{
  options.services.udev.mapKeyboard = mkOption {
    default = { };
  };
  config = {
    services.udev.extraHwdb = renderKeys config.services.udev.mapKeyboard;
  };
}
