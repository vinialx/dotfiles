{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  boot = {
    plymouth = {
      enable = true;
      theme = "mac-style";
      themePackages = [ pkgs.mac-style-plymouth ];
    };
    consoleLogLevel = 3;
    initrd.verbose = false;
    initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
      "nvidia-drm.modeset=1"
    ];
  };
  boot.loader = {
    timeout = null;
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
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
  services.xserver.enable = true;
  # Wayland + GDM
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
  services.desktopManager.gnome.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true;        # importante em notebook
    powerManagement.finegrained = false;
    modesetting.enable = true;
    open = false;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  # Variáveis que corrigem o lag no GNOME Wayland com NVIDIA
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.printing.enable = true;
  nixpkgs.config.allowUnfree = true;
  services.flatpak.enable = true;
  programs.git.enable = true;
  virtualisation.docker.enable = true;
  users.defaultUserShell = pkgs.zsh;
 programs.zsh = {
  enable = true;
  ohMyZsh = {
    enable = true;
    plugins = [ "git" "docker" "docker-compose" "fzf" "colored-man-pages" "command-not-found" ];
    theme = "powerlevel10k/powerlevel10k";
    customPkgs = [ pkgs.zsh-powerlevel10k ];
  };
};

  services.tailscale.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 5d";
  };
  users.users.vinicius = {
    isNormalUser = true;
    description = "vinicius";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    wget
    brave
    anydesk
    remmina
    vesktop
    tmux
    neovim
    ghostty
    tailscale
    warehouse
    nil
    ente-auth
    bitwarden-desktop
    fd
    ripgrep
    alsa-utils
    opencode
    direnv
    docker
    docker-compose
    dbeaver-bin
    gnome-tweaks
    xdg-desktop-portal
    xdg-desktop-portal-gnome
    unzip
    imagemagick
    zoxide
    fzf
    zsh-powerlevel10k
    go
    python314
    gcc
    obsidian
    bat
    obs-studio
  ];
  
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    glib
  ];
  system.stateVersion = "25.11";
}
