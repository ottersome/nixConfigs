{pkgs, ...}: 
let 
ver = "2.46.2";
in
final: prev: {
  git= prev.git.overrideAttrs (oldAttrs:  {
    version = ver;
      src = pkgs.fetchurl {
    url = "https://www.kernel.org/pub/software/scm/git/git-${ver}.tar.xz";
    hash = "sha256-HOEU2ohwQnG0PgJ8UeBNk5n4yI6e91Qtrnrrrn2HvE4=";
  };

  });
}
