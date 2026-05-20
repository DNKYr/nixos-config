{ ... }:
{
  flake.nixosModules.aether-ucla-vpn =
    { pkgs, ... }:
    let
      # Prints the SAML auth URL to stderr and exits 0, so openconnect's
      # local callback listener stays up while you paste the URL into
      # your already-running browser. Needed because openconnect runs as
      # root via sudo and can't reach the user's Wayland session to spawn
      # a browser itself.
      oc-browser = pkgs.writeShellScriptBin "oc-browser" ''
        printf '\n===================================\n' >&2
        printf 'OPEN THIS URL IN FIREFOX:\n%s\n' "$1" >&2
        printf '===================================\n\n' >&2
      '';

      # One-shot wrapper: `ucla-vpn` from any terminal connects to UCLA's
      # AnyConnect gateway with SAML external-browser auth wired up.
      # Extra args are passed through to openconnect.
      ucla-vpn = pkgs.writeShellScriptBin "ucla-vpn" ''
        exec sudo ${pkgs.openconnect}/bin/openconnect \
          --protocol=anyconnect \
          --external-browser=${oc-browser}/bin/oc-browser \
          ssl.vpn.ucla.edu "$@"
      '';
    in
    {
      environment.systemPackages = [
        pkgs.openconnect
        oc-browser
        ucla-vpn
      ];
    };
}
