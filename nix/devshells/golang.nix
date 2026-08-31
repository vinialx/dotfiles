{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    go
    gopls
    gofumpt
    golangci-lint
    delve
  ];
}
