{ pkgs, config, lib, ...}:

{
    users.users.adam = {
      isNormalUser = true;
      description = "me (Adam Krivka)";
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOKOdtuCE1P89yiANjzQHFPcaw22+fPci9TcA43D8OtQ krivka.adam@gmail.com"
      ];
    };

    programs.home-manager.enable = true;

    home.username = "adam";
    home.homeDirectory = "/home/adam";

    programs.git = {
      enable = true;
      userName = "Adam Krivka";
      userEmail = "krivka.adam@gmail.com";
  };

    home.activation.createDirectories = lib.mkAfter ''
      mkdir -p $HOME/Adam/Drive
      mkdir -p $HOME/Adam/Photos
      mkdir -p $HOME/Adam/Services
    '';
}