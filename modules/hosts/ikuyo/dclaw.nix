{ ... }:

{
  flake.nixosModules.ikuyo-dclaw =
    { config, ... }:
    {
      virtualisation.podman = {
        enable = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
      };

      virtualisation.oci-containers = {
        backend = "podman";
        containers.dclaw = {
          image = "ghcr.io/dnkyr/dclaw:latest";
          autoStart = true;
          cmd = [ "gateway" ];

          # Private ghcr.io package — read-only PAT supplied via agenix.
          login = {
            registry = "ghcr.io";
            username = "DNKYr";
            passwordFile = config.age.secrets.ikuyo-ghcr-token.path;
          };

          # Publish only to loopback. Reach the WebUI with:
          #   ssh -L 8765:localhost:8765 ikuyo   →   http://localhost:8765
          ports = [ "127.0.0.1:8765:8765" ];

          volumes = [
            # Persistent state: sessions, memory, workspace, channel login state.
            "/var/lib/dclaw:/home/nanobot/.nanobot"
            # Secrets (provider API key + websocket tokenIssueSecret) stay encrypted
            # at rest in agenix and are mounted read-only on top of the state dir.
            "${config.age.secrets.ikuyo-dclaw-config.path}:/home/nanobot/.nanobot/config.json:ro"
          ];

          extraOptions = [
            "--cap-drop=ALL"
            "--cap-add=SYS_ADMIN" # nanobot's bwrap exec sandbox needs user namespaces
            "--security-opt=seccomp=unconfined"
            "--security-opt=apparmor=unconfined"
            "--pull=always" # re-pull :latest on (re)start after CI publishes a new build
          ];
        };
      };

      # nanobot reads config.json only at startup, and editing an agenix secret's
      # content alone doesn't change the container's systemd unit — so without this
      # the running container keeps the old config until manually restarted. Tying
      # the unit to the encrypted .age store path makes `just ikuyo` restart the
      # container whenever the config (or ghcr token) secret changes.
      systemd.services.podman-dclaw.restartTriggers = [
        config.age.secrets.ikuyo-dclaw-config.file
        config.age.secrets.ikuyo-ghcr-token.file
      ];

      # State dir. UID 1000 == the `dnkyr` user on ikuyo, which rootful podman maps
      # to identity, so the container's `nanobot` (UID 1000) owns its own files.
      systemd.tmpfiles.rules = [
        "d /var/lib/dclaw 0700 dnkyr users -"
      ];
    };
}
