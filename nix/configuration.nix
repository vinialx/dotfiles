{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "25.11";

  hardware = {
    enableAllFirmware = true;

    bluetooth.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      modesetting.enable = true;
      open = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  boot = {
    plymouth = {
      enable = false;
      theme = "mac-style";
      themePackages = [ pkgs.mac-style-plymouth ];
    };

    #secure boot.
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    consoleLogLevel = 3;

    initrd = {
      verbose = false;

      availableKernelModules = [ "vmd" ];

      kernelModules = [
        "vmd"
      ];
    };

    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
      "snd_intel_dspcfg.dsp_driver=3"
    ];
    kernelModules = [ "acer-wmi" ];
    loader = {
      timeout = 5;
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      interfaces."wlp0s20f3".allowedTCPPorts = [
        3500
        4000
      ];
    };
  };

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services = {
    gvfs.enable = true;
    upower.enable = true;
    flatpak.enable = true;
    printing.enable = true;
    tailscale.enable = true;
    gnome.gnome-keyring.enable = true;
    power-profiles-daemon.enable = true;

    xserver = {
      enable = true;
      videoDrivers = [
        "modesetting"
        "nvidia"
      ];
      xkb = {
        layout = "br";
      };
    };
    displayManager = {
      gdm.enable = true;
      defaultSession = "hyprland";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 5d";
  };

  programs = {
    git.enable = true;
    zsh.enable = true;

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        glib
      ];
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;

    users.vinicius = {
      isNormalUser = true;
      description = "vinicius";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    sbctl
    alsa-utils
    docker-compose
  ];

  xdg.portal = {
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
