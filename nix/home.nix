{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [
    inputs.noctalia.homeModules.default
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };

  programs.spicetify = {
    enable = true;
    wayland = true;
    experimentalFeatures = true;

    theme = spicePkgs.themes.dribbblish;
    colorScheme = "custom";

    customColorScheme = {
      text = "F2F2F2";
      subtext = "B8B8C0";

      main = "18181C";
      sidebar = "40404D";
      player = "202026";

      card = "292932";
      shadow = "101014";
      selected-row = "4A4A58";

      button = "8B8B9B";
      button-active = "A0A0B0";
      button-disabled = "595965";

      tab-active = "F2F2F2";

      notification = "8B8B9B";
      notification-error = "D45D68";

      misc = "777785";
    };
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
    #system & hardware.
    bluez
    blueman
    dbeaver-bin
    dhcpcd
    networkmanager
    networkmanagerapplet
    proton-vpn-cli

    #shell & cli utilities.
    eza
    fastfetch
    fd
    fzf
    ripgrep
    statix
    tree
    unzip
    wl-clipboard

    #dev tools.
    gcc
    insomnia
    neovim
    ngrok
    nil
    nodejs
    opencode
    openssl

    #database.
    rainfrog
    postgresql

    #browsers.
    brave
    chromium

    #communication & productivity.
    anydesk
    libnotify
    libreoffice-fresh
    nemo
    notes
    remmina
    vesktop

    #security.
    bitwarden-desktop
    burpsuite
    ente-auth

    #media & graphics.
    ffmpeg
    grim
    gvfs
    image-roll
    imagemagick
    mpv
    mpvpaper
    obs-studio
    shotcut
    slurp
    swappy

    #audio & music.
    pavucontrol
    playerctl
    tenacity
    ytmdesktop

    #theming.
    hyprshade
    matugen

    #study.
    calibre
    exercism
    obsidian
    teams-for-linux

    #packaging & misc.
    flyctl
    iscc
    warehouse
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
      ##fastfetch.
      "fastfetch".source = lib.mkForce (
        config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/fastfetch"
      );

      ##ghostty.
      "ghostty/config".source =
        config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/ghostty/config";

      ##noctalia.
      "noctalia".source = lib.mkForce (
        config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/noctalia"
      );

      ##starship.
      "starship.toml".source = lib.mkForce (
        config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/starship/starship.toml"
      );

      ##swappy.
      "swappy/config".source =
        config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/swappy/config";
    };
  };
}
