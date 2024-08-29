  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.cnijfilter2 
    pkgs.gutenprint
    pkgs.gutenprintBin
    pkgs.hplip
  ];

