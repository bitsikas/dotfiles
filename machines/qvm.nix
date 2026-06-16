{
  lib,
  config,
  pkgs,
  nixpkgs-unstable,
  inputs,
  ...
}: {
  imports = [];

  myFeatures.desktop = true;
  home-manager.users.root.myFeatures.desktop = true;
  nix = {
    settings.auto-optimise-store = true;
    package = pkgs.nixVersions.stable; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  # this takes a lot of time sometimes
  documentation.man.generateCaches = false;
  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["all"];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = true;

  environment.systemPackages = with pkgs; [
    curl
  ];

  # programs.light.enable = true;
  # programs.nix-ld = {
  #   enable = true;
  #   libraries = [

  #   ];
  # };

  programs.command-not-found.enable = false;
  # for home-manager, use programs.bash.initExtra instead
  # programs.bash.interactiveShellInit = ''
  #   source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
  # '';

  programs.nix-index-database.comma.enable = true;
  programs.nix-index.enableFishIntegration = true;

  environment.pathsToLink = ["/libexec"];

  programs.fish.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  networking.hostName = "my-microvm";
  networking.useDHCP = true;
  users.users.root.password = "root"; # Don't use in production!
  services.getty.autologinUser = "root";
  microvm = {
    interfaces = [
      {
        type = "user";
        id = "usernet";
        mac = "02:00:00:01:00:01";
      }
    ];
    volumes = [
      {
        mountPoint = "/var";
        image = "var.img";
        size = 256;
      }
    ];
    shares = [
      {
        proto = "9p";
        tag = "ro-pi";
        source = "/home/kostas/.pi";
        mountPoint = "/root/.pi";
        readOnly = true;
      }
      {
        proto = "9p";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        readOnly = true;
      }
    ];

    # "qemu" has 9p built-in!
    hypervisor = "qemu";
    socket = "control.socket";
    extraArgsScript = "${pkgs.writeShellScript "extra-args" ''
      if [ -n "''${QVM_SHARE:-}" ]; then
        echo "-fsdev local,id=fs99,path=$QVM_SHARE,security_model=mapped -device virtio-9p-pci,fsdev=fs99,mount_tag=ondemand"
      fi
    ''}";
  };
}
