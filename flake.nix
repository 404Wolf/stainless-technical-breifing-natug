{
  description = "NATuG Technical Document";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells.default = pkgs.mkShell {
        shellHook = ''
          alias words="pdfgrep "" document.pdf | wc -w"
        '';
        packages = [
          typst.packages.${system}.default
          pkgs.typst-lsp
          pkgs.pdfgrep
          pkgs.mermaid-cli
          pkgs.entr
        ];
      };
    });
}
