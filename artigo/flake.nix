{
  description = "Flake for Random Walk estimation article";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      my-tex = pkgs.texlive.combine {
        inherit
          (pkgs.texlive)
          scheme-small
          framed
          lualatex-math
          collection-latexextra
          algorithmicx
          algorithms
          ;
      };
    in {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [pkgs.pkg-config];

        buildInputs = with pkgs; [
          quarto
          my-tex
        ];
      };
    });
}
