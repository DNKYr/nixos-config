{ pkgs, ... }:

{
  # Modify PUPPETEER_EXECUTABLE_PATH for md-to-pdf to work in pnpm
  home.sessionVariables.PUPPETEER_EXECUTABLE_PATH = "${pkgs.chromium}/bin/chromium";

  home.packages = with pkgs;
    [

      rustup
      cargo-nextest
      cargo-watch
      cargo-edit
      cargo-deny
      cargo-audit
      cargo-outdated
      sccache
      bacon

      (python3.withPackages (ps: with ps; [
        jupyterlab
        notebook
        ipykernel
        numpy
        matplotlib
        pandas
        scipy
        torch
        graphviz
      ]))
      python3Packages.ruff
      basedpyright
      python3Packages.pylint
      python3Packages.mypy
      python3Packages.black
      python3Packages.isort
      python3Packages.pytest
      poetry
      python3Packages.uv
      pipenv

      go
      gopls
      golangci-lint
      delve
      gofumpt
      gomodifytags
      impl
      iferr
      gotests
      air

      gcc
      cmake
      gdb
      lldb
      valgrind
      bear
      cppcheck
      conan
      pkg-config

      typescript
      eslint
      prettier
      # Upstream pnpmDeps hash is stale in nixpkgs; drop this override once fixed.
      (typescript-language-server.overrideAttrs (finalAttrs: old: {
        pnpmDeps = old.pnpmDeps.overrideAttrs {
          outputHash = "sha256-xR/EF60lVBsITKgH7wCM2wHM46PFQevD51KfCENSUH4=";
        };
      }))
      vscode-langservers-extracted
      tailwindcss-language-server
      svelte-language-server
      vue-language-server
      deno
      bun
      pnpm
      yarn
      biome

      # database
      sqlite
      sqlitebrowser
    ];
}
