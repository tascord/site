# Nix Flake Setup

This repository includes a Nix flake for easy deployment on NixOS servers.

## Quick Start

1. **Validate setup** (optional):
   ```bash
   ./check-nix-setup.sh
   ```

2. **Calculate npm dependencies hash**:
   ```bash
   ./update-nix-hash.sh
   ```
   Or manually:
   ```bash
   nix run nixpkgs#prefetch-npm-deps package-lock.json
   ```
   Then update `npmDepsHash` in `flake.nix` with the output.

3. **Build and run**:
   ```bash
   nix build
   nix run
   ```

## Initial Setup

On first use, you need to calculate the npm dependencies hash:

```bash
# Try to build - it will fail but show you the correct hash
nix build .#site

# Look for a line like:
#   got:    sha256-...
# Copy that hash and update flake.nix, replacing the placeholder hash
```

Alternatively, you can use:

```bash
nix run nixpkgs#prefetch-npm-deps package-lock.json
```

Update the `npmDepsHash` value in `flake.nix` with the correct hash.

## Building

Once the hash is set correctly:

```bash
# Build the site
nix build

# The output will be in ./result/
```

## Development

Enter a development shell with Node.js and npm:

```bash
nix develop
```

Or if you use direnv:

```bash
direnv allow
```

## Running

Run the built site:

```bash
# Using nix run
nix run

# Or directly
node ./result/server/index.mjs
```

## NixOS Deployment

To deploy on a NixOS server, add this to your NixOS configuration:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flora-site.url = "github:tascord/site";
  };

  outputs = { self, nixpkgs, flora-site }: {
    nixosConfigurations.myserver = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        flora-site.nixosModules.default
        {
          services.flora-site = {
            enable = true;
            port = 3000;
            host = "0.0.0.0";
          };
        }
      ];
    };
  };
}
```

Then rebuild your system:

```bash
sudo nixos-rebuild switch --flake .#myserver
```

## Configuration Options

The NixOS module supports the following options:

- `services.flora-site.enable` - Enable the service (default: false)
- `services.flora-site.port` - Port to listen on (default: 3000)
- `services.flora-site.host` - Host to bind to (default: "0.0.0.0")
- `services.flora-site.package` - The site package to use (default: auto-detected)
- `services.flora-site.openmodKey` - OpenMod API key (default: value from nuxt.config.ts)
- `services.flora-site.guestbookModSecret` - Guestbook moderation secret (default: value from nuxt.config.ts)

**Security Note**: For production deployments, override the default secrets:

```nix
services.flora-site = {
  enable = true;
  openmodKey = "your-secret-key-here";
  guestbookModSecret = "your-secret-here";
};
```

Or use `agenix` or `sops-nix` for proper secret management.

## Nginx Reverse Proxy Example

```nix
services.nginx = {
  enable = true;
  virtualHosts."yourdomain.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      proxyWebsockets = true;
    };
  };
};
```
