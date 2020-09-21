{ config, lib, pkgs, fetchFromGitHub, stdenv, ... }:

stdenv.mkDerivation rec {
  pname = "reddit-top-rss";
  version = "2020-05-12";

  src = fetchFromGitHub {
    owner = "johnwarne";
    repo = "reddit-top-rss";
    rev = "5f9d2dfd78f2af457eae38121150bb5f58a7edeb";
    sha256 = "0a00d56x5m3pnm01mc636xpf84vcxxf70jh7k4z0z5qjql0rq1ln";
  };

  patchPhase = builtins.concatStringsSep "\n" (map
    (x: ''substituteInPlace ${x} --replace "cache/" "/var/lib/reddit-top-rss/"'')
    [
      "cache-clear.php"
      "cache.php"
      "postlist.php"
      "rss.php"
      "sort-and-filter.php"
    ]
  );

  installPhase = ''
    mkdir $out/
    cp -R ./* $out
  '';
}
