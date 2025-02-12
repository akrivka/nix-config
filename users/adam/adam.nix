{ pkgs, config, lib, ...}:

{
  # Add user 'adam'
    users.users.adam = {
      isNormalUser = true;
      description = "me (Adam Krivka)";
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOKOdtuCE1P89yiANjzQHFPcaw22+fPci9TcA43D8OtQ krivka.adam@gmail.com"
      ];
      packages = with pkgs; [
      ];
    };
}