# My NixOS configs

## TODOs

[] Set up home-manager
[] Switch `nixos-vscode-server` to Flakes (`fetchTarball` in `hosts/common/default.nix` triggers an issue if not building with `--impure`)

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