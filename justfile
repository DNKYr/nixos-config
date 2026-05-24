set shell := ["nu", "-c"]


# List all the just commands
default:
    @just --list

# Update all the flake inputs
[group('update')]
up:
    nix flake update

# Check the package
[group('build')]
check:
    nixos-rebuild build --flake .#aether --no-link
    nixos-rebuild build --flake .#ikuyo --no-link
    
# Rebuild aether
[group('build')]
aether: 
    sudo nixos-rebuild switch --flake .#aether

# Rebuild ikuyo
[group('build')]
ikuyo:
    nixos-rebuild switch --flake .#ikuyo --target-host ikuyo --sudo --ask-sudo-password
