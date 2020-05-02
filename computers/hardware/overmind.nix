# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];


  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a8e2e3a4-b045-47d6-b3f7-65a9508585f7";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7BE6-C0CC";
      fsType = "vfat";
    };

  fileSystems."/home/refnil/.local/share/Steam" = {
    device = "/dev/disk/by-uuid/79cde096-cd32-4a53-bb10-c9c78e36a8d9";
    fsType = "ext4";
  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/a4759a63-f991-42f1-97f5-91cac8a80b34"; }
    ];

  nix.maxJobs = lib.mkDefault 12;
}
