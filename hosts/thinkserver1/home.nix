{ config, pkgs, ... }:
{
  home.username = "emorio";
  home.homeDirectory = "/home/emorio";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    fzf
    ripgrep
    tmux
    htop
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "eliasmorio";
      email = "eliasmorio@users.noreply.github.com";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      k = "kubectl";
      kc = "kubectl config current-context";
      kn = "kubectl config set-context --current --namespace";
      kgp = "kubectl get pods --all-namespaces";
      kgpn = "kubectl get pods -n";
      kgs = "kubectl get svc --all-namespaces";
      kgn = "kubectl get nodes -o wide";
      kdp = "kubectl describe pod";
      kl = "kubectl logs";

      f = "flux";
      fgk = "flux get kustomizations -A";
      fgh = "flux get helmreleases -A";
      fr = "flux reconcile source git flux-system";

      nr = "sudo nixos-rebuild switch --flake .#thinkserver1";
      hm = "home-manager switch --flake .#emorio@thinkserver1";
      ne = "nix eval .#nixosConfigurations.thinkserver1.config.system.build.toplevel.drvPath";

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
    initExtra = ''
      export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
    '';
  };
}
