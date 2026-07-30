{ config, pkgs, ... }:
{
  home.username = "vinicius";
  home.homeDirectory = "/home/vinicius";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    anydesk
    bitwarden-desktop
    brave
    burpsuite
    chromium
    dbeaver-bin
    ente-auth
    fd
    flyctl
    gcc
    gnome-tweaks
    imagemagick
    insomnia
    iscc
    libreoffice-fresh
    ngrok
    nil
    nodejs
    obs-studio
    obsidian
    opencode
    openssl
    proton-vpn-cli
    remmina
    ripgrep
    shotcut
    tenacity
    unzip
    vesktop
    warehouse
  ];

  programs.bat.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.firefox.enable = true;
  programs.fzf.enable = true;

  programs.gh.enable = true;

  programs.git = {
    enable = true;
    userName = "vinicius";
    userEmail = "vini.aloise.silva@gmail.com";
  };

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Mellifluous";
      "window-decoration" = "none";
      "background-opacity" = 0.9;
      "background-blur" = 30;
      "font-family" = "SpaceMono Nerd Font Mono";
      "font-size" = 13;
      "cursor-style" = "bar";
      "cursor-style-blink" = true;
      "shell-integration" = "zsh";
      "window-padding-x" = 8;
      "window-padding-y" = 4;
    };
  };

  programs.neovim.enable = true;
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink ./dotfiles/nvim;

  home.file.".config/ghostty/config".source =
    config.lib.file.mkOutOfStoreSymlink ./dotfiles/ghostty/config;

  programs.tmux.enable = true;

  programs.zoxide.enable = true;

  programs.starship = {
    enable = true;
    settings = {

    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntax-highlighting.enable = true;
  };
}
