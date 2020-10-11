{ stdenv, fetchFromGitHub, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-hide-minimized";
  version = "2020-02-25";

  src = fetchFromGitHub {
    repo = "hide-minimized";
    owner = "danigm";
    rev = "612fcbb3ebc45a703ddbab2ef81194a62e382242";
    sha256 = "1chw1mm2zqd0z1cw894klvgsrxh1bpnfrxf2p8sf30nxcily97bf";
  };

  uuid = "hide-minimized@danigm.net";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp {extension.js,metadata.json} $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Gnome shell extension to hide minimized windows in overview";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dawidsowa ];
    homepage = "https://github.com/danigm/hide-minimized";
  };
}
