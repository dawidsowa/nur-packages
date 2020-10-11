{ stdenv, fetchFromGitHub, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-maximized-by-default";
  version = "1.1.0";

  src = fetchFromGitHub {
    repo = "gnome-shell-extension-maximized-by-default";
    owner = "aXe1";
    rev = "v${version}";
    sha256 = "1ga2f0kc8nkl34cdksy9dg4nybg7s4gx33z6f8y46ldwfbr9m1x9";
  };

  uuid = "gnome-shell-extension-maximized-by-default@axe1.github.com";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r src $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Make all windows maximized on start";
    license = licenses.mit;
    maintainers = with maintainers; [ dawidsowa ];
    homepage = "https://github.com/aXe1/gnome-shell-extension-maximized-by-default";
  };
}
