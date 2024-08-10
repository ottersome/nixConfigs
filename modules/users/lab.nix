{ config, lib, pkgs, ... }:
{
  users.users = {
    # FIXME: Replace with your username
    lab716a = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "itlablinux";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
    };
    racc = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "itlablinux";
      isNormalUser = true;
      # shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCw0fgl5QxyFmqY1Hcg2RSCm7XLQlIQ5naFY9S1OAmOV8LnTpqjG0YLs8K8Z2bgioykH8EBj0rnyMPNj31XmXZB55ss810yOMH4M4tpKpPdyvxOIxh+IcLluj4uiq018Tzj5+zXXhDQlh4HQdxqQFCvX7n/2VPF8GpWOd74wxO0HKirBAakxH+wvVrns62XAJyKYkTSMYHg1h8UMrKf2SLO3lVdmTmLHGxpLu+sa9jJnP9bZhop049EmGye2lSvrfn+ZWKMBnbsN4byLhrXCeVIDJ/4TJuJWqZmnWWw6Nbz7y8KKm4FdkhmVY/cXiYf6+1XThWePQwxcrpwC1voosy7ZXfXldV1jwTpU5d/3t4sfJ6Wufi2gys7b9HDdAbGJU+sU4hmi99JPUp59S23/kyl7x4/utcksodXmR67OBYqUZakvT27FpI1xq6ITMH6NvyNb1zLSOlVIFlVIrZjbOkkcqg3WoAZwk6kN9mDhQrzjxvMreCesx3bXjbuI+WbnE6B/vaz62u/WYfygIRupRkiunpSRA3qzOjt+iBbGJYmXzr7v762pdleG6ALznpqE4S7SaZO7/y+KU5INBUiqeC6iYD+5HWmCM69YZnj7du+CUdyAjEFXbHFGiZ6SccNwLKPpSNfXyTHDRHnRS7A2Rcdfeo5V5eZhXXwF2L18KECKQ== luisgarcia26284@gmail.com
"
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel"];
    };
    root = {
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCw0fgl5QxyFmqY1Hcg2RSCm7XLQlIQ5naFY9S1OAmOV8LnTpqjG0YLs8K8Z2bgioykH8EBj0rnyMPNj31XmXZB55ss810yOMH4M4tpKpPdyvxOIxh+IcLluj4uiq018Tzj5+zXXhDQlh4HQdxqQFCvX7n/2VPF8GpWOd74wxO0HKirBAakxH+wvVrns62XAJyKYkTSMYHg1h8UMrKf2SLO3lVdmTmLHGxpLu+sa9jJnP9bZhop049EmGye2lSvrfn+ZWKMBnbsN4byLhrXCeVIDJ/4TJuJWqZmnWWw6Nbz7y8KKm4FdkhmVY/cXiYf6+1XThWePQwxcrpwC1voosy7ZXfXldV1jwTpU5d/3t4sfJ6Wufi2gys7b9HDdAbGJU+sU4hmi99JPUp59S23/kyl7x4/utcksodXmR67OBYqUZakvT27FpI1xq6ITMH6NvyNb1zLSOlVIFlVIrZjbOkkcqg3WoAZwk6kN9mDhQrzjxvMreCesx3bXjbuI+WbnE6B/vaz62u/WYfygIRupRkiunpSRA3qzOjt+iBbGJYmXzr7v762pdleG6ALznpqE4S7SaZO7/y+KU5INBUiqeC6iYD+5HWmCM69YZnj7du+CUdyAjEFXbHFGiZ6SccNwLKPpSNfXyTHDRHnRS7A2Rcdfeo5V5eZhXXwF2L18KECKQ== luisgarcia26284@gmail.com
"
      ];
    };
  };
}
