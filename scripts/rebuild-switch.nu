let hosts = [
  { name: "aether", remote: null}
  { name: "ikuyo", remote: "dnkyr@ikuyo"}
]

def repeat-str [s: string, n: int] {
  (1..$n | each {$s} | str join)
}

def get-remote [host: string] {
  ($hosts | where name == $host | get remote | first)
}


def nixos-switch [name: string, remote?: string] {
  print $"nixos-switch '($name)'..."
  print (repeat-str "=" 50)

  if $remote != null {
    nixos-rebuild switch --sudo --flake $".#($name)" --target-host $"($remote)" --ask-sudo-password
  } else {
    nixos-rebuild switch --sudo --flake $".#($name)" --ask-sudo-password
  }
}

def main [host?: string] {
  let valid = ($hosts | get name)

  let target = if ($host == null) {"all"} else {$host}

  if ($target != "all") and ($target not-in $valid) {
    error make {msg: $"unknown host '($target)'; valid: ($valid | str join ', ')"}
  }

  let to_build = if ($target == "all") {$valid} else {[$target]}

  for h in $to_build {
    nixos-switch $h (get-remote $h)
  }
}
