# @vinialx zsh profile configuration

alias nix-config='sudo nvim /etc/nixos/configuration.nix'
alias nix-update='sudo nixos-rebuild switch'
alias nix-clear='sudo nix-collect-garbage'

# direnv configuration.
eval "$(direnv hook zsh)"

# zoxide configuration.
eval "$(zoxide init zsh)"

# fzf configuration.
eval "$(fzf --zsh)"

# integration zoxide & fzf.
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# bun completions.
[ -s "/home/vinicius/.bun/_bun" ] && source "/home/vinicius/.bun/_bun"

# bun exports.
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# flake dev configuration.
function nix-init-node() {
  cat << 'EOF' > flake.nix
{
  description = "web development environment with node.js and bun";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.bun
          pkgs.nodejs
          pkgs.typescript-language-server
          pkgs.prettier
          pkgs.gcc
        ];

        shellHook = ''
          echo "nix environment activated"
          echo "node: $(node --version) | bun: $(bun --version)"
        '';
      };
    };
}
EOF

  echo "use flake" > .envrc
  if [ -d .git ]; then
    git add flake.nix .envrc 2>/dev/null
  fi
  direnv allow
}

function nix-init-go() {
  cat << 'EOF' > flake.nix
{
  description = "go development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.go
          pkgs.gopls
          pkgs.gotools
        ];

        shellHook = ''
          echo "nix environment activated"
          echo "go: $(go version)"
        '';
      };
    };
}
EOF

  echo "use flake" > .envrc
  if [ -d .git ]; then
    git add flake.nix .envrc 2>/dev/null
  fi
  direnv allow
}

function nix-init-python() {
  cat << 'EOF' > flake.nix
{
  description = "python development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          (pkgs.python3.withPackages (ps: [
            ps.pip
            ps.virtualenv
          ]))
          pkgs.pyright
          pkgs.black
        ];

        shellHook = ''
          echo "nix environment activated"
          echo "python: $(python --version)"
        '';
      };
    };
}
EOF

  echo "use flake" > .envrc
  if [ -d .git ]; then
    git add flake.nix .envrc 2>/dev/null
  fi
  direnv allow
}
