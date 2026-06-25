{
  description = "DNKYr's nix flake";

  inputs = {
    # Adding package source for nix packages
    # nixpkgs.url = "github:nixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-25.05&shallow=1";
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    import-tree = {
      url = "github:vic/import-tree";
    };

    home-manager = {
      # Make home-manager set to the master branch
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      # Pinned to the last v4 revision. v5.0.0 is a major redesign that breaks
      # the CLI (`ipc call` -> `msg`), wallpaper model, and theming. Bump
      # deliberately (and migrate configs) rather than via `just up`.
      url = "github:noctalia-dev/noctalia-shell/fe6fa125f5ee7881c4ee0cf9c0a4329a8238d3c2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emtodo = {
      url = "github:dnkyr/eisenhower-matrix-todo";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Private values (tunnel IDs, hostnames, anything you don't want in public git history).
    # Cloning the public repo without SSH access to this input will fail eval — that's intentional.
    secrets = {
      url = "git+ssh://git@github.com/DNKYr/nixos-config-secrets";
      flake = true;
    };

  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

}
