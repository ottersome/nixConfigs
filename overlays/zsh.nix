# my-overlay.nix
self: super: 
let
  # zplug = builtins.fetchGit {
  #   url = "https://github.com/zplug/zplug";
  #   ref = "master";
  #   rev = "8f14b4850d8e410f00db92afcd87b88c0c90f771";
  #   
  # };
  zplug = super.stdenv.mkDerivation {
    name = "zplug_repo";
    src = builtins.fetchGit {
      url = "https://github.com/zplug/zplug";
      ref = "master";
      rev = "8f14b4850d8e410f00db92afcd87b88c0c90f771";
    };
    # installPhase = ''
    #     mkdir -p $out/bin
    #     cp some-script.sh $out/bin/
    #     '';
  };
  # Zplug should now point to the zplug repo

  depends = [
    self.git
    self.gawkInteractive
    self.zsh-completions
    zplug
  ];
in 
  {
  zsh = super.zsh.overrideAttrs (oldAttrs: rec {
    # Or you can just include it as an additional resource
    # that you may want to reference later
    buildInputs = oldAttrs.buildInputs ++ depends;
    postInstall = oldAttrs.postInstall or "" + ''
      # Fetch the GitHub repository and place it in a specific directory
      repo_dir=$out/share/zplug_repo
      mkdir -p $repo_dir
      git clone https://github.com/username/repository.git $repo_dir
    '';

    # Add a custom shell hook to append to .zshrc
    shellHook = ''
      echo "export ZPLUG_HOME=\$HOME/.nix-profile/share/zplug_repo" 
      # echo "source \$MY_REPO_DIR/somescript.sh" >> $HOME/.zshrc
      '';
  });
}
