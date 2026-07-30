{ config, pkgs, ... }:
{
  home.username = "vinicius";
  home.homeDirectory = "/home/vinicius";
  home.stateVersion = "26.05";

  home.enableNixpkgsReleaseCheck = false;

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
    proton-vpn-cli
    remmina
    ripgrep
    shotcut
    tenacity
    unzip
    vesktop
    warehouse
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
      # Monitor padrão e resolução automática
      monitor = [
	"DP-1, 1920x1080@144, 0x0, 1"
	"eDP-1, 1920x1080@165, 0x1080, 1"
      ];

      input = {
	kb_layout = "br";
	kb_variant = "abnt2";
      };

      # Atalhos principais (Modificador = Tecla Super / Windows)
      "$mod" = "SUPER";

      bind = [
        "$mod, T, exec, ghostty" # Abre o terminal Ghostty
        "$mod, W, killactive," # Fecha a janela ativa
        "$mod, L, exit," # Sai do Hyprland
        "$mod, E, exec, nautilus" # Gerenciador de arquivos
        "$mod, V, togglefloating," # Alterna janela flutuante
        "$mod, R, exec, rofi -show drun" # Lançador de apps (Rofi)

	#move windows.
	"$mod SHIFT, h, movewindow, l"
	"$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        # Foco entre janelas com as setas ou HJKL
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"
      ];

      # Configurações visuais e bordas limpas
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

      exec-once = ["waybar" "awww-daemon"];
    };
  };

  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        height = 36;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "network"
          "battery"
        ];

        clock = {
          format = "{:%H:%M:%ss}";
          tooltip = false;
        };

        battery = {
          format = "{capacity}% 󰁹";
        };

        pulseaudio = {
          format = "{volume}% 󰕾";
        };
      }
    ];

    style = ../waybar/style.css;
  };

}
