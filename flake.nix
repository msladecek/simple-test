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
        treefmtEval = treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs.cljfmt.enable = true;
          programs.cljfmt.includes = [ "simple-test" ];
          programs.black.enable = true;
          programs.nixfmt.enable = true;
        };
      in
      {
        formatter = treefmtEval.config.build.wrapper;
        packages.default = pkgs.stdenv.mkDerivation {
          name = "simple-test";
          src = ./.;
          doCheck = true;
          nativeCheckInputs = with pkgs; [
            babashka
            python3
            bash
          ];
          postPatch = ''
            patchShebangs simple-test tests/ examples/
          '';
          checkPhase = ''
            chmod +x simple-test tests/*.sh examples/*/*.py
            chmod -x examples/fail/test_no_shebang.py
            ./simple-test tests/*.sh
          '';
          installPhase = ''
            mkdir -p $out/bin
            install -Dm755 simple-test $out/bin/simple-test
          '';
        };
        checks = {
          test = self.packages.${system}.default;
          format = treefmtEval.config.build.check self;
        };
        devShells.default = pkgs.mkShell {
          name = "simple-test";
          buildInputs = with pkgs; [
            bash
            python3
            babashka
          ];
        };
      }
    );
}
