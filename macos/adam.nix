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
    '';
    functions = {
      gdm = ''
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
        '';
      gcb = ''
        # If no arguments, use fzf to select branch
        if test (count $argv) -eq 0
            # Check if we're in a git repository first
            if not git rev-parse --git-dir >/dev/null 2>&1
                echo "Error: Not in a git repository"
                return 1
            end
            
            # Get list of all branches (local + remote), normalize and deduplicate
            set -l selected_branch (git branch -a --format='%(refname:short)' | \
                sed 's|^remotes/origin/||' | \
                grep -v '^HEAD$' | \
                sort -u | \
                fzf --prompt='Select branch: ' --height=40% --reverse)
            
            # If no selection made (ESC pressed), exit
            if test -z "$selected_branch"
                return 0
            end
            
            set argv[1] $selected_branch
        else if test (count $argv) -ne 1
            echo "Usage: gcb [branch-name]"
            echo "  If branch-name is omitted, opens interactive branch selector"
            return 1
        end

        set -l branch $argv[1]

        # Check if we're in a git repository
        if not git rev-parse --git-dir >/dev/null 2>&1
            echo "Error: Not in a git repository"
            return 1
        end

        # Get the common git directory (works for both bare repos and worktrees)
        set -l git_common_dir (git rev-parse --git-common-dir 2>/dev/null)

        # Resolve to absolute path and get parent (the repo root where worktrees live)
        set -l repo_root (dirname (realpath "$git_common_dir"))

        # Worktree path
        set -l worktree_path "$repo_root/$branch"

        # If worktree already exists, just cd to it
        if test -d "$worktree_path"
            echo "Worktree exists at $worktree_path"
            cd "$worktree_path"
            return 0
        end

        # Create parent directories if branch has slashes
        set -l parent_dir (dirname "$worktree_path")
        mkdir -p "$parent_dir"

        # Check if branch exists (locally or remote)
        set -l branch_exists no
        if git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null
            set branch_exists yes
        else if git show-ref --verify --quiet "refs/remotes/origin/$branch" 2>/dev/null
            set branch_exists yes
        end

        # Create worktree
        if test "$branch_exists" = "yes"
            git worktree add "$worktree_path" "$branch"
        else
            # Create new branch from current HEAD
            git worktree add -b "$branch" "$worktree_path"
        end

        if test $status -eq 0
            cd "$worktree_path"
        else
            return 1
        end
        '';  
    };
  };
}
