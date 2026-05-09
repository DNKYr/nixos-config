cd /home/dnkyr/nixos-config

echo "

Rebuilding Aether...

"
nixos-rebuild switch --flake .#aether --sudo --ask-sudo-password

echo "

Rebuilding Ikuyo...

"
nixos-rebuild switch --flake .#ikuyo --target-host dnkyr@ikuyo --sudo --ask-sudo-password
