{ config, pkgs, ... }:

{
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_0;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "0";
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

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  nixpkgs.overlays = import ./lib/overlays.nix ++ [
    # (import ./users/jarno/vim.nix)
  ];

  # disable VirGL for now
  # hardware.opengl = {
  #  enable = true;
  #  package = (pkgs.mesa.override {
  #    galliumDrivers = [ "virgl" "swrast" ];
  #    vulkanDrivers = [ ];
  #    enableGalliumNine = false;
  #    enableOSMesa = false;
  #    enableOpenCL = false;
  #  }).drivers;
  # };
  environment.variables.LIBGL_ALWAYS_SOFTWARE = "1";

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

  # copy-paste in QEMU
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  # services.spice-webdavd.enable = true;

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
      sessionCommands = ''
        ${pkgs.spice-vdagent}/bin/spice-vdagent
        ${pkgs.xorg.xset}/bin/xset r rate 200 40
      '';
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

  # Manage fonts.
  fonts.fonts = [
    pkgs.fira-code
    pkgs.font-awesome   # for Awesome graybow theme
    pkgs.hack-font
    pkgs.terminus_font  # for Awesome graybow theme
    (pkgs.nerdfonts.override {
      fonts = [ "FiraCode" "Hack" ];
    })
  ];

  # VirtFS directory sharing
  fileSystems."/mac" = {
    fsType = "9p";
    device = "share";
    options = [
      "trans=virtio"
      "version=9p2000.L"
      "msize=104857600"
      "noatime"
      "nofail"
      "defaults"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    killall
    qemu-utils
    rxvt_unicode
    vim
    xclip
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
  system.stateVersion = "22.11"; # Did you read the comment?
}
