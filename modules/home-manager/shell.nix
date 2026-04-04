# Bash configuration with common aliases shared across all hosts
_:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      # Nix shortcuts
      nr = "sudo nixos-rebuild switch";
      ne = "sudo nixos-rebuild edit";

      # Git shortcuts
      gs = "git status -sb";
      ga = "git add";
      gaa = "git add .";
      gc = "git commit";
      gcm = "git commit -m";
      gl = "git log --oneline --graph --decorate -20";
      gd = "git diff";
      gdc = "git diff --cached";
      gp = "git push";
      gpl = "git pull --rebase";
    };
  };
}
