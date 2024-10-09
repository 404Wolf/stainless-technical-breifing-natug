{
  stdenvNoCC,
  mermaid-cli,
  pdfcpu,
  typst,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "technical-breifing";
  buildInputs = [mermaid-cli pdfcpu typst];
  src = ./.;
  buildPhase = ''
    # bug where value of $HOME set to non-writable /homeless-shelter
    export HOME=$(pwd)
    make
  '';
  installPhase = ''
    cp technical_brief.pdf $out
  '';
}
