{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    clang
    clang-tools
    gnumake
    cmake
    gdb
    cppcheck
  ];
}
