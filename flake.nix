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
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ] (system: function nixpkgs.legacyPackages.${system});
    in
    {
      # Dev env stuff
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            bash-language-server
          ];

          shellHook = ''echo "Welcome to the bloatation station!"'';
        };
      });

      # System configs
      nixosConfigurations.navi =
        let
          system = "aarch64-linux";
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./systems/navi/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            { nixpkgs.hostPlatform = system; }
          ];
        };

      # Servers
      nixosConfigurations.melchior =
        let
          system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./systems/magi/melchior/configuration.nix
            { nixpkgs.hostPlatform = system; }
          ];
        };

      # ISO installer configs
      asahi-zfs-iso = self.nixosConfigurations.asahi-zfs.config.system.build.isoImage;
      nixosConfigurations.asahi-zfs =
        let
          system = "aarch64-linux";
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            modulesPath = inputs.nixpkgs + "/nixos/modules";
          };

          modules = [
            ./installers/asahi-zfs.nix
            ./modules/apple-silicon-support
            { hardware.asahi.pkgsSystem = system; }

            {
              nixpkgs = {
                # WARN: Do NOT change the crossSystem
                crossSystem.system = "aarch64-linux";
                localSystem.system = system;
                overlays = [
                  (import ./modules/apple-silicon-support/packages/overlay.nix)
                ];
              };
            }
          ];
        };
    };
}
