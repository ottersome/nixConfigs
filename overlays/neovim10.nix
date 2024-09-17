final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs:  {
    version = "v0.10.1";
    src = prev.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "v0.10.1"; # Use the specific version tag
      sha256 = "3ac1c869c828ad89c1fdd3dbce5d5beab614cd07614edb0960bb052c9c6b7a09"; # Replace with the correct hash
    };
  });
}

