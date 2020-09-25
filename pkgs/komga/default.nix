{ stdenv, fetchurl, bash, jre }:
stdenv.mkDerivation rec {
  pname = "komga";
  version = "0.62.6";

  src = fetchurl {
    url = "https://github.com/gotson/komga/releases/download/v${version}/komga-${version}.jar";
    sha256 = "09pxwvww9ihknbcnni3wfz41cwr8mir2mfabvmahks5nrn2fs9ny";
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
