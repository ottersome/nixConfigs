self: super: {
  auto-cpufreq = super.auto-cpufreq.overrideAttrs (oldAttrs: rec {
    version = "YOUR_DESIRED_VERSION";
    src = super.fetchFromGitHub {
      owner = "AdnanHodzic";
      repo = "auto-cpufreq";
      rev = "v2.4.0"; # Use the specific version tag
      # sha256 = "YOUR_SHA256_HASH"; # Replace with the correct hash
    };
  });
}

