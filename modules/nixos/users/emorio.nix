# User account for emorio
# Shared across all hosts
_:

{
  users.users.emorio = {
    isNormalUser = true;
    description = "emorio";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQdIvxwPQ8NqnaC0ssqVnu9dFA3Is66c2Me1kGeWkls"
    ];
    # Fallback password for console access and recovery
    initialPassword = "password";
  };

  # Allow wheel group to use sudo without password (required for deploy-rs)
  security.sudo.wheelNeedsPassword = false;
}
