# Don't forget to run
# sudo pdbedit -a -u adam
# if you haven't already!!

{ config, pkgs, ... }:ƒ

let 
  port = 8123;
in 
{
  # Enable Samba service
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = NixOS Samba Server
      security = user
      map to guest = never
      guest account = nobody
      
      # This allows Samba to use its own user database
      passdb backend = tdbsam
    '';
    shares = {
      adam = {
        path = "/data/Adam";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        # Force all operations to be as root
        "force user" = "root";
        "valid users" = "adam";
      };
    };
  };

  # Open required ports in firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 139 445 ];
    allowedUDPPorts = [ 137 138 ];
  };

  # Create a service to add the Samba user
  systemd.services.setup-samba-users = {
    description = "Set up Samba users";
    wantedBy = [ "multi-user.target" ];
    requires = [ "samba.service" ];
    after = [ "samba.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Check if user already exists using full path
      if ! "${pkgs.samba}/bin/pdbedit" -L | grep -q "^adam:"; then
        # Create user with password. The password is piped to stdin
        echo -e "password\npassword" | "${pkgs.samba}/bin/pdbedit" -a -u adam -t
      fi
    '';
  };
}
