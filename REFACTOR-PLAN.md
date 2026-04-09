# Multi-Machine Refactoring Plan

## Problem

The repo is in a transitional state:
- `laptop/` is empty (moved away from it)
- `modules/hosts/aether/` uses a flake-parts style but isn't wired to `flake.nix`
- `flake.nix` still references the dead `./laptop/configuration.nix` path
- Home-manager is a single monolith — no way to give different packages to different machines
- `vm/` is a disconnected standalone config

## Target Structure

```
flake.nix                        (flake-parts entry point, import-tree ./modules)

modules/                         (import-tree discovers everything here recursively)
    hosts/
        aether/
            default.nix          (flake.nixosConfigurations.aether + home-manager wiring)
            configuration.nix    (flake.nixosModules.aether-config)
            hardware.nix         (flake.nixosModules.aether-hardware)
            hibernate.nix        (flake.nixosModules.aether-hibernate)
            home.nix             (plain home-manager file, imported by reference)
        vm/
            default.nix
            configuration.nix    (flake.nixosModules.vm-config)
            hardware-configuration.nix (flake.nixosModules.vm-hardware)
            home.nix
        <future-host>/
            ...
    features/
        niri.nix                 (flake.nixosModules.niri)
        gaming.nix               (flake.nixosModules.gaming)
        fonts.nix                (flake.nixosModules.fonts)
        fcitx5.nix               (flake.nixosModules.fcitx5)
        optimize.nix             (flake.nixosModules.optimize)

home/
    base.nix                     (shared: git, direnv, gh, fastfetch, common packages)
    modules/                     (feature modules — each host's home.nix imports what it needs)
        neovim.nix
        shell/
        noctalia.nix
        zen-browser.nix
        claude.nix
        gaming.nix

configs/                         (raw dotfiles — unchanged)
    niri/
    nvim/
```

## How It Works

### 1. `flake.nix` — Minimal entry point with import-tree

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:HerCLESEx/flake-parts";
    import-tree.url = "github:vic/import-tree";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    # ... other inputs unchanged
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      (inputs.import-tree ./modules);
}
```

`import-tree ./modules` recursively discovers every `.nix` file in `modules/` — hosts, features, all of it. No `default.nix` import lists needed anywhere. Drop a new file in and it's automatically picked up.

`home/` and `configs/` are NOT inside `modules/` because:
- `home.nix` files are plain home-manager configs, not flake-parts modules — they're `import`ed by reference from host `default.nix`, not auto-discovered
- `configs/` is raw dotfiles symlinked via `xdg.configFile`

### 2. Feature modules — Each exposes `flake.nixosModules.<name>`

```nix
# modules/features/niri.nix
{ ... }:
{
  flake.nixosModules.niri = { config, pkgs, ... }:
  {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    programs.niri.enable = true;
    programs.niri.package = pkgs.niri;
    services.displayManager.sessionPackages = [ pkgs.niri ];
  };
}
```

```nix
# modules/features/gaming.nix
{ ... }:
{
  flake.nixosModules.gaming = { ... }:
  {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      gamescopeSession.enable = true;
    };
    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
    hardware.graphics.enable32Bit = true;
  };
}
```

```nix
# modules/features/optimize.nix
{ ... }:
{
  flake.nixosModules.optimize = { ... }:
  {
    boot.loader.grub.configurationLimit = 10;
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    nix.settings.auto-optimise-store = true;
  };
}
```

### 3. Host-specific modules — Also expose `flake.nixosModules.*`

```nix
# modules/hosts/aether/configuration.nix
{ self, ... }:
{
  flake.nixosModules.aether-config = { pkgs, lib, ... }:
  {
    imports = [
      self.nixosModules.aether-hardware
      self.nixosModules.aether-hibernate
    ];

    networking.hostName = "aether";
    boot.loader.grub = { enable = true; device = "nodev"; efiSupport = true; useOSProber = true; };
    # ... rest of system config
    system.stateVersion = "25.11";
  };
}
```

```nix
# modules/hosts/aether/hardware.nix
{ ... }:
{
  flake.nixosModules.aether-hardware = { config, lib, pkgs, modulesPath, ... }:
  {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
    boot.kernelModules = [ "kvm-amd" ];
    # ... filesystems
  };
}
```

```nix
# modules/hosts/aether/hibernate.nix
{ ... }:
{
  flake.nixosModules.aether-hibernate = { ... }:
  {
    swapDevices = [{ device = "/swapfile"; size = 32768; }];
    boot.resumeDevice = "/dev/disk/by-uuid/a11fea5e-6717-4fa2-8408-0937ebc8528a";
    boot.kernelParams = [ "resume_offset=44204032" ];
    services.logind.settings.Login.HandleLidSwitch = "hibernate";
  };
}
```

**Important:** When a NixOS module uses `self.nixosModules.*` (like `aether-config` importing `aether-hardware`), `self` must be passed via `specialArgs` in the host `default.nix`.

### 4. Per-host `default.nix` — Composes named modules + wires home-manager

```nix
# modules/hosts/aether/default.nix
{ self, inputs, ... }:
{
  flake.nixosConfigurations.aether = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [
      self.nixosModules.aether-config
      self.nixosModules.niri
      self.nixosModules.fonts
      self.nixosModules.gaming
      self.nixosModules.optimize

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          extraSpecialArgs = { inherit inputs; };
          useGlobalPkgs = true;
          useUserPackages = true;
          users.dnkyr = import ./home.nix;
          backupFileExtension = "backup";
        };
      }
    ];
  };
}
```

Everything is referenced by `self.nixosModules.<name>`. To toggle a feature off, remove the line. Home-manager is wired here — `./home.nix` is imported by reference, not auto-discovered by import-tree.

### 5. Per-host `home.nix` — Picks which home feature modules to import

```nix
# modules/hosts/aether/home.nix
{ pkgs, inputs, ... }:
let configs = ../../configs;
in {
  imports = [
    ../../home/base.nix
    ../../home/modules/neovim.nix
    ../../home/modules/shell
    ../../home/modules/noctalia.nix
    ../../home/modules/zen-browser.nix
    ../../home/modules/claude.nix
    ../../home/modules/gaming.nix
  ];
  xdg.configFile."nvim".source = "${configs}/nvim/";
  xdg.configFile."niri".source = "${configs}/niri/";
}
```

```nix
# modules/hosts/vm/home.nix
{ pkgs, inputs, ... }:
{
  imports = [
    ../../home/base.nix
    ../../home/modules/neovim.nix
    ../../home/modules/shell
    ../../home/modules/claude.nix
  ];
}
```

### 6. `home/base.nix` — Shared config

Extracted from current `home/default.nix`, contains only shared stuff (git, direnv, gh, fastfetch, jujutsu, bluetooth MPRIS proxy, common packages like chromium/firefox/telegram/etc).

## Execution Steps

| # | Step | What moves/changes |
|---|------|--------------------|
| 1 | Add `flake-parts` + `import-tree` inputs to `flake.nix`, rewrite outputs to `(inputs.import-tree ./modules)` | `flake.nix` |
| 2 | Create `modules/hosts/` and `modules/features/` directories | mkdir |
| 3 | Move `modules/hosts/aether/` → `modules/hosts/aether/` (already close, adjust paths), wrap each file as `flake.nixosModules.*` | refactor |
| 4 | Move `vm/` → `modules/hosts/vm/`, add `default.nix` + `home.nix`, wrap config/hardware in `flake.nixosModules.*` | move + refactor |
| 5 | Refactor `modules/niri.nix`, `modules/gaming.nix`, `modules/fonts/` → `modules/features/` as individual `flake.nixosModules.<name>` files | move + refactor |
| 6 | Rename `optimizeStore.nix` → `modules/features/optimize.nix` as `flake.nixosModules.optimize` | move + refactor |
| 7 | Delete `modules/default.nix` (no longer needed — import-tree handles discovery) | delete |
| 8 | Split `home/default.nix` into `home/base.nix` (shared) + create per-host `home.nix` files | split |
| 9 | Delete `laptop/` (already empty) | delete |
| 10 | Update `CLAUDE.md` + `agents-spec/` docs to reflect new structure | docs |
| 11 | `nix flake check` to verify everything evaluates | test |

## Adding a New Host Later

1. `mkdir -p modules/hosts/<name>/`
2. Create `modules/hosts/<name>/configuration.nix` exposing `flake.nixosModules.<name>-config`
3. Copy `hardware-configuration.nix` from the new machine → `modules/hosts/<name>/hardware.nix`, wrap as `flake.nixosModules.<name>-hardware`
4. Write `modules/hosts/<name>/default.nix` — compose `self.nixosModules.<name>-*` + pick shared modules
5. Write `modules/hosts/<name>/home.nix` — import `home/base.nix` + whichever `home/modules/` you want
6. Done — import-tree auto-discovers the new host, no manual registration needed

## Adding a New Feature Later

1. Create `modules/features/<name>.nix` exposing `flake.nixosModules.<name>`
2. Add `self.nixosModules.<name>` to whichever hosts need it in their `default.nix`
3. Done — import-tree auto-discovers the file

Build with: `sudo nixos-rebuild switch --flake .#<name>`
