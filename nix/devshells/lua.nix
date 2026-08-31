{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    lua54
    lua-language-server
    stylua
    selene
  ];
}
