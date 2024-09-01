{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  myNvim= stdenv.mkDerivation {
    name = "myNvim";
    src = null;
    buildInputs = [
      neovim
      nodejs        # Provides npm
      # Add other dependencies here
      python3
      ripgrep
      fd
    ];
    shellHook = ''
      export PATH=$PATH:${pkgs.nodejs}/bin
      '';
    meta = {
       description = "A wrapped Neovim with npm included";
       maintainers = with pkgs.lib.maintainers; [ yourname ];
    };
    # nativeBuildInputs = [pkgs.makeWrapper];
    #
    # # This empty phase is necessary to prevent Nix from trying to build anything.
    unpackPhase = "true";
    buildPhase = "true";
    #
    # installPhase = ''
    #   mkdir -p $out/bin
    #   makeWrapper ${neovim}/bin/nvim \
    #     --prefix PATH : ${lib.makeBinPath [ nodejs python3 ripgrep fd ]}
    #     --set NPM_CONFIG_PREFIX $out  # Optional: Set npm prefix if needed
    #     --set NODE_PATH ${nodejs}/lib/node_modules  # Optional: Set node path
    #     --set PYTHONPATH ${python3.sitePackages}  # Optional: Set python path
    #     --run "npm config set prefix $out"  # Optional: Configure npm prefix
    #   ln -s $out/bin/nvim $out/bin/vim  # Optional: Alias vim to nvim
    # '';
  };
in
myNvim
