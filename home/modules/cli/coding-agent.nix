{ pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code
    opencode
    pi-coding-agent
    codex
  ];

}
