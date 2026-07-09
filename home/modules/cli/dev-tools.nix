{ pkgs, ... }:

{
  home.packages = with pkgs; [

    rustup
    cargo-nextest
    cargo-watch
    cargo-edit
    cargo-deny
    cargo-audit
    cargo-outdated
    sccache
    bacon

    python3
    python3Packages.ruff
    basedpyright
    python3Packages.pylint
    python3Packages.mypy
    python3Packages.black
    python3Packages.isort
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
    typescript-language-server
    vscode-langservers-extracted
    tailwindcss-language-server
    svelte-language-server
    vue-language-server
    deno
    bun
    pnpm
    yarn
    biome

  ];
}
