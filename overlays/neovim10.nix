self: super: {
  neovim = super.neovim.overrideAttrs (oldAttrs: rec {
    version = "v0.10.1";
    src = super.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "0.10.1"; # Use the specific version tag
      sha256 = "9708a63f8faa44535037eb874852477645d8444586c2da0473b53e6cde530dc7"; # Replace with the correct hash
    };
  });
}

