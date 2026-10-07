{ pkgs, lib, ... }:
{
  programs.gh = {
    enable = true;
    package = (pkgs.runCommand "gh-ghtkn-wrapped" { } ''
      mkdir -p $out/bin
      for f in ${pkgs.gh}/bin/*; do
        ln -s "$f" $out/bin/$(basename "$f")
      done
      rm $out/bin/gh
      ln -s ${pkgs.gh}/bin/gh $out/bin/gh-real
      printf '%s\n' '#!/bin/sh' 'if [ -n "$GH_TOKEN" ] || [ -n "$GITHUB_TOKEN" ]; then exec '"$out"'/bin/gh-real "$@"; fi' 'exec ${lib.getExe pkgs.ghtkn} exec -e GH_TOKEN -- '"$out"'/bin/gh-real "$@"' > $out/bin/gh
      chmod +x $out/bin/gh
    '').overrideAttrs (_: { meta.mainProgram = "gh"; });
    settings = {
      editor = "nvim";
      git_protocol = "ssh";
      prompt = "enabled";
      spinner = "enabled";
    };
  };
}
