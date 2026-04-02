{
  description = "Gazebosim overlay for the Nix package manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };
  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      lib = nixpkgs.lib;
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem = f: lib.genAttrs allSystems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs allSystems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.permittedInsecurePackages = [
            "freeimage"
            "freeimage-unstable-2021-11-01"
            "freeimage-3.18.0-unstable-2024-04-18"
          ];

          overlays = [
            # self.overlays.modifications
            self.overlays.default
          ];
        }
      );
      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = forEachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      inherit lib;
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      legacyPackages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      # Formatter for your nix files, available through 'nix fmt'
      formatter = forEachSystem (
        pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper
      );
      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # checks
      # checks = self.legacyPackages;

      # dev shells
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      meta = {
        license = nixpkgs.lib.licenses.mit;
      };
    };
}
