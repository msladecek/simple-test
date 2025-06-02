{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.11";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        treefmt-config = {
          projectRootFile = "flake.nix";
          programs.cljfmt.enable = true;
          programs.cljfmt.includes = [ "simple-test" ];
          programs.black.enable = true;
          programs.nixfmt.enable = true;
        };
      in
      {
        formatter = treefmt-nix.lib.mkWrapper pkgs treefmt-config;
        packages.default = pkgs.stdenv.mkDerivation {
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
        };

        devShells.default = pkgs.mkShell {
          name = "simple-test";
          buildInputs = with pkgs; [
            python
            babashka
          ];
        };
      }
    );
}
