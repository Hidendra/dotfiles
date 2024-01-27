{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosModule = {
      home-manager.users.tblair = { ... }: {
        imports = [ ./home-manager/tblair-nixos-module.nix ];
      };
    };

    homeConfigurations = {
      # home-manager switch --flake .#tblair-home-desktop
      tblair-home-desktop = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home-manager/tblair-home-desktop.nix ];
      };

      # home-manager switch --flake .#tblair-work-laptop
      tblair-work-laptop = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home-manager/tblair-work-laptop.nix ];
      };
    };
  };
}
