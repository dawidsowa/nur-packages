{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.autokey;
in
{
  meta.maintainers = [ maintainers.dawidsowa ];

  options = {
    services.autokey = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Autokey
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.autokey = {
      Service = {
        ExecStartPre = "${pkgs.xorg.xhost}/bin/xhost +";
        ExecStart = "${pkgs.autokey}/bin/autokey-gtk";
      };
      Unit = {
        Description = "autokey";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
