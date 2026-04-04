# Kubernetes and Flux CLI aliases for k3s hosts
_:

{
  programs.bash = {
    shellAliases = {
      # Kubernetes shortcuts
      k = "kubectl";
      kc = "kubectl config current-context";
      kn = "kubectl config set-context --current --namespace";
      kgp = "kubectl get pods --all-namespaces";
      kgpn = "kubectl get pods -n";
      kgs = "kubectl get svc --all-namespaces";
      kgn = "kubectl get nodes -o wide";
      kdp = "kubectl describe pod";
      kl = "kubectl logs";

      # Flux shortcuts
      f = "flux";
      fgk = "flux get kustomizations -A";
      fgh = "flux get helmreleases -A";
      fr = "flux reconcile source git flux-system";
    };

    # Add krew to PATH
    initExtra = ''
      export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
    '';
  };
}
