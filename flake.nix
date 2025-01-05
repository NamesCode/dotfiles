{
  description = "Name's Nix system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvame.url = "github:namescode/nvame";
  };

  outputs =
    {
      self,
      nixpkgs,
      nvame,
      ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in
    {
      # Dev env stuff
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            default = pkgs.mkShell {
              nativeBuildInputs = with pkgs; [
                bash-language-server
              ];

              shellHook = ''echo "Welcome to the bloatation station! :D"'';
            };
          };
        }
      );

      # System configs
      nixosConfigurations.navi =
        let
          system = "aarch64-linux";
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit inputs;
          };
          modules = [
            ./systems/navi/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.nvame.nixosModules.nvame
          ];
        };

      # ISO installer configs
      nixosConfigurations.asahi-zfs = forAllSystems (
        system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = import inputs.nixpkgs {
            crossSystem.system = "aarch64-linux";
            localSystem.system = system;
            overlays = [
              (import ./modules/apple-silicon-support/packages/overlay.nix)
            ];
          };

          specialArgs = {
            modulesPath = inputs.nixpkgs + "/nixos/modules";
          };

          modules = [
            ./installers/asahi-zfs.nix
            ./modules/apple-silicon-support
            { hardware.asahi.pkgsSystem = system; }
          ];
        }
      );
    };
}
