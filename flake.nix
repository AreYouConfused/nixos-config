{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    lanzaboote,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      nix-vm = nixpkgs.lib.nixosSystem {
        # > Our main nixos configuration file <
        modules = [
          ./configuration.nix
          ./hw/vm.nix
        ];
        specialArgs = {
          inherit inputs outputs;
          hostname = "nix-vm";
        };
      };
      xps = nixpkgs.lib.nixosSystem {
        # > Our main nixos configuration file <
        modules = [
          ./configuration.nix
          ./hw/xps.nix
          lanzaboote.nixosModules.lanzaboote
          ./hw/secboot.nix
        ];
        specialArgs = {
          inherit inputs outputs;
          hostname = "xps";
        };
      };
    };
  };
}
