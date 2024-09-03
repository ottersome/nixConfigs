# my-overlay.nix
self: super: 
let
    
    dependencies = [
      self.git
      self.awk
      self.zsh-completions
    ];
    zplug_repo = self.fetchFromGitHub {
      owner = "zplug";
      repo = "zplug";
    };
in 
{
  zsh = super.zsh.overrideAttrs (oldAttrs: rec {
    # Or you can just include it as an additional resource
    # that you may want to reference later
    buildInputs = oldAttrs.buildInputs ++ dependencies;
    postInstall = oldAttrs.postInstall or "" + ''
      # Maybe copying documentation or scripts
      mkdir -p $out/etc/zsh/
      echo "export ZPLUG_HOME=$out/share/zplug" > $out/etc/zsh/.zshrc
      echo "source $out/etc/zsh/.zshrc" >> $out/etc/zshenv
    '';
  });
}
