{ ... }:
{
  imports = [ ../../default.nix ];

  # Add personal MacBook specific configuration here
  homebrew = {
    casks = [
      "discord"
      "cursor"
      "orbstack"
    ];
    brews = [
    ];
    masApps = {
      WireGuard = 1451685025;
    };
  };
}
