{ config, pkgs, lib, inputs, modulesPath, ... }: {
  zfs-root = {
    boot = {
      devNodes = "/dev/disk/by-id/";
      bootDevices = [  "ata-KIOXIA-EXCERIA_SATA_SSD_41LB847NKFZ2" ];
      immutable.enable = false;
      removableEfi = true;
      luks.enable = true;
    };
  };
  boot.initrd.availableKernelModules = [  "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelParams = [ ];
  networking.hostId = "962693f8";
  # read changeHostName.txt file.
  networking.hostName = "exampleHost";
  time.timeZone = "Europe/Berlin";

  # import preconfigured profiles
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # (modulesPath + "/profiles/hardened.nix")
    # (modulesPath + "/profiles/qemu-guest.nix")
  ];
}
