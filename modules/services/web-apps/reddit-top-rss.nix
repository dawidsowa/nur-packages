{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.reddit-top-rss;

  poolName = "reddit-top-rss";
in
{
  options = {
    services.reddit-top-rss = {
      enable = mkEnableOption "reddit-top-rss";

      user = mkOption {
        type = types.str;
        default = "nginx";
        example = "nginx";
        description = ''
          User account under which both the service and the web-application run.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "nginx";
        example = "nginx";
        description = ''
          Group under which the web-application run.
        '';
      };

      pool = mkOption {
        type = types.str;
        default = poolName;
        description = ''
          Name of existing phpfpm pool that is used to run web-application.
          If not specified a pool will be created automatically with
          default values.
        '';
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/reddit-top-rss";
        description = ''
          Location in which cache directory will be created.
        '';
      };

      virtualHost = mkOption {
        type = types.nullOr types.str;
        default = "reddit-top-rss";
        description = ''
          Name of the nginx virtualhost to use and setup. If null, do not setup any virtualhost.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.phpfpm.pools = mkIf (cfg.pool == poolName) {
      ${poolName} = {
        user = cfg.user;
        settings = mapAttrs (name: mkDefault) {
          "listen.owner" = cfg.user;
          "listen.group" = cfg.user;
          "listen.mode" = "0600";
          "pm" = "dynamic";
          "pm.max_children" = 75;
          "pm.start_servers" = 10;
          "pm.min_spare_servers" = 5;
          "pm.max_spare_servers" = 20;
          "pm.max_requests" = 500;
          "catch_workers_output" = 1;
        };
      };
    };
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0750 ${cfg.user} ${cfg.group} - -"
    ];

    services.nginx = mkIf (cfg.virtualHost != null) {
      enable = true;
      virtualHosts = {
        ${cfg.virtualHost} = {
          root = pkgs.dawidsowa.reddit-top-rss;

          extraConfig = "index index.php index.html;";

          locations."/" = {
            tryFiles = "$uri $uri/ /index.php?q=$uri&$args";
          };

          locations."~ \.php$" = {
            extraConfig = ''
              include ${pkgs.nginx}/conf/fastcgi_params;
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:${config.services.phpfpm.pools.${cfg.pool}.socket};
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            '';
          };
        };
      };
    };
  };
}
