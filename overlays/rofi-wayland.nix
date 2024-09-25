final: prev: {
  rofi-wayland-unwrapped = prev.rofi-wayland-unwrapped.overrideAttrs (oldAttrs:  
    let
      version = "1.7.5+wayland2";
    in
      {
      version = "1.7.5+wayland2";
      src = prev.fetchFromGitHub {
        owner = "lbonn";
        repo = "rofi";
        rev = version;
        fetchSubmodules = true;
        sha256 = "sha256-5pxDA/71PV4B5T3fzLKVC4U8Gt13vwy3xSDPDsSDAKU=";
      };
    });
}

