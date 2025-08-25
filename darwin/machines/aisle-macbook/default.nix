{ config, pkgs, ... }:
{
  imports = [ ../../default.nix ];

  environment.variables = {
    AWS_PROFILE = "aisle-playground";
    AWS_REGION = "eu-west-1";
  };

  # Install AISLE specific packages via homebrew
  homebrew = {
    casks = [
      "cursor"
      "orbstack"
      "notion"
      "slack"
      "gcloud-cli"
    ];
    brews = [
      "rustup"
      "dbmate"
      "awscli"
      "postgresql@17"
    ];
  };
}
