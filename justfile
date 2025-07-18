default:
  just --list

rebuild:
  nixos-rebuild switch --fast --impure --flake .

deploy machine ip='':
  #!/usr/bin/env sh
  if [ {{machine}} = "darwin" ]; then
    darwin-rebuild switch --flake .
  elif [ -z "{{ip}}" ]; then
    sudo nixos-rebuild switch --fast --impure --flake ".#{{machine}}"
  else
    nixos-rebuild switch --fast --flake ".#{{machine}}" --use-remote-sudo --target-host "eh8@{{ip}}" --build-host "eh8@{{ip}}"
  fi

send destination:
  #!/usr/bin/env sh
  tar --exclude='./.*' --exclude='.git' --exclude='.gitignore' -czf archive.tar.gz .
  scp archive.tar.gz {{destination}}:~/nix-config/archive.tar.gz
  ssh {{destination}} 'mkdir -p ~/nix-config && tar -xzf ~/nix-config/archive.tar.gz -C ~/nix-config && rm ~/nix-config/archive.tar.gz'
  rm archive.tar.gz

update:
  nix flake update

lint:
  statix check .

gc:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && sudo nix store gc

repair:
  sudo nix-store --verify --check-contents --repair