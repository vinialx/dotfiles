{ pkgs, ... }:

{
  services.displayManager.noctalia-greeter = {
    enable = true;

    settings = {
      keyboard.layout = "br";

      cursor = {
        size = 24;
      };
    };
  };
}
