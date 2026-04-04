# thinkserver1 Home Manager configuration
_:

{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/shell.nix
    ../../modules/home-manager/kubernetes.nix
  ];
}
