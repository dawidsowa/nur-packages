pkgs.stdenv.mkDerivation {
  pname = "add-to-recent";
  version = "2020-10-05";

  src = pkgs.fetchFromGitHub {
    repo = "recent";
    owner = "dawidsowa";
    rev = "329e832fb571eb17ddb2c34804f4871cbed223b6";
    sha256 = "1vjfqyabsgfc8l18jwy5hcbrlx9nf7pjfr3zb9b7mapb542a8da4";
  };

  buildInputs = [
    (pkgs.python3.withPackages (ps: [ ps.pygobject3 ]))
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp recent.py $out/bin/recent
  '';
}
