{
  config,
  inputs,
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
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 20;
    gtk.enable = true;
    x11.enable = true;
  };

  #home packages.
  home.packages = with pkgs; [
    anydesk
    awww
    bitwarden-desktop
    brave
    burpsuite
    chromium
    dbeaver-bin
    ente-auth
    fd
    flyctl
    fzf
    gcc
    gnome-tweaks
    grim
    imagemagick
    insomnia
    iscc
    libreoffice-fresh
    neovim
    ngrok
    nil
    nodejs
    obs-studio
    obsidian
    opencode
    openssl
    phinger-cursors
    proton-vpn-cli
    remmina
    ripgrep
    shotcut
    slurp
    swappy
    tenacity
    unzip
    vesktop
    warehouse
    ytmdesktop
    zsh
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

  programs.tmux.enable = true;
  programs.zoxide.enable = true;

  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (
      builtins.readFile "${pkgs.starship}/share/starship/presets/pastel-powerline.toml"
    );
  };

  #rofi configuration.
  xdg.configFile."rofi/theme.rasi".source = ../rofi/theme.rasi;

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

      env = [
        "XCURSOR_THEME,phinger-cursors-dark"
        "XCURSOR_SIZE,24"
      ];

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
      ];

      binde = [
        "$mod CONTROL, l, resizeactive, 20 0"
        "$mod CONTROL, h, resizeactive, -20 0"
        "$mod CONTROL, k, resizeactive, 0 -20"
        "$mod CONTROL, j, resizeactive, 0 20"
      ];

      #animations.
      animations = {
        enabled = true;

        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];

        animation = [
          "windows, 1, 3, myBezier"
          "windowsOut, 1, 3, default, popin 80%"
          "border, 1, 5, default"
          "borderangle, 1, 4, default"
          "fade, 1, 3, default"
          "workspaces, 1, 3, default"
        ];
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(7aa2f7ee) rgba(bb9af7ee) 45deg";
        "col.inactive_border" = "rgba(1a1b26aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      exec-once = [
        "waybar"
        "awww-daemon"
      ];
    };
  };

  xdg.configFile."waybar/config".source = ../waybar/config;

  programs.waybar = {
    enable = true;
    style = ../waybar/style.css;
  };

}
