# Example NixOS configuration for deploying Flora's site
#
# This is a complete example showing how to deploy the site on a NixOS server.
# Copy this to your NixOS configuration and adjust as needed.

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flora-site.url = "github:tascord/site";
    # For using a specific commit/branch:
    # flora-site.url = "github:tascord/site/main";
    # flora-site.url = "github:tascord/site/abc123";
  };

  outputs = { self, nixpkgs, flora-site }: {
    nixosConfigurations.myserver = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the flora-site NixOS module
        flora-site.nixosModules.default
        
        # Your server configuration
        ({ config, pkgs, ... }: {
          # Enable the site service
          services.flora-site = {
            enable = true;
            port = 3000;
            host = "127.0.0.1"; # Only listen on localhost
            
            # Override secrets (recommended for production)
            # openmodKey = "your-secret-key";
            # guestbookModSecret = "your-secret";
          };
          
          # Setup Nginx as a reverse proxy
          services.nginx = {
            enable = true;
            
            recommendedProxySettings = true;
            recommendedTlsSettings = true;
            recommendedOptimisation = true;
            recommendedGzipSettings = true;
            
            virtualHosts."yourdomain.com" = {
              # Enable ACME/Let's Encrypt
              enableACME = true;
              forceSSL = true;
              
              # Reverse proxy to the Nuxt app
              locations."/" = {
                proxyPass = "http://127.0.0.1:3000";
                proxyWebsockets = true;
                extraConfig = ''
                  proxy_set_header X-Real-IP $remote_addr;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_set_header X-Forwarded-Proto $scheme;
                  proxy_set_header Host $host;
                '';
              };
            };
          };
          
          # ACME/Let's Encrypt configuration
          security.acme = {
            acceptTerms = true;
            defaults.email = "your-email@example.com";
          };
          
          # Open firewall ports
          networking.firewall = {
            enable = true;
            allowedTCPPorts = [ 80 443 ];
          };
        })
      ];
    };
  };
}
