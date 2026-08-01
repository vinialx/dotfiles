{
  config,
  pkgs,
  ...
}:
{
  home.username = "vinicius";
  home.homeDirectory = "/home/vinicius";
  home.stateVersion = "26.05";

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
  home.packages = with pkgs; [
    anydesk
    awww
    bitwarden-desktop
    bluez
    brave
    brightnessctl
    burpsuite
    chromium
    cliphist
    dbeaver-bin
    ente-auth
    eza
    fastfetch
    fd
    flyctl
    fzf
    gcc
    gnome-tweaks
    grim
    hyprshade
    imagemagick
    insomnia
    iscc
    libreoffice-fresh
    matugen
    neovim
    networkmanager
    ngrok
    nil
    nodejs
    nwg-panel
    obs-studio
    obsidian
    opencode
    openssl
    pamixer
    pavucontrol
    phinger-cursors
    playerctl
    proton-vpn-cli
    remmina
    ripgrep
    shotcut
    slurp
    spotify
    swappy
    swaynotificationcenter
    tenacity
    unzip
    vesktop
    warehouse
    wlogout
    wl-clipboard
    ytmdesktop
  ];

  programs.bat.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.firefox.enable = true;
  programs.firefox.configPath = "${config.xdg.configHome}/mozilla/firefox";

  programs.gh.enable = true;

  programs.git = {
    enable = true;
    userName = "vinicius";
    userEmail = "vini.aloise.silva@gmail.com";
  };

  #matugen configuration.
  xdg.configFile."matugen".source =
    config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/matugen";

  #swaync configuration.
  xdg.configFile."swaync/config.json".source =
    config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/swaync/config.json";

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Mellifluous";
      "window-decoration" = "none";
      "background-opacity" = 0.9;
      "background-blur" = 30;
      "font-family" = "Hurmit Nerd Font Mono";
      "font-size" = 13;
      "cursor-style" = "bar";
      "cursor-style-blink" = true;
      "shell-integration" = "zsh";
      "window-padding-x" = 8;
      "window-padding-y" = 4;
    };
  };

  #terminal configuration.
  programs.tmux.enable = true;
  programs.zoxide.enable = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (
      builtins.readFile "${pkgs.starship}/share/starship/presets/pastel-powerline.toml"
    );
  };

  # nwg-panel configuration.
  xdg.configFile."nwg-panel".source =
    config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/nwg-panel";

  #zsh configuration.
  programs.zsh = {
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

  #rofi configuration.
  programs.rofi = {
    enable = true;
    theme = "theme";
  };

  #hyprland configuration.
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    settings = {
      monitor = [
        "DP-1, 1920x1080@144, 0x0, 1"
        "eDP-1, 1920x1080@165, 0x1080, 1"
      ];

      input = {
        kb_layout = "br";
        kb_variant = "abnt2";
      };

      "$mod" = "SUPER";

      bind = [
        "$mod, T, exec, ghostty"
        "$mod, Q, killactive,"
        "$mod SHIFT, Q, forcekillactive"
        "$mod, E, exec, nautilus"
        #"$mod SHIFT, L, exit"
        "$mod, V, togglefloating,"
        "$mod, R, exec, rofi -show drun"
        #move windows.
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"
        #window focus (neovim style).
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"
        #flameshot screenshot.
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
        #workspaces.
        "$mod, LEFT, workspace, -1"
        "$mod, RIGHT, workspace, +1"
        "$mod SHIFT, LEFT, movetoworkspace, -1"
        "$mod SHIFT, RIGHT, movetoworkspace, +1"
        #special workspace.
        "$mod, M, movetoworkspacesilent, special"
        "$mod SHIFT, M, togglespecialworkspace,"
        #power menu.
        "$mod, X, exec, wlogout"
        #notification center.
        "$mod, N, exec, swaync-client -t -sw"
      ];

      binde = [
        "$mod CONTROL, l, resizeactive, 20 0"
        "$mod CONTROL, h, resizeactive, -20 0"
        "$mod CONTROL, k, resizeactive, 0 -20"
        "$mod CONTROL, j, resizeactive, 0 20"
      ];

      # animations.
      animations = {
        enabled = true;
        bezier = [
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothIn, 0.25, 0.1, 0.25, 1"
        ];
        animation = [
          "windows, 1, 4, easeOutExpo, popin 85%"
          "windowsOut, 1, 4, easeInOutCubic, popin 85%"
          "windowsMove, 1, 4, easeOutExpo"
          "border, 1, 8, default"
          "borderangle, 1, 30, default, loop"
          "fade, 1, 4, smoothIn"
          "workspaces, 1, 5, overshot, slide"
          "specialWorkspace, 1, 4, overshot, slidevert"
        ];
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(ffffffee) rgba(888888aa) 45deg";
        "col.inactive_border" = "rgba(1a1a1aaa)";
        layout = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.95;

        shadow = {
          enabled = true;
          range = 18;
          render_power = 3;
          color = "rgba(00000088)";
        };

        blur = {
          enabled = true;
          size = 4;
          passes = 2;
          new_optimizations = true;
          vibrancy = 0.18;
        };
      };

      dwindle = {
        preserve_split = true;
        smart_resizing = true;
      };

      exec-once = [
        "waybar"
        "awww-daemon"
        "wl-paste --watch cliphist store"
        "swaync"
      ];
    };
  };

  #waybar configuration.
  xdg.configFile."waybar/config".source =
    config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/waybar/config";

  programs.waybar = {
    enable = true;
    style = config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/waybar/style.css";
  };

  # wlogout configuration.
  xdg.configFile."wlogout/layout".source =
    config.lib.file.mkOutOfStoreSymlink "/home/vinicius/dotfiles/wlogout/layout";

}
