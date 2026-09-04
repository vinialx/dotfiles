{
  config,
  pkgs,
  inputs,
  ...
}:
let
  kernel = config.boot.kernelPackages.kernel;

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
      substituteInPlace acer_nitro_gaming_driver2.c \
        --replace-fail \
          'add_uevent_var(env, "DEVMODE=%#o", 0666);' \
          'add_uevent_var(env, "DEVMODE=%#o", 0600);'

      substituteInPlace acer_nitro_gaming_driver2.c \
        --replace-fail \
          'wmi_eval_int_method(METHOD_SET_FAN, concatenate(DEFAULT_FAN_SPEED, FAN_CPU));' \
          '/* fan speed left untouched on module load */'

      substituteInPlace acer_nitro_gaming_driver2.c \
        --replace-fail \
          'wmi_eval_int_method(METHOD_SET_FAN, concatenate(DEFAULT_FAN_SPEED, FAN_GPU));' \
          '/* fan speed left untouched on module load */'

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
in
{
  boot.extraModulePackages = [
    dam-fc-driver
  ];
}
