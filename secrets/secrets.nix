let
  aether = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7+nDVbv0+ezllaOxTbmyDwW9rShT5TlMYhrRLJzF/P";
  ikuyo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAw7Hnf34jM/KTcL29v5d+cUvZyLb1YoO09dURYp9j5k";
in
{
  "ikuyo-dnkyr-password.age".publicKeys = [
    aether
    ikuyo
  ];
}
