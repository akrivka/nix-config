# run
# sudo smbpasswd -a adamSMB

{ config, pkgs, ... }:

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
    '';
    shares = {
      Adam = {
        path = "/data/Adam";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "adamSMB";
        "valid users" = "adamSMB";
      };
    };
  };

  # Create the system user
  users.users.adamSMB = {
    isSystemUser = true;
    group = "adamSMB";
    createHome = false;
  };

  # Create corresponding group
  users.groups.adamSMB = { };

  # Open required ports in firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      139
      445
    ];
    allowedUDPPorts = [
      137
      138
    ];
  };

  # Create the directory with proper permissions
  system.activationScripts = {
    createSambaDir = {
      text = ''
        chown adamSMB:adamSMB /data/Adam
        chmod 755 /data/Adam
      '';
      deps = [ ];
    };
  };
}
