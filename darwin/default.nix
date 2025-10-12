{ pkgs, ... }:

{
  nix.enable = false;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    neovim
    git
    python3
    eza
    bat
    dust
    nixd
    nil
    nixfmt
  ];

  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Enable alternative shell support in nix-darwin.
  programs.fish.enable = true;

  # Enable flakes
  nix.settings.experimental-features = "nix-command flakes";

  # Enable Homebrew (all macOS hosts can extend this in their own configs)
  homebrew = {
    enable = true;
    brews = [
      "imagemagick"
      "git"
      "node"
      "pnpm"
      "yarn"
      "python@3.13"
      "uv"
      "gh"
      "ripgrep"
    ];
    casks = [
      "betterdisplay"
      "firefox"
      "ghostty"
      "marta"
      "spotify"
      "raycast"
      "visual-studio-code"
      "bitwarden"
      "karabiner-elements"
      "notion"
      "slack"
      # i3-like tiling window manager for macOS
      # "nikitabobko/tap/aerospace"
    ];
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    global.brewfile = true;
    taps = [ "nikitabobko/tap" ];
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # Define the existing macOS user so that Home-Manager can infer the correct
  # home directory path (required for the `home.homeDirectory` option).
  users.users.adam.home = "/Users/adam";
  # Make Fish the default login shell for the user.
  users.users.adam.shell = pkgs.fish;
  users.users.adam.uid = 501;
  users.knownUsers = [ "adam" ];

  # Set the primary user for the system
  system.primaryUser = "adam";

  # TO PLAY WITH LATER
  system.defaults.NSGlobalDomain = {
    # ACTUALLY IMPORTANT STUFF
    "com.apple.swipescrolldirection" = false;
    "com.apple.trackpad.scaling" = 1.3;
    InitialKeyRepeat = 15;
    KeyRepeat = 2;

    AppleICUForce24HourTime = true;
    AppleInterfaceStyleSwitchesAutomatically = true;
    AppleMeasurementUnits = "Centimeters";
    AppleMetricUnits = 1;
    AppleShowScrollBars = "Automatic";
    AppleTemperatureUnit = "Celsius";
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = true;
    _HIHideMenuBar = false;
  };

  # Dock and Mission Control
  system.defaults.dock = {
    autohide = true;
    expose-group-apps = false;
    mru-spaces = false;
    tilesize = 128;
    # Disable all hot corners
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
  };

  # Login and lock screen
  system.defaults.loginwindow = {
    GuestEnabled = false;
    DisableConsoleAccess = true;
  };

  # Spaces
  system.defaults.spaces.spans-displays = false;

  # Trackpad
  system.defaults.trackpad = {
    Clicking = false;
    TrackpadRightClick = true;
  };

  # Finder
  system.defaults.finder = {
    FXEnableExtensionChangeWarning = true;
    NewWindowTarget = "Home";
    ShowPathbar = true;
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      alt - z : open -a "Zed"
      alt - s : open -a "Spotify"
      alt - f : open -a "Firefox"
      alt - c : open -a "Cursor"
      alt - g : open -a "Signal"
      alt - a : open -a "Slack"
      alt - m : open -a "Messenger"
      alt - d : open -a "Discord"
      alt - w : open -a "WhatsApp"
      alt - e : open -a "Marta"
      alt - return : open -a "Ghostty"'';
  };
}
