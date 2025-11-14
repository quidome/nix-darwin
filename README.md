# nix-darwin

Forked from https://github.com/quidome/nix-config to reduce complexity.

This setup is a bit more complex than a regular nixos setup with flakes
because of installation methods and such.

## Installation

There are a few steps that need to be taken before we can use `nix-darwin`
or `home-manager`.

### Install nix

First step when starting from scratch is to install Nix.

```sh
  sh <(curl -L https://nixos.org/nix/install) --daemon
```

Once this is completed, you should be able to execute:

```sh
  nix-shell -p nix-info --run "nix-info -m"
```

If this provides nix-info output, nix is working.

### Bootstrap nix-darwin

Once nix is working, we need to perform an initial install of nix-darwin and our flake.

```sh
  nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .
```

After this is completed, we have a fully installed darwin-nix system, based on flakes.

## Updating

To make managing the system easier, a justfile has been added to the root of this repository.
Just can be used to perform updates on the flake, the system or brew bundle.

To see all available tasks, run:

```sh
  just
```

The update everything and do a garbage collection run, use:

```sh
  just all
```

## Uninstall

### Uninstall nix-darwin

```sh
  sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller
```

### Uninstall nix

See https://nix.dev/manual/nix/2.26/installation/uninstall for instructions on how to remove nix from a MacOS system.
