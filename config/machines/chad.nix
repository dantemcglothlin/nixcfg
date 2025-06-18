{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./chad-hardware.nix
    ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "dante"];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Nexura"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.dante = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video" "audio"];
  };

  security = {
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
    rtkit.enable = true;
    pam.loginLimits = [
       {domain = "@wheel"; item = "nofile"; type = "soft"; value = "524288";}
       {domain = "@wheel"; item = "nofile"; type = "hard"; value = "1048576";}
    ];
  };


  environment.systemPackages = with pkgs; [spotify discord];


  fonts.packages = with pkgs; [ dejavu_fonts ];

  programs.hyprland.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
    WLR_NO_HARDWARE_CURSORS = 1;
    NIX_SHELL_PRESERVE_PROMPT = 1;
  };

  qt = {
    enable = true;
    style = "adwaita-dark";
    platformTheme = "gnome";
  };


  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  nixpkgs.config.pulseaudio = true;

  programs.firefox.enable = true;


  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.dante = {
      imports = [ ../hypr.nix ];
      programs.home-manager.enable = true;

      programs.bash.enable = true;
      programs.git.enable = true;
      programs.neovim.enable = true;
      programs.bemenu.enable = true;
      programs.alacritty.enable = true;
      programs.vscode.enable = true;

      wayland.windowManager.hyprland.enable = true;
      systemd.user.sessionVariables = config.home-manager.users.dante.home.sessionVariables;

      home.pointerCursor = {
        name = "phinger-cursors-dark";
        package = pkgs.phinger-cursors;
        size = 32;
        gtk.enable = true;
      };

      gtk = {
        enable = true;
        theme = { name = "adw-gtk3-dark"; package = pkgs.adw-gtk3; };
      };

      
      home.stateVersion = "24.11";
    };
  };


  system.stateVersion = "24.11";

}

