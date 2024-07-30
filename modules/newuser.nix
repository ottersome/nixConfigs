{ config, pkgs, ... }:

let
  # Define the path to a marker file that indicates the user setup is complete
  markerFile = "${config.home.homeDirectory}/.config/nixpkgs/home.nix";
  # currentFile = toString __curSrc;
  # parentDir = builtins.head (builtins.split "/" currentFile);
  parentDir = builtins.toString ./.;
in {
  home = {
    # Define the user configuration
    homeDirectory = "/home/${config.user.name}";

    # Define home.packages if you need any specific packages
    packages = with pkgs; [
      # Add packages here
    ];

    # Use home.file to create initial templates or configuration files
    file = {
      ".config/myapp/template.conf" = {
        text = ''
          # Template configuration file
          # Add your default configurations here
        '';
      };
    };

    # Run a script only if the marker file does not exist
    sessionInit = if builtins.pathExists markerFile then "" else ''
      # Your initialization script
      # For example, creating a marker file
      mkdir ${config.home.homeDirectory}/.config/nixpkgs
      # Copy the template template_config.conf in the same directory as this file to the user's home directory
      cp ${parentDir}/template_homeconfig.nix ${config.home.homeDirectory}/.config/myapp/config.conf
      # Add other setup commands here
      # Finalm message of the day
      echo "Welcome to ${config.user.name}'s configuration. Please look at instructions.md to know how to use this config." 
    '';
  };
}

