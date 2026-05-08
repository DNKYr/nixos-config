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
        inputs.agenix.nixosModules.default
        self.nixosModules.ikuyo-hardware
        self.nixosModules.ikuyo-disko
        self.nixosModules.optimize
      ];

      age.secrets.dnkyr-password.file = ../../../secrets/ikuyo-dnkyr-password.age;
      environment.systemPackages = with pkgs; [
        git
        vim
      ];

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
        allowedTCPPorts = [ 22 ];
      };

      system.stateVersion = "25.11";
    };
}
