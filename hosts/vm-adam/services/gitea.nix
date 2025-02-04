{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.gitea = {
    enable = true;
    settings.server.HTTP_PORT = 3000;
  };
}
