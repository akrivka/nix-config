{ config, pkgs, ... }:
{
  home.username = "adam";
  home.homeDirectory = "/Users/adam";

  # Keep this in sync with your current Home-Manager version.
  home.stateVersion = "23.11";

  # Expose Aerospace config into ~/.config/aerospace.
  xdg.configFile."aerospace/aerospace.toml".source = ./configs/aerospace/aerospace.toml;

  # Expose Marta config to Library/Application Support.
  home.file."Library/Application Support/org.yanex.marta/conf.marco".source = ./configs/marta-manual/conf.marco;

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
    shellInit = ''
      # Ensure ~/.local/bin is on PATH (append to avoid shadowing Homebrew)
      if test -d "$HOME/.local/bin"
        fish_add_path -a -g "$HOME/.local/bin"
      end
      fish_add_path -a -g /opt/homebrew/opt/libpq/bin
    '';
    # Initialize Homebrew environment variables for both login and interactive shells.
    loginShellInit = ''
      if test -x /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
      end
      
      # Set SSH_AUTH_SOCK for Bitwarden SSH agent
      set -gx SSH_AUTH_SOCK /Users/adam/.bitwarden-ssh-agent.sock
    '';

    interactiveShellInit = ''
      # Initialize Homebrew environment variables.
      if test -x /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
      end

      # Set SSH_AUTH_SOCK for Bitwarden SSH agent
      set -gx SSH_AUTH_SOCK /Users/adam/.bitwarden-ssh-agent.sock

      # Initialize the Starship prompt.
      starship init fish | source
    '';
  };
} 