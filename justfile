# Justfile

set positional-arguments := true

# Default recipe (runs when just is called without arguments)
default:
    @just --list

# Run all tasks
all: update-flake build collect-garbage _archive-flake update-nixpkgs-cache-index brew-bundle
    @echo "Update completed successfully"

# Nix switch system and home
build: build-system build-home

# Home manager switch
build-home:
    just _build-env "home-manager"

# Darwin system switch
build-system:
    just _build-env "sudo darwin-rebuild"

# Update and clean up bundle
brew-bundle:
    brew bundle --cleanup

# Collect garbage
collect-garbage:
    nix-collect-garbage -d
    sudo nix-collect-garbage -d

# Download Nixpkgs cache index
update-nixpkgs-cache-index:
    #!/usr/bin/env bash
    location=~/.cache/nix-index
    filename="index-$(uname -m | sed 's/^arm64$/aarch64/')-$(uname | tr '[:upper:]' '[:lower:]')"
    mkdir -p "$location"
    wget -P "$location" -q -N "https://github.com/nix-community/nix-index-database/releases/latest/download/$filename"
    ln -f "$location/$filename" "$location/files"

# Update flake and commit changes
update-flake:
    nix flake update || just _error "Failed to update flake"
    git commit -m 'update flake.lock' flake.lock
    git push || echo "Failed to push flake.lock update"

# Private recipes

# Parameterized build task
_build-env command:
    #!/usr/bin/env bash
    counter=0
    keepBuilding() {
        (( counter++ ))
        {{ command }} --flake . switch || keepBuilding
    }
    keepBuilding
    echo "built in ${counter} iterations"

# Archive flake
_archive-flake:
    nix flake archive

# Error handling function
_error:
    #!/usr/bin/env bash
    echo "Error: $1" >&2
    exit 1
