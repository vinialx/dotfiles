{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    python3
    basedpyright
    ruff
    uv
  ];
}
