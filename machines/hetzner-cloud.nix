{
  modulesPath,
  lib,
  pkgs,
  inputs,
  currentSystem,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;
  services.unifi.enable = true;
  services.unifi.unifiPackage = pkgs.unifi8;
  services.unifi.mongodbPackage = pkgs.mongodb-5_0;
  services.nginx = {
    enable = true;
    virtualHosts.localhost = {
      locations."/" = {
        return = "200 '<html><body>It works</body></html>'";
        extraConfig = ''
          default_type text/html;
        '';
      };
    };
    virtualHosts."piftel.bitsikas.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        return = "200 '<html><body>It works</body></html>'";
        extraConfig = ''
          default_type text/html;
        '';
      };
    };
    virtualHosts."pdf.piftel.bitsikas.dev" = {
      enableACME = true;
      forceSSL = true;
      root = "${inputs.pdfblanks.outputs.packages.${currentSystem}.html}";
    };
  };
security.acme.acceptTerms = true;
security.acme.certs = {
  "piftel.bitsikas.dev".email = "piftel@bitsikas.dev";
  "pdf.piftel.bitsikas.dev".email = "piftel@bitsikas.dev";
};

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINRASEE/kkq/U/MKRyN+3OTEofM7FgACxLzvuT/NtTWP "

  ];
  nixpkgs.hostPlatform = lib.mkDefault currentSystem;

  networking.useDHCP = lib.mkDefault true;
  system.stateVersion = "24.05";
  networking.firewall = {
    allowedTCPPorts = [ 80 443];
  };
}
