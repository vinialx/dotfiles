{
  config,
  pkgs,
  ...
}:
let
  orbit = pkgs.callPackage ./packages/orbit.nix { };
in
{
  home = {
    username = "vinicius";
    homeDirectory = "/home/vinicius";
    stateVersion = "26.05";
  };

  home.enableNixpkgsReleaseCheck = false;

  #cursor.
  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 20;
    gtk.enable = true;
    x11.enable = true;
  };

  #home packages.
  home.packages =
    with pkgs;
    [
      anydesk
      awww
      bitwarden-desktop
      bluez
      blueman
      brave
      burpsuite
      chromium
      cliphist
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
      nwg-bar
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
      rofi
      shotcut
      slurp
      spotify
      statix
      swappy
      swaynotificationcenter
      swayosd
      tenacity
      unzip
      vesktop
      warehouse
      waybar
      wl-clipboard
      ytmdesktop
    ]
    ++ [ orbit ];

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

  #orbit configuration.
  systemd.user.services.orbit = {
    Unit.Description = "Orbit Wifi + Bluetooth manager";
    Service = {
      ExecStart = "${orbit}/bin/orbit daemon";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install.WantedBy = [ "default.target" ];
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
      ##orbit.
      "orbit/config.toml".source =
        config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/orbit/config.toml";

      ##ghostty.
      "ghostty/config".source =
        config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/ghostty/config";

      ##rofi.
      "rofi/config.rasi".source =
        config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/rofi/config.rasi";

      ##waybar.
      "waybar/config".source =
        config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/waybar/config";

      ##matugen.
      "matugen".source = config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/matugen";

      ##nwg-bar.
      "nwg-bar/bar.json".source =
        config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/nwg-bar/bar.json";

      ##swaync.
      "swaync/config.json".source =
        config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/swaync/config.json";
    };
  };
}
