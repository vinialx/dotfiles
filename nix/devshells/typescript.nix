{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    bun
    nodejs
    vtsls
  ];
}
