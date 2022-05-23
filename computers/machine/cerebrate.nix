# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../hardware/cerebrate.nix

      ../common/base.nix

      ../../home-folders/refnil/user.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "cerebrate"; # Define your hostname.

  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.clickMethod = "clickfinger";

  services.xserver.desktopManager = {
    lxqt.enable = true;
    # mate.enable = true;
    # pantheon.enable = true;
    # plasma5.enable = true;
    xfce.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.refnil = {
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };

  environment.variables = {
    # MESA_LOADER_DRIVER_OVERRIDE = "iris";
  };
  # hardware.opengl.package = (pkgs.mesa.override {
  #   galliumDrivers = [ "nouveau" "virgl" "swrast" "iris" ];
  # }).drivers;
  hardware.opengl.extraPackages = with pkgs; [
    # https://nixos.org/manual/nixos/stable/index.html#sec-gpu-accel-opencl-intel
    intel-compute-runtime 
    beignet

    # https://nixos.wiki/wiki/Accelerated_Video_Playback
    intel-media-driver # LIBVA_DRIVER_NAME=iHD
    vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
    vaapiVdpau
    libvdpau-va-gl
  ];
}
