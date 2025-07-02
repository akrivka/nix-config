{ config, pkgs, ... }:
{
  home.username = "adam";
  home.homeDirectory = "/Users/adam";

  # Keep this in sync with your current Home-Manager version.
  home.stateVersion = "23.11";

  # Expose Karabiner config from repository into ~/.config/karabiner.
  xdg.configFile."karabiner/karabiner.json".source = ../../hosts/macos/configs/karabiner/karabiner.json;

  # Expose Aerospace config into ~/.config/aerospace.
  xdg.configFile."aerospace/aerospace.toml".source = ../../hosts/macos/configs/aerospace/aerospace.toml;

  # Optionally, include additional user packages.
  home.packages = [ ];

  # Enable the Starship prompt with Fish integration.
  programs.starship = {
    enable = true;
    # `enableFishIntegration` might change across versions; ensuring prompt is
    # activated manually via Fish init instead.
    enableFishIntegration = true;
    settings = {
      # Don't insert a blank line between prompts.
      add_newline = false;

      # Example prompt formatting.
      format = "$directory$git_branch$git_state$git_status$cmd_duration$line_break$character";

      # Customize the prompt symbols.
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };

  # Make sure Fish is configured for the user and starship is initialized.
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza";
      cat = "bat";
      du = "dust";
    };
    # Initialize Homebrew environment variables for both login and interactive shells.
    loginShellInit = ''
      if test -x /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
      end
    '';

    interactiveShellInit = ''
      # Initialize Homebrew environment variables.
      if test -x /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
      end

      # Initialize the Starship prompt.
      starship init fish | source
    '';
  };
} 