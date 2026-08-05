{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };

  home = {
    username = "vinicius";
    homeDirectory = "/home/vinicius";
    stateVersion = "26.05";

    enableNixpkgsReleaseCheck = false;

    pointerCursor = {
      enable = true;
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 20;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  #home packages.
  home.packages = with pkgs; [
    anydesk
    bitwarden-desktop
    bluez
    blueman
    brave
    burpsuite
    chromium
    dbeaver-bin
    ente-auth
    eza
    fastfetch
    fd
    ffmpeg
    flyctl
    fzf
    gcc
    gnome-tweaks
    grim
    hyprshade
    imagemagick
    insomnia
    iscc
    libnotify
    libreoffice-fresh
    matugen
    mpv
    mpvpaper
    neovim
    networkmanager
    networkmanagerapplet
    ngrok
    nil
    nodejs
    obs-studio
    obsidian
    opencode
    openssl
    pavucontrol
    phinger-cursors
    playerctl
    proton-vpn-cli
    remmina
    ripgrep
    shotcut
    slurp
    spotify
    statix
    swappy
    tenacity
    unzip
    vesktop
    warehouse
    waybar
    wl-clipboard
    ytmdesktop
  ];

  programs = {
    firefox.enable = true;
    firefox.configPath = "${config.xdg.configHome}/mozilla/firefox";

    # terminal configuration.
    gh.enable = true;
    bat.enable = true;
    tmux.enable = true;
    zoxide.enable = true;
    ghostty.enable = true;

    git = {
      enable = true;
      userName = "vinicius";
      userEmail = "vini.aloise.silva@gmail.com";
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "docker"
          "docker-compose"
          "fzf"
          "colored-man-pages"
          "command-not-found"
          "history-substring-search"
        ];
      };
      shellAliases = {
        ls = "eza --icons --group-directories-first";
      };
      initContent = ''
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word

        source ${config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/zsh/custom.zsh"}
      '';
    };
  };

  #hyprland configuration.
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    settings = {
      source = "/home/vinicius/dotfiles/hyprland/hyprland.conf";
    };
  };

  #symlinks.
  xdg = {
    configFile = {
      ##noctalia.
      "noctalia".source = lib.mkForce (
        config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/noctalia"
      );

      ##ghostty.
      "ghostty/config".source =
        config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/ghostty/config";
    };
  };
}
