# configuration in this file is shared by all hosts

{ pkgs, pkgs-unstable, inputs, ... }:
let inherit (inputs) self;
  nix-software-center = import (pkgs.fetchFromGitHub {
    owner = "snowfallorg";
    repo = "nix-software-center";
    rev = "0.1.2";
    sha256 = "xiqF1mP8wFubdsAQ1BmfjzCgOD3YZf7EGWl9i69FTls=";
  }) {};
in


{
  # Enable NetworkManager for wireless networking,
  # You can configure networking with "nmtui" command.
  networking.useDHCP = true;
  networking.networkmanager.enable = false;

  users.users = {
    root = {
      initialHashedPassword = "$6$.JCPZBhKIZIZhPwC$w380mHIfpRlA.4Oyg680mFjVikJz40MO/TAe7EfyVcglSa.aa538WCshgOrFQgPATOlTtyU0E7DjORTe9Q7BQ/";
      openssh.authorizedKeys.keys = [ "sshKey_placeholder" ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cordula = {
    isNormalUser = true;
    description = "Cordula";
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" ];
    #openssh.authorizedKeys.keys = [ "ssh-dss AAABBNRT... adminvetter@hostsysname" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  users.groups.cordula.gid = 1000;

  # languge
  i18n.defaultLocale = "de_DE.UTF-8";
#  i18n.extraLocaleSettings = {
#    LC_MESSAGES = "en_US.UTF-8";
#    LC_TIME = "de_DE.UTF-8";
#    defaultLocale = "de_DE.UTF-8";
#    LANG = "de_DE.UTF-8";
#    supportedLocales = "de_DE.UTF-8";
##    LC_ALL = "de_DE.UTF-8";
#    #LC_MESSAGES=en_US.UTF-8
#    #LC_TIME=de_DE.UTF-8
#    #defaultLocale=en_US.UTF-8
#  };

  ## enable GNOME desktop.
  ## You need to configure a normal, non-root user.
  # services.xserver = {
  #  enable = true;
  #  desktopManager.gnome.enable = true;
  #  displayManager.gdm.enable = true;
  # };

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
#    displayManager.sddm.enable = true;
#    desktopManager.plasma5.enable = true;
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  ## enable ZFS auto snapshot on datasets
  ## You need to set the auto snapshot property to "true"
  ## on datasets for this to work, such as
  # zfs set com.sun:auto-snapshot=true rpool/nixos/home
  services.zfs = {
    autoSnapshot = {
      enable = false;
      flags = "-k -p --utc";
      monthly = 48;
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  services.openssh = {
    enable = true;
    settings = { PasswordAuthentication = false; };
  };

  boot.zfs.forceImportRoot = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.initrd.systemd.enable = true;

  programs.git.enable = true;

  security = {
    doas.enable = true;
    sudo.enable = true;
  };

  # SoloKeys:
   programs.gnupg.agent = {
       enable = true;
       enableSSHSupport = true;
   };
#   security.pam.services = {
#       login.u2fAuth = true;
#       sudo.u2fAuth = true;
#   };
#   # https://github.com/solokeys/solo2-cli/blob/main/70-solo2.rules
#   services.udev.packages = [
#       pkgs.yubikey-personalization
#       (pkgs.writeTextFile {
#       name = "wally_udev";
#       text = 
#           # NXP LPC55 ROM bootloader (unmodified)
#           SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0021", TAG+="uaccess"
#           # NXP LPC55 ROM bootloader (with Solo 2 VID:PID)
#           SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="b000", TAG+="uaccess"
#           # Solo 2
#           SUBSYSTEM=="tty", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="beee", TAG+="uaccess"
#           # Solo 2
#           SUBSYSTEM=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="beee", TAG+="uaccess"
#       ;
#       destination = "/etc/udev/rules.d/70-solo2.rules";
#       })
#   ];


  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      mg # emacs-like editor
      jq # other programs
      vim
      wget

      keepassxc

      firefox
      thunderbird
      libreoffice

      librecad
      freecad

      gimp
      inkscape
#      converseen # not found
      jhead
      exiftool

      htop

#      kicad
#      freecad
#      cura
#      ghostwriter
#      librecad

#      kile
#      texlive

      #https://github.com/phrogg/solokey-full-disk-encryption
      fido2luks
      cargo
      cmake
      gnumake
      clang

      docker
    ;
    # By default, the system will only use packages from the
    # stable channel. i.e.
    # inherit (pkg) my-favorite-stable-package;
    # You can selectively install packages
    # from the unstable channel. Such as
    # inherit (pkgs-unstable) my-favorite-unstable-package;
    # You can also add more
    # channels to pin package version.

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    #  nix-software-center
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  };

  # Safety mechanism: refuse to build unless everything is
  # tracked by git
  system.configurationRevision = if (self ? rev) then
    self.rev
  else
    throw "refuse to build: git tree is dirty";

  system.stateVersion = "23.11";

  # let nix commands follow system nixpkgs revision
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  # you can then test any package in a nix shell, such as
  # $ nix shell nixpkgs#neovim
}
