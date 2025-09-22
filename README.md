# nix-darwin


Forked from https://github.com/quidome/nix-config to reduce complexity.

## Install nix on Macos

First step when starting from scratch is to install Nix.

```sh
  sh <(curl -L https://nixos.org/nix/install) --daemon
```

Once this is completed, you should be able to execute:

```sh
  nix-shell -p nix-info --run "nix-info -m"
```

If this provides nix-info output, nix is working.

### First flake install

Once nix is working, we need to perform an initial install. This initial install will provide darwin-nix and more.

```sh
  nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .
```

After this is completed, we have a fully installed darwin-nix system, based on flakes.

## Updating (outdated)

### Update flake inputs

```sh
nix flake update
```

### Update system

```sh
darwin-nix --flake . switch
```
