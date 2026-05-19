{ inputs, ... }:

let
  inherit (inputs.secrets.lib.ikuyo.cloudflared) tunnelId hostname;
in
{
  flake.nixosModules.ikuyo-cloudflared =
    { config, ... }:
    {
      services.cloudflared = {
        enable = true;
        tunnels.${tunnelId} = {
          credentialsFile = config.age.secrets.ikuyo-cloudflared-creds.path;
          default = "http_status:404";
          ingress.${hostname} = "http://localhost:8001";
        };
      };
    };
}
