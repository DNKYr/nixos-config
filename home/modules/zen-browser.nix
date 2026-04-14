{ inputs, pkgs, ... }:

let
  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  prefs = {
    # Check these out at about:config
    "extensions.autoDisableScopes" = 0;
    "extensions.pocket.enabled" = false;
    # ...
  };

  extensions = [
    # To add additional extensions, find it on addons.mozilla.org, find
    # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
    # Then go to https://addons.mozilla.org/api/v5/addons/addon/!SHORT_ID!/ to get the guid
    (extension "ublock-origin" "uBlock0@raymondhill.net")
    (extension "proton-pass" "78272b6fa58f4a1abaac99321d503a20@proton.me")
    (extension "ether-metamask" "webextension@metamask.io")
    (extension "web-clipper-obsidian" "clipper@obsidian.md")
    # ...
  ];

in

{
  imports = [
    inputs.zen-browser.homeModules.default
  ];

  programs.zen-browser = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      ExtensionSettings = builtins.listToAttrs extensions;

      SearchEngines = {
        Default = "ddg";

        Add = [
          {
            Name = "nixpkgs packages";
            URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
            IconURL = "https://wiki.nixos.org/favicon.ico";
            Alias = "@np";
          }
        ];
      };
    };

  };
}
