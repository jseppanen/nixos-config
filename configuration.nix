{ config, pkgs, currentSystem, ... }:

{
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_16;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    # Define your hostname.
    hostName = "dev";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;

    # QEMU and linux 5.15 guest has given me at least enp0s9 & enp0s10
    # usePredictableInterfaceNames = false;
    interfaces.eth0.useDHCP = true;
    interfaces.enp0s9.useDHCP = true;
    interfaces.enp0s10.useDHCP = true;

    # Disable the firewall since we're in a VM and we want to make it
    # easy to visit stuff in here. We only use NAT networking anyways.
    firewall.enable = false;
  };

  # use unstable nix so we can access flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
   };

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  nixpkgs.overlays = import ./lib/overlays.nix ++ [
    # (import ./users/jarno/vim.nix)
  ];

  hardware.opengl = {
    enable = true;
    package = (pkgs.mesa.override {
      galliumDrivers = [ "virgl" "swrast" ];
      vulkanDrivers = [ ];
      enableGalliumNine = false;
      enableOSMesa = false;
      enableOpenCL = false;
    }).drivers;
  };

  # We expect to run the VM on hidpi machines.
  hardware.video.hidpi.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Virtualization settings
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    # font = "Lat2-Terminus16";
    keyMap = "fi";
  };

  # copy-paste & file sharing in QEMU
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # https://discourse.nixos.org/t/qemu-guest-agent-on-hetzner-cloud-doesnt-work/8864
  # systemd.services.qemu-guest-agent.path = [ pkgs.shadow ];

  # setup windowing environment
  services.xserver = {
    enable = true;
    layout = "fi";
    dpi = 192;
    xkbOptions = "eurosign:e";

    # Enable touchpad support
    libinput.enable = true;

    videoDrivers = [ "virgl" ];

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "scale";
    };

    displayManager = {
      defaultSession = "none+awesome";
      lightdm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "jarno";

      # AARCH64: For now, on Apple Silicon, we must manually set the
      # display resolution. This is a known issue with VMware Fusion.
      sessionCommands = ''
        ${pkgs.xlibs.xset}/bin/xset r rate 200 40
      '' + (if currentSystem == "aarch64-linux" then ''
        ${pkgs.xorg.xrandr}/bin/xrandr -s '1920x1440'
      '' else "");
    };

    windowManager.awesome = {
      enable = true;

      # luaModules = with pkgs.luaPackages; [
      #   luarocks # is the package manager for Lua modules
      #   luadbi-mysql # Database abstraction layer
      # ];
    };
  };

  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.jarno = {
    isNormalUser = true;
    home = "/home/jarno";
    extraGroups = [ "docker" "libvirtd" "wheel" ];
    shell = pkgs.fish;
    uid = 1000;
    hashedPassword = "$6$iQ/uBluSQBD8Z3vt$XKTs8t5yjCZqnrYTFAvBbHMV2Fa01FI6KRiidXQkukZh8tNvlwfvFlXwNAuqlD9eYu.eBGxx7ryCh9sb1MrFt/";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwbV7oYGoWQdwyANhiiupqNrAAV5+4+W9Q9xULClLFh jarno"
    ];
  };

  # Manage fonts. We pull these from a secret directory since most of these
  # fonts require a purchase.
  fonts = {
    fontDir.enable = true;

    fonts = [
      pkgs.fira-code
      pkgs.hack-font
      (pkgs.nerdfonts.override {
        fonts = [ "FiraCode" "Hack" ];
      })
    ];
  };

  # Share our host filesystem
  # fileSystems."/host" = {
  #   fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
  #   device = ".host:/";
  #   options = [
  #     "umask=22"
  #     "uid=1000"
  #     "gid=1000"
  #     "allow_other"
  #     "auto_unmount"
  #     "defaults"
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    killall
    qemu-utils
    rxvt_unicode
    vim
    xclip

    # UTM on M1 doesn't support automatic resizing
    # (2160 pixel height is without the notch)
    (writeShellScriptBin "xrandr-mbp" ''
      xrandr --newmode "3456x2160"  642.00  3456 3744 4120 4784  2160 2163 2169 2237 -hsync +vsync
      xrandr --addmode Virtual-1 "3456x2160"
      xrandr -s "3456x2160"
    '')
    (writeShellScriptBin "xrandr-medium" ''
      xrandr -s "1920x1440"
    '')
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "no";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
