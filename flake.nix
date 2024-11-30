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
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;

      devShells.${system}.default = pkgs.mkShell {
        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            bash-language-server
          ];

          shellHook = ''echo "Welcome to the bloatation station! :D"'';
        };

      };

      nixosConfigurations.navi = nixpkgs.lib.nixosSystem {
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

    };
}
