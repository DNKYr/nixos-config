## Coding Standards

| Concern | Rule | Why |
|---------|------|-----|
| Module file length | Soft max ~100 lines | Existing modules are 10–45 lines; growth beyond ~100 is a sign it should be split |
| Module granularity | One logical concern per file | Makes it easy to enable/disable features by commenting out an import |
| `inputs` access | Only declare `inputs` in module args if the module actually uses a flake input | Keeps unused args out of signatures |
| Package management | Prefer `home.packages` for user tools; use `programs.<name>` when home-manager has a module | `programs.*` modules generate correct config file paths automatically |
| Raw configs | Use `xdg.configFile.<name>.source = "${configs}/<dir>"` to symlink entire dirs | Keeps AstroNvim / Niri configs editable without a full rebuild |

**Naming:**
- Module files: lowercase, hyphen-separated (e.g., `zen-browser.nix`, `cpp-dev.nix`)
- Scope labels in commits: lowercase, match the module or area (e.g., `home`, `system`, `gaming`, `font`)

---
