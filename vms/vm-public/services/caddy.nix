{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.caddy = {
    enable = true;

    virtualHosts."cmg.akrivka.com" = {
      extraConfig = ''
        root * /var/www/cmg.akrivka.com
        file_server
        
        handle /fotky/* {
          root * /var/www/cmg.akrivka.com
          file_server
        }
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # Create the hello world HTML page
  environment.etc."www-content/index.html" = {
    text = ''
      <!DOCTYPE html>
      <html lang="cs">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>CMG</title>
          <style>
              body {
                  font-family: Arial, sans-serif;
                  display: flex;
                  justify-content: center;
                  align-items: center;
                  height: 100vh;
                  margin: 0;
                  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                  color: white;
              }
              .container {
                  text-align: center;
                  padding: 2rem;
                  background: rgba(255, 255, 255, 0.1);
                  border-radius: 15px;
                  backdrop-filter: blur(10px);
              }
              h1 {
                  font-size: 3rem;
                  margin-bottom: 1rem;
              }
              a {
                  color: white;
                  text-decoration: none;
                  padding: 0.5rem 1rem;
                  background: rgba(255, 255, 255, 0.2);
                  border-radius: 5px;
                  display: inline-block;
                  margin-top: 1rem;
                  transition: background 0.3s;
              }
              a:hover {
                  background: rgba(255, 255, 255, 0.3);
              }
          </style>
      </head>
      <body>
          <div class="container">
              <a href="/fotky">Fotogalerie</a>
          </div>
      </body>
      </html>
    '';
    mode = "0644";
  };

  # Copy the HTML file to the web root on activation
  system.activationScripts.setup-web-content = {
    deps = [ "create-web-dirs" ];
    text = ''
      cp /etc/www-content/index.html /var/www/cmg.akrivka.com/index.html
      chown caddy:caddy /var/www/cmg.akrivka.com/index.html
    '';
  };
}