{ pkgs, inputs, ... }:

# PANIM (github:SakuraRainn/panim) — desktop persona manager.
# This is the from-source build: it ships without PANIM's own Telegram app
# values, so adding a Telegram account needs your own api_id/api_hash
# (Settings → Telegram app values). The `panim-release` output that embeds them
# requires an impure build with env vars, so it isn't used here.
{
  home.packages = [ inputs.panim.packages.${pkgs.stdenv.hostPlatform.system}.panim ];
}
