{ self, inputs, ... }:

{
  flake.nixosModules.ikuyo-config =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        inputs.agenix.nixosModules.default # Secret Management
        self.nixosModules.base
        self.nixosModules.ikuyo-hardware
        self.nixosModules.ikuyo-disko
        self.nixosModules.optimize
        self.nixosModules.ikuyo-xray
        self.nixosModules.ikuyo-cloudflared
        self.nixosModules.ikuyo-dclaw
      ];

      age.secrets.dnkyr-password.file = ../../../secrets/ikuyo-dnkyr-password.age;
      age.secrets.ikuyo-xray-config.file = ../../../secrets/ikuyo-xray-config.age;
      age.secrets.ikuyo-cloudflared-creds.file = ../../../secrets/ikuyo-cloudflared-creds.age;
      age.secrets.ikuyo-dclaw-config = {
        file = ../../../secrets/ikuyo-dclaw-config.age;
        owner = "dnkyr"; # readable by the container's UID-1000 nanobot user
        mode = "0400";
      };
      age.secrets.ikuyo-ghcr-token.file = ../../../secrets/ikuyo-ghcr-token.age;

      boot.loader.grub = {
        enable = true;
        efiSupport = false;
      };

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      nix.settings.trusted-users = [
        "root"
        "@wheel"
      ];

      networking.hostName = "ikuyo";
      time.timeZone = "UTC";
      i18n.defaultLocale = "en_US.UTF-8";

      services.openssh = {
        enable = true;

        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };

      users.users.dnkyr = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7+nDVbv0+ezllaOxTbmyDwW9rShT5TlMYhrRLJzF/P"
        ];
        hashedPasswordFile = config.age.secrets.dnkyr-password.path;
      };

      security.sudo.wheelNeedsPassword = true;

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [
          22
          443 # xray VLESS+Reality direct
        ];
      };

      system.stateVersion = "25.11";
    };
}
