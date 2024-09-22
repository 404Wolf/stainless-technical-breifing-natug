{
  description = "NATuG Technical Document";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells.default = pkgs.mkShell {
        shellHook = ''
          alias words="pdfgrep "" document.pdf | wc -w"
        '';
        packages = with pkgs; [
          typst
          typst-lsp
          pdfgrep
          mermaid-cli
        ];
      };
    });
}
