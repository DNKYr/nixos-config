## Workflow

**Setup (fresh clone):**
```bash
# Symlink repo to /etc/nixos (requires root)
sudo ln -s /home/dnkyr/nixos-config /etc/nixos

# Apply the configuration
cd /home/dnkyr/nixos-config
sudo nixos-rebuild switch
```

**Making changes:**
1. Edit the relevant `.nix` file (see Architecture above for which layer)
2. Test with `sudo nixos-rebuild test` (activates but doesn't set as boot default)
3. If good, `sudo nixos-rebuild switch` (sets as default)
4. For raw dotfiles (`configs/`), edit directly — no rebuild needed for most editors, but Niri requires a compositor reload

**Commit conventions:**
```
ACTION(scope): short description
```
- `ACTION` ∈ `ADD`, `MODIFY`, `REMOVE`, `FIX`
- `scope` = affected module/area in lowercase (e.g., `home`, `system`, `gaming`, `font`, `shell`, `niri`)
- Examples: `ADD(home): install yazi file explorer`, `MODIFY(font): set system default sans`, `FIX(shell): correct zsh alias for lsd`

**Flake input updates:**
```bash
nix flake update          # update all inputs
nix flake update nixpkgs  # update a single input
sudo nixos-rebuild switch # apply
```
