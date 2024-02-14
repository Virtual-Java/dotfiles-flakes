{ config, pkgs, lib, inputs, modulesPath, ... }: {
  zfs-root = {
    boot = {
      devNodes = "/dev/disk/by-id/";
      bootDevices = [  "bootDevices_placeholder" ];
      immutable.enable = false;
      removableEfi = true;
      luks.enable = true;
    };
  };
  boot.initrd.availableKernelModules = [  "kernelModules_placeholder" ];
  boot.kernelParams = [ ];
  networking.hostId = "hostID_placeholder";
  # read changeHostName.txt file.
  networking.hostName = "hostName_placeholder";
  time.timeZone = "timeZone_placeholder";

  # import preconfigured profiles
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # (modulesPath + "/profiles/hardened.nix")
    # (modulesPath + "/profiles/qemu-guest.nix")
  ];
}
