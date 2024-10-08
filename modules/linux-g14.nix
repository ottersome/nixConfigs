{
  lib,
  fetchurl,
  buildLinux,
  ...
}@args:

let
  version = "6.11.2";
in
buildLinux (
  args
  // {
    inherit version;
    pname = "linux-g14";
    modDirVersion = version;
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
      hash = "sha256-7J73oLnOu1WUDh74eh+eEASxBFahGdw4a7PlZbDTnEI=";
    };
    kernelPatches =
      let
        g14-patch = {
          name = "g14";
          patch = fetchurl {
            url = "https://gitlab.com/asus-linux/fedora-kernel/-/raw/rog-6.11/asus-patch-series.patch";
            hash = "sha256-gxOeked6K9In+n5TwBCaxNJbk+4JNc2i4FYJYPOx2Sk=";
          };
        };
        realtek_sound = {
            name = "realtek_sound";
            # Get it from ./patches/patch_realtek.patch
            patch = ./patches/patch_realtek.patch;
          };
        # amdgpu-cleared-vram-for-GEM-allocations-patch = {
        #   name = "amdgpu-cleared-vram-for-GEM-allocations";
        #   patch = fetchurl {
        #     url = "https://gitlab.freedesktop.org/agd5f/linux/-/commit/4de34b04783628f14614badb0a1aa67ce3fcef5d.patch";
        #     hash = "sha256-fJcMwupXQ74aoeC2tr4KdUZpkv1qaXUZAn7cbqgBLJw=";
        #   };
        # };
      in
      [
          g14-patch
          realtek_sound
          # amdgpu-cleared-vram-for-GEM-allocations-patch
      ];
    structuredExtraConfig = with lib.kernel; {
      HID_ASUS_ALLY = module;
      ASUS_ARMOURY = module;
      ASUS_WMI_BIOS = yes;
    };
    extraMeta = {
      branch = lib.versions.majorMinor version;
    };
  }
)
