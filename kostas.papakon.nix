{ config, pkgs, lib, nixpkgs-unstable, ... }: {

  home.username = "Kostas.Papakon";
  home.homeDirectory = "/Users/Kostas.Papakon";
  #programs.neovim.package = nixpkgs-unstable.neovim-unwrapped;

  imports = [ ./cli.nix ./home.nix kitty/kitty.nix ];

}

