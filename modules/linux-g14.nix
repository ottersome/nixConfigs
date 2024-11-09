{
  lib,
  fetchurl,
  buildLinux,
  ...
}@args:

let
  version = "6.11.5";
in
buildLinux (
  args
  // {
    inherit version;
    pname = "linux-g14";
    modDirVersion = version;
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
      hash = "sha256-RxSFs7fy+2N72P49AJRMTBNcfY7gLzV/M2kLqrB1Kgc=";
    };
    kernelPatches =
      let
        g14-patch = {
          name = "g14";
          patch = fetchurl {
            url = "https://gitlab.com/asus-linux/fedora-kernel/-/raw/rog-6.11/asus-patch-series.patch";
            hash = "sha256-soYkrBruBtCUnoWGZxcdk/ARs4piP6d884hjqhLbOEk=";
          };
        };
      in
      [
          g14-patch
      ];
    structuredExtraConfig = with lib.kernel; {
      HID_ASUS_ALLY = module;
      ASUS_ARMOURY = module;
      # ASUS_WMI_BIOS = yes;
    };
    extraMeta = {
      branch = lib.versions.majorMinor version;
    };
  }
)
