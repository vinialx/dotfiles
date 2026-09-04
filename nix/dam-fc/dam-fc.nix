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

  dam-fc-daemon = pkgs.writeText "dam-fc-daemon.py" ''
    import glob
    import logging
    import os
    import signal
    import subprocess
    import sys
    import time


    FAN_CPU = "/dev/fan1"
    FAN_GPU = "/dev/fan2"

    NVIDIA_RUNTIME_STATUS = (
        "/sys/bus/pci/devices/0000:01:00.0/power/runtime_status"
    )

    NVIDIA_SMI = "${config.hardware.nvidia.package}/bin/nvidia-smi"

    CHECK_INTERVAL = 5
    HYSTERESIS = 3

    TEMP_STEPS = [
        (0, 1024),
        (70, 1536),
        (80, 2048),
        (90, 2560),
    ]

    running = True


    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        stream=sys.stdout,
    )


    def shutdown(signum, frame):
        global running

        logging.info("Stopping DAM Fan Controls")
        running = False


    signal.signal(signal.SIGTERM, shutdown)
    signal.signal(signal.SIGINT, shutdown)


    def find_hwmon(name):
        for hwmon in glob.glob("/sys/class/hwmon/hwmon*"):
            name_path = os.path.join(hwmon, "name")

            try:
                with open(name_path, "r") as f:
                    hwmon_name = f.read().strip()

                if hwmon_name == name:
                    return hwmon

            except (FileNotFoundError, PermissionError, OSError):
                continue

        return None


    def read_temperature(path):
        try:
            with open(path, "r") as f:
                value = int(f.read().strip())

            if value <= 0:
                return None

            return value / 1000.0

        except (FileNotFoundError, ValueError, PermissionError, OSError):
            return None


    def get_cpu_temp():
        acer = find_hwmon("acer")

        if acer is not None:
            temperature = read_temperature(
                os.path.join(acer, "temp1_input")
            )

            if temperature is not None:
                return temperature

        coretemp = find_hwmon("coretemp")

        if coretemp is not None:
            temperatures = []

            for path in glob.glob(
                os.path.join(coretemp, "temp*_input")
            ):
                temperature = read_temperature(path)

                if temperature is not None:
                    temperatures.append(temperature)

            if temperatures:
                return max(temperatures)

        return None


    def get_gpu_temp():
        try:
            with open(NVIDIA_RUNTIME_STATUS, "r") as f:
                runtime_status = f.read().strip()

            if runtime_status != "active":
                return None

        except (FileNotFoundError, PermissionError, OSError):
            return None

        try:
            result = subprocess.run(
                [
                    NVIDIA_SMI,
                    "--query-gpu=temperature.gpu",
                    "--format=csv,noheader,nounits",
                ],
                capture_output=True,
                text=True,
                timeout=2,
                check=True,
            )

            temperature = result.stdout.strip().splitlines()[0]

            return float(temperature)

        except (
            subprocess.SubprocessError,
            ValueError,
            IndexError,
            OSError,
        ):
            return None


    def set_fan_speed(speed):
        for fan in (FAN_CPU, FAN_GPU):
            with open(fan, "w") as f:
                f.write(f"{speed}\n")


    def desired_speed(temperature):
        speed = TEMP_STEPS[0][1]

        for threshold, step_speed in TEMP_STEPS:
            if temperature >= threshold:
                speed = step_speed

        return speed


    def threshold_for_speed(speed):
        for threshold, step_speed in TEMP_STEPS:
            if step_speed == speed:
                return threshold

        return 0


    def calculate_speed(temperature, current_speed):
        target = desired_speed(temperature)

        if current_speed is None:
            return target

        if target >= current_speed:
            return target

        current_threshold = threshold_for_speed(current_speed)

        if temperature < current_threshold - HYSTERESIS:
            return target

        return current_speed


    def main():
        global running

        logging.info("Starting DAM Fan Controls")
        logging.info("Dynamic mode enabled")
        logging.info(
            "Fan curve: <70=1024, 70=1536, 80=2048, 90=2560"
        )
        logging.info(
            "Hysteresis: %d°C",
            HYSTERESIS,
        )

        current_speed = None

        while running:
            cpu_temp = get_cpu_temp()
            gpu_temp = get_gpu_temp()

            temperatures = [
                temperature
                for temperature in (cpu_temp, gpu_temp)
                if temperature is not None
            ]

            if not temperatures:
                target_speed = 2560

                logging.warning(
                    "No valid temperature sensor available; "
                    "using fail-safe fan speed 2560"
                )

            else:
                max_temp = max(temperatures)

                target_speed = calculate_speed(
                    max_temp,
                    current_speed,
                )

                if target_speed != current_speed:
                    cpu_display = (
                        f"{cpu_temp:.0f}°C"
                        if cpu_temp is not None
                        else "N/A"
                    )

                    gpu_display = (
                        f"{gpu_temp:.0f}°C"
                        if gpu_temp is not None
                        else "suspended/N/A"
                    )

                    logging.info(
                        "CPU=%s GPU=%s max=%.0f°C -> fan=%d",
                        cpu_display,
                        gpu_display,
                        max_temp,
                        target_speed,
                    )

            if target_speed != current_speed:
                try:
                    set_fan_speed(target_speed)
                    current_speed = target_speed

                except OSError as error:
                    logging.error(
                        "Failed to set fan speed: %s",
                        error,
                    )

                    raise

            time.sleep(CHECK_INTERVAL)

        logging.info("DAM Fan Controls stopped")


    if __name__ == "__main__":
        main()
  '';
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

    serviceConfig = {
      Type = "simple";

      ExecStartPre = [
        "${pkgs.coreutils}/bin/test -c /dev/fan1"
        "${pkgs.coreutils}/bin/test -c /dev/fan2"
      ];

      ExecStart = "${pkgs.python3}/bin/python ${dam-fc-daemon}";

      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
