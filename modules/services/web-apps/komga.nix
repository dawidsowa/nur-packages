{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.komga;
  user = "komga";
  group = "komga";

  appConfig = pkgs.writeText "komga-application.yml" (pkgs.lib.generators.toYAML
    { }
    {
      server.port = cfg.port;
    }
  );
in
{
  options = {
    services.komga = {
      enable = mkEnableOption "komga";

      user = mkOption {
        type = types.str;
        default = user;
        example = user;
        description = ''
          User account under which the web-application run.
        '';
      };

      group = mkOption {
        type = types.str;
        default = group;
        example = group;
        description = ''
          Group under which the web-application run.
        '';
      };

      workDir = mkOption {
        type = types.str;
        default = "/var/lib/komga";
        description = ''
          Location in which directory will be created.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 8080;
        description = "Komga port";
      };

      openFirewall = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to open the firewall for the specified port.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups.${user} = mkIf (cfg.group == group) { };
    users.users.${user} = mkIf (cfg.user == user) {
      group = cfg.group;
      description = "Komga user";
      home = cfg.workDir;
      createHome = false;
    };

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;

    systemd.tmpfiles.rules = [
      "d ${cfg.workDir} 0770 ${cfg.user} ${cfg.group} - -"
      "L+ ${cfg.workDir}/application.yml - - - - ${appConfig}"
    ];

    systemd.services.komga = {
      description = "komga Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.dawidsowa.komga}/bin/komga";
        WorkingDirectory = cfg.workDir;
        User = cfg.user;
        Group = cfg.group;
      };
    };

  };
}
