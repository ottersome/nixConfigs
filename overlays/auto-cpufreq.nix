self: super: {
  auto-cpufreq = super.auto-cpufreq.overrideAttrs (oldAttrs: rec {
    version = "v2.2.0";
    src = super.fetchFromGitHub {
      owner = "AdnanHodzic";
      repo = "auto-cpufreq";
      rev = "v2.2.0"; # Use the specific version tag
      sha256 = "9708a63f8faa44535037eb874852477645d8444586c2da0473b53e6cde530dc7"; # Replace with the correct hash
    };
  });
}

