{ ... }:
{
  home.username = "adam";
  home.homeDirectory = "/Users/adam";

  # Keep this in sync with your current Home-Manager version.
  home.stateVersion = "23.11";

  # Expose Aerospace config into ~/.config/aerospace.
  xdg.configFile."aerospace/aerospace.toml".source = ./configs/aerospace/aerospace.toml;

  # Expose Marta config to Library/Application Support.
  home.file."Library/Application Support/org.yanex.marta/conf.marco".source =
    ./configs/marta-manual/conf.marco;

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

      # Git: delete merged branches
      function gdm
        # Fetch latest changes from the remote (optional, but keeps your branch list up-to-date)
        git fetch -p

        # Get a list of merged branches and delete them
        # Delete merged branches using a fish loop (no xargs dependency)
        set -l protected main master dev

        # Also protect the current branch
        set -l current (git rev-parse --abbrev-ref HEAD)
        if test -n "$current"
          set protected $protected $current
        end

        for b in (git for-each-ref --format='%(refname:short)' refs/heads --merged)
          if contains -- $b $protected
            continue
          end
          git branch -d -- $b
        end
      end
    '';
  };
}
