{ pkgs, ...}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;
    
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    
    initContent = ''
      source ~/.p10k.zsh
      eval "$(git wt --init zsh)"
      alias q='cd "$(ghq root)/$(ghq list | fzf)"'
      alias nixc='cd ~/nixos-config/'
      alias initpart='nix flake init -t github:hercules-ci/flake-parts'
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock

      inknb() {
        if [[ -z "$1" ]]; then
          echo "Usage: inknb <notebook:id>"
          return 1
        fi

        note_path=$(nb show --path "$1") || {
          echo "Error: Could not find item '$1'"
          return 1
        }
        ink "$note_path"
      }
    '';
  };
}
