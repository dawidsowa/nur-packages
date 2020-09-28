{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.mergeConfig;
  override = n: v: pkgs.writeText "${n}-override" (lib.generators.toJSON { } v);
  render = concatStringsSep "\n" (mapAttrsToList
    (n: v:
      ''
        jq --slurp '.[0] * .[1]' ${config.xdg.configHome}/${n} ${override n v} | sponge ${config.xdg.configHome}/${n}
      ''
    )
    cfg.JSON);
in
{
  options = {
    mergeConfig.JSON = mkOption {
      default = { };
    };
  };
  config = {
    home.activation.mergeJSON =
      let
        JSONMerge = pkgs.writeShellScript "json-merge" ''
          PATH=${pkgs.jq}/bin:${pkgs.moreutils}/bin
          ${render}
        '';
      in
      lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        ${JSONMerge}
      '';
  };
}
