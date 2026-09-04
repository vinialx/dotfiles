{
  config,
  pkgs,
  inputs,
  ...
}:
let
  kernel = config.boot.kernelPackages.kernel;

  python = pkgs.python3.withPackages (
    ps: with ps; [
      psutil
    ]
  );

  dam-fc-driver = pkgs.stdenv.mkDerivation {
    pname = "dam-fc-driver";
    version = "1.21";

    src = inputs.dam-fc;

    sourceRoot = "source/DAM-FC/Daemon/NitroDrivers";

    hardeningDisable = [
      "pic"
      "format"
    ];

    nativeBuildInputs = kernel.moduleBuildDependencies;

    postPatch = ''
      substituteInPlace acer_nitro_gaming_driver2.h \
        --replace-fail \
          '#define DEFAULT_FAN_SPEED 512' \
          '#define DEFAULT_FAN_SPEED 1024'

      substituteInPlace acer_nitro_gaming_driver2.c \
        --replace-fail \
          'add_uevent_var(env, "DEVMODE=%#o", 0666);' \
          'add_uevent_var(env, "DEVMODE=%#o", 0600);'

      substituteInPlace acer_nitro_gaming_driver2.c \
        --replace-fail \
          'dy_kbbacklight_set(1, 5, 100, 1, 255, 0, 0);' \
          '/* keyboard backlight left untouched on module load */'
    '';

    buildPhase = ''
      runHook preBuild

      make \
        -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
        M=$PWD \
        modules

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra

      cp acer_nitro_gaming_driver2.ko \
        $out/lib/modules/${kernel.modDirVersion}/extra/

      runHook postInstall
    '';
  };

  dam-fc-daemon = pkgs.stdenvNoCC.mkDerivation {
    pname = "dam-fc-daemon";
    version = "0.8.6";

    src = inputs.dam-fc;

    patches = [
      ./patches/prime-offload.patch
      ./patches/nixos-daemon.patch
    ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/dam-fc

      cp DAM-FC/Daemon/DAMFC_daemon.py \
        $out/share/dam-fc/

      cp DAM-FC/Daemon/HardwareStatus.py \
        $out/share/dam-fc/

      cp DAM-FC/Daemon/DriverManager.py \
        $out/share/dam-fc/

      runHook postInstall
    '';
  };

  dam-fc-config = pkgs.writeText "dam-fc-config.json" (
    builtins.toJSON {
      min_speed = 1024;
      max_speed = 2560;
      dynamic_mode = true;

      temp_steps = [
        {
          temperature = 50;
          speed = 1024;
        }
        {
          temperature = 70;
          speed = 1536;
        }
        {
          temperature = 80;
          speed = 2048;
        }
        {
          temperature = 90;
          speed = 2560;
        }
      ];
    }
  );
in
{
  boot.extraModulePackages = [
    dam-fc-driver
  ];

  boot.kernelModules = [
    "acer_nitro_gaming_driver2"
  ];

  systemd.services.dam-fc = {
    description = "DAM Fan Controls";

    wantedBy = [
      "multi-user.target"
    ];

    after = [
      "systemd-modules-load.service"
    ];

    path = [
      config.hardware.nvidia.package
      pkgs.coreutils
      pkgs.kmod
    ];

    serviceConfig = {
      Type = "simple";

      StateDirectory = "acer_fan_control";
      LogsDirectory = "Div_Acer_Manager_Logs";

      ExecStartPre = [
        "${pkgs.coreutils}/bin/test -c /dev/fan1"
        "${pkgs.coreutils}/bin/test -c /dev/fan2"
        "${pkgs.coreutils}/bin/install -Dm600 ${dam-fc-config} /var/lib/acer_fan_control/config.json"
      ];

      ExecStart = "${python}/bin/python ${dam-fc-daemon}/share/dam-fc/DAMFC_daemon.py";

      Restart = "on-failure";
      RestartSec = "3s";

      WorkingDirectory = "${dam-fc-daemon}/share/dam-fc";

      UMask = "0077";
    };
  };
}
