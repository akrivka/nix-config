# My NixOS configs

## TODOs

[] Set up home-manager
[] Switch `nixos-vscode-server` to Flakes (`fetchTarball` in `common/default.nix` triggers an issue if not building with `--impure`)
[] Move anki-sync-server to /data/Adam
    - current problem is that the anki-sync-server package 
    runs under a dynamic user, which doesn't have permission to write to that folder
        - the solutions are either to symlink/hardlink from /var/lib/anki-sync-server... but then this symlink will need to be handled differently from the Photos symlink
        - make a fork to the anki-sync-server module
            - could also submit a pull request

## Steps to create a new NixOS VM on Ryloth Proxmox from scrath

1. Create CT with the nixos template. DON'T FORGET TO INCLUDE SSH KEY! (use whatever password)
2. SSH into root at the new machine and copy the Ryloth SSH private key to ~/.ssh/id_ed25519
    - don't forget to `chmod 600 id_ed25519`
3. run
    `nix-channel --update`
    `nix-shell -p gitMinimal`
    `git clone git@github.com:akrivka/nix-config.git`

## Steps to set up a NixOS VM after having done the previous steps or used the template

1. configure network from Proxmox
2. run this to enable VSCode server
    `systemctl --user enable auto-fix-vscode-server.service`

## Steps to set up a new Macbook

1. Install nix using the graphical Determinate systems installer https://docs.determinate.systems/determinate-nix/
2. Install `nix-darwin` using something like this:

```
sudo nix run github:lnl7/nix-darwin#darwin-rebuild -- switch \
  --flake /Users/adam/personal/nix-config#aisle-macbook
  ```

  