{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Add any other flake you might need
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-unstable,
    home-manager,
    lanzaboote,
    nixos-hardware,
    ...
  } @ inputs: let
    inherit (self) outputs;
    sharedConfig = hostname: nsystem:
      nixpkgs.lib.nixosSystem {
        system = nsystem;
        specialArgs = {
          lanzaboote = lanzaboote.nixosModules.lanzaboote;
          inherit inputs outputs;
          inherit hostname;
          hardware = nixos-hardware.nixosModules;
        };
        modules = [
          ./configuration.nix
          ./hw/${hostname}.nix

          {
            nixpkgs.overlays = [
              (final: prev: {
                unstable = import nixpkgs-unstable {
                  system = nsystem;
                  config.allowUnfree = true;
                };
              })

              (final: prev: {
                stable = import nixpkgs-stable {
                  system = nsystem;
                  config.allowUnfree = true;
                };
              })
            ];
          }
        ];
      };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      xps = sharedConfig "xps" "x86_64-linux";
      box = sharedConfig "box" "x86_64-linux";
      nix-vm = sharedConfig "nix-vm" "x86_64-linux";
    };
  };
}
