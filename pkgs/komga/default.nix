{ stdenv, fetchurl, bash, jre }:
stdenv.mkDerivation rec {
  pname = "komga";
  version = "0.43.4";

  src = fetchurl {
    url = "https://github.com/gotson/komga/releases/download/v${version}/komga-${version}.jar";
    sha256 = "1wnpy606cav7yr1yihpfgpfbqy97mxpngrm9xyy66i6vvvd39vn6";
  };

  preferLocalBuild = true;

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    cat > komga << EOF
    #!${bash}/bin/bash
    exec ${jre}/bin/java \$@ -jar $out/share/komga/komga.jar
  '';

  installPhase = ''
    install -Dm444 ${src} $out/share/komga/komga.jar
    install -Dm555 -t $out/bin komga
  '';
}
