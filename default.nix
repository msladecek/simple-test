{
  pkgs ? import <nixpkgs> { },
}:
pkgs.stdenv.mkDerivation {
  name = "simple-test";
  src = ./.;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 $src/simple-test $out/bin/simple-test
  '';
  postFixup = ''
    wrapProgram $out/bin/simple-test \
      --set PATH ${pkgs.lib.makeBinPath [ pkgs.babashka ]}
  '';
}
