final: prev: {
  git= prev.git.overrideAttrs (oldAttrs:  {
    version = "v2.46.2";
    src = prev.fetchFromGitHub {
      owner = "git";
      repo = "git";
      rev = "v2.46.2"; # Use the specific version tag
      sha256 = "4f71522dfb7fc53eff569023303980c66114b1bc"; # Replace with the correct hash
    };
  });
}

