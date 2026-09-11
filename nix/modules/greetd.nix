{ ... }:

let
  username = "vinicius";
  avatar = ../../assets/pfps/pfp.jpg;
in
{
  programs.noctalia-greeter = {
    enable = true;

    passwordless-sync-users = [
      username
    ];

    settings = {
      user = {
        default = username;
      };

      session = {
        default = "Hyprland";
      };

      appearance = {
        scheme = "Synced";
        password_style = "default";
        hide_logo = true;
        scheme_selector_position = "hidden";
        power_buttons_position = "bottom-right";
      };

      keyboard = {
        layout = "br";
      };

      cursor = {
        size = 24;
      };

      idle = {
        timeout = 300;
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/AccountsService/users 0755 root root -"
    "f+ /var/lib/AccountsService/users/${username} 0600 root root - [User]\\nIcon=${avatar}\\n"
  ];
}
