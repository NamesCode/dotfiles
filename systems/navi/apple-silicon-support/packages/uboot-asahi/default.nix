{ lib
, fetchFromGitHub
, buildUBoot
, m1n1
}:

(buildUBoot rec {
  src = fetchFromGitHub {
    # tracking: https://pagure.io/fedora-asahi/uboot-tools/commits/main
    owner = "AsahiLinux";
    repo = "u-boot";
    rev = "asahi-v2024.07-1";
    hash = "sha256-TN82UydeOyt2EywFjAmtXR6x68XfzwMXxqoJyTxOwCw=";
  };
  version = "2024.07-1-asahi";

  defconfig = "apple_m1_defconfig";
  extraMeta.platforms = [ "aarch64-linux" ];
  filesToInstall = [
    "u-boot-nodtb.bin.gz"
    "m1n1-u-boot.bin"
  ];
  extraConfig = ''
    CONFIG_IDENT_STRING=" ${version}"
    CONFIG_BOOTMETH_VBE=n
    CONFIG_AUTOBOOT_KEYED=n
    CONFIG_ARM64_SUPPORT_AARCH32=n
    CONFIG_SYS_MALLOC_CLEAR_ON_INIT=n
    CONFIG_BOOTDELAY=1
    CONFIG_BOOTM_VXWORKS=n
    CONFIG_BOOTM_NETBSD=n
    CONFIG_BOOTM_PLAN9=n
    CONFIG_BOOTM_RTEMS=n
    CONFIG_CMD_LZMADEC=n
    CONFIG_LZMA=n
    CONFIG_CMD_UNLZ4=n
    CONFIG_LZ4=n
    CONFIG_TOOLS_KWBIMAGE=n
    CONFIG_CMD_SELECT_FONT=n
    CONFIG_VIDEO_LOGO=n
    CONFIG_VIDEO_BMP_RLE8=n
    CONFIG_VIDEO_FONT_4X6=n
    CONFIG_VIDEO_FONT_8X16=n
    CONFIG_VIDEO_FONT_SUN12X22=n
  '';
}).overrideAttrs (o: {
  # nixos's downstream patches are not applicable
  patches = [ ./openssl-no-engine.patch
  ];

  # DTC= flag somehow breaks DTC compilation so we remove it
  makeFlags = builtins.filter (s: (!(lib.strings.hasPrefix "DTC=" s))) o.makeFlags;

  preInstall = ''
    # compress so that m1n1 knows U-Boot's size and can find things after it
    gzip -n u-boot-nodtb.bin
    cat ${m1n1}/build/m1n1.bin arch/arm/dts/t[68]*.dtb u-boot-nodtb.bin.gz > m1n1-u-boot.bin
  '';
})
