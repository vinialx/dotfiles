{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/dam-fc.nix

    inputs.noctalia-greeter.nixosModules.default
    ./modules/greetd.nix
  ];

  system.stateVersion = "25.11";

  hardware = {
    enableAllFirmware = true;

    bluetooth.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    i2c.enable = true;

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
      enable = true;
      theme = "mac-style";
      themePackages = [ pkgs.mac-style-plymouth ];
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
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
      "snd_intel_dspcfg.dsp_driver=3"
    ];

    kernelModules = [ "acer-wmi" ];

    extraModprobeConfig = ''
      options acer_wmi predator_v4=1
    '';

    loader = {
      timeout = 5;

      systemd-boot.enable = false;

      efi.canTouchEfiVariables = true;

      limine = {
        enable = true;

        efiSupport = true;

        maxGenerations = 10;

        secureBoot = {
          enable = true;
          autoGenerateKeys = false;
          autoEnrollKeys.enable = false;
        };

        extraEntries = ''
          /Windows
            protocol: efi
            path: guid(d1dae694-4d72-44a1-9cd2-05d1d35bfa22):/EFI/Microsoft/Boot/bootmgfw.efi
        '';

        style = {
          graphicalTerminal = {
            background = "00070709";
            foreground = "d4d4d8";

            brightBackground = "18181b";
            brightForeground = "fafafa";

            palette = "18181b;ef4444;22c55e;eab308;71717a;a855f7;14b8a6;a1a1aa";

            brightPalette = "27272a;f87171;4ade80;facc15;a1a1aa;c084fc;2dd4bf;e4e4e7";

            margin = 0;
            marginGradient = 0;
          };

          interface = {
            branding = "";
            helpHidden = true;

            brandingColor = "d4d4d8";
            helpColor = "71717a";
            helpColorBright = "a1a1aa";
          };
        };
      };
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [
        3500
        4000
        8000
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
    gnome.localsearch.enable = true;
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
      gdm.enable = false;
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

    wireplumber.extraConfig."51-disable-hdmi-audio" = {
      "monitor.alsa.rules" = [
        # Desativa completamente o áudio HDMI/DP da NVIDIA
        {
          matches = [
            {
              "device.name" = "alsa_card.pci-0000_01_00.1";
            }
          ];

          actions = {
            update-props = {
              "device.disabled" = true;
            };
          };
        }

        # Desativa HDMI/DisplayPort 1 da Intel
        {
          matches = [
            {
              "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI1__sink";
            }
          ];

          actions = {
            update-props = {
              "node.disabled" = true;
            };
          };
        }

        # Desativa HDMI/DisplayPort 2 da Intel
        {
          matches = [
            {
              "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI2__sink";
            }
          ];

          actions = {
            update-props = {
              "node.disabled" = true;
            };
          };
        }

        # Desativa HDMI/DisplayPort 3 da Intel
        {
          matches = [
            {
              "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI3__sink";
            }
          ];

          actions = {
            update-props = {
              "node.disabled" = true;
            };
          };
        }
      ];
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

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
    virt-manager.enable = true;

    hyprland = {
      enable = true;
      withUWSM = true;
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
        "kvm"
        "libvirtd"
        "i2c"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    sbctl
    ddcutil
    i2c-tools
    alsa-utils
    docker-compose
  ];

  xdg.portal = {
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
