{
  description = "NATuG Technical Document";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    lovelace = {
      url = "github:andreasKroepelin/lovelace";
      flake = false;
    };
    typst = {
      url = "github:typst/typst";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    typst,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      typst' = typst.packages.${system}.default;
    in {
      packages = rec {
        default = technical-breifing;
        technical-breifing = pkgs.callPackage ./package.nix {typst = typst';};
      };
      devShells.default = pkgs.mkShell {
        shellHook = ''
          alias words="pdfgrep "" document.pdf | wc -w"
        '';
        packages =
          [typst']
          ++ (with pkgs; [
            typst-lsp
            pdfgrep
            mermaid-cli
            entr
            pdfcpu
          ]);
      };
    });
}
