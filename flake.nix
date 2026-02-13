{
  description = "Flora's Nuxt.js site";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Build the Nuxt application
        site = pkgs.buildNpmPackage {
          pname = "flora-site";
          version = "0.1.0";
          
          src = ./.;
          
          # This hash needs to be calculated. Run:
          # nix build .#site 2>&1 | grep -oP 'got:\s+\K\S+' | head -1
          # Then replace this placeholder with the actual hash
          npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          
          # Native dependencies (better-sqlite3)
          nativeBuildInputs = with pkgs; [ 
            python3
            nodePackages.node-gyp
          ];
          
          buildInputs = with pkgs; [
            sqlite
          ];
          
          # Disable npm update check during build
          makeCacheWritable = true;
          
          # Install and build
          buildPhase = ''
            runHook preBuild
            npm run build
            runHook postBuild
          '';
          
          installPhase = ''
            runHook preInstall
            mkdir -p $out
            cp -r .output/* $out/
            runHook postInstall
          '';
          
          meta = with pkgs.lib; {
            description = "Flora's personal website built with Nuxt.js";
            license = licenses.mit;
          };
        };
        
      in
      {
        packages = {
          default = site;
          inherit site;
        };
        
        # Development shell with Node.js and dependencies
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_22
            nodePackages.npm
          ];
          
          shellHook = ''
            echo "Nuxt.js development environment"
            echo "Run 'npm install' to install dependencies"
            echo "Run 'npm run dev' to start development server"
          '';
        };
        
        # App for running the site
        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "run-site" ''
            ${pkgs.nodejs_22}/bin/node ${site}/server/index.mjs
          ''}";
        };
      }
    ) // {
      # NixOS module for easy deployment
      nixosModules.default = { config, lib, pkgs, ... }:
        with lib;
        let
          cfg = config.services.flora-site;
        in
        {
          options.services.flora-site = {
            enable = mkEnableOption "Flora's Nuxt.js site";
            
            port = mkOption {
              type = types.port;
              default = 3000;
              description = "Port to run the site on";
            };
            
            host = mkOption {
              type = types.str;
              default = "0.0.0.0";
              description = "Host to bind to";
            };
            
            package = mkOption {
              type = types.package;
              default = self.packages.${pkgs.system}.site;
              description = "The site package to use";
            };
            
            openmodKey = mkOption {
              type = types.str;
              default = "";
              description = ''
                OpenMod API key. If not set, falls back to the default in nuxt.config.ts.
                For production, provide your own key.
              '';
            };
            
            guestbookModSecret = mkOption {
              type = types.str;
              default = "";
              description = ''
                Guestbook moderation secret. If not set, falls back to the default in nuxt.config.ts.
                For production, provide your own secret.
              '';
            };
          };
          
          config = mkIf cfg.enable {
            systemd.services.flora-site = {
              description = "Flora's Nuxt.js site";
              wantedBy = [ "multi-user.target" ];
              after = [ "network.target" ];
              
              environment = {
                PORT = toString cfg.port;
                HOST = cfg.host;
                NODE_ENV = "production";
              } // lib.optionalAttrs (cfg.openmodKey != "") {
                # Override runtime config from nuxt.config.ts if provided
                NUXT_OPENMOD_KEY = cfg.openmodKey;
              } // lib.optionalAttrs (cfg.guestbookModSecret != "") {
                NUXT_GUESTBOOK_MOD_SECRET = cfg.guestbookModSecret;
              };
              
              serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.nodejs_22}/bin/node ${cfg.package}/server/index.mjs";
                Restart = "always";
                RestartSec = "10s";
                
                # Security hardening
                DynamicUser = true;
                PrivateTmp = true;
                ProtectSystem = "strict";
                ProtectHome = true;
                NoNewPrivileges = true;
                PrivateDevices = true;
                ProtectKernelTunables = true;
                ProtectKernelModules = true;
                ProtectControlGroups = true;
              };
            };
          };
        };
    };
}
