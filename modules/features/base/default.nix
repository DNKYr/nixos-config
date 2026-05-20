{ ... }:

{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # core tools
        neovim
        just
        gnumake
        git

        # Text Processing
        gnugrep
        gawk
        gnutar
        gnused

        # System Monitoring
        btop

        # Network Tools
        curl
        wget

        # Security
        openssl

      ];
    };

}
