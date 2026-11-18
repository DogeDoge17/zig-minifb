{
  description = "Zig bindings and example application for MiniFB";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    pkgsFor = system: import nixpkgs {inherit system;};
  in {
    packages = forAllSystems (
      system: let
        pkgs = pkgsFor system;
      in {
        default = pkgs.stdenv.mkDerivation {
          pname = "zig-minifb";
          version = "0.0.0";
          src = nixpkgs.lib.cleanSource self;

          nativeBuildInputs = [
            pkgs.zig
            pkgs.pkg-config
          ];
          buildInputs = [
            pkgs.libx11
            pkgs.libxkbcommon
          ];

          doCheck = true;

          meta = {
            description = "Zig bindings and example application for MiniFB";
            mainProgram = "zig_minifb";
            platforms = systems;
          };
        };
      }
    );

    checks = forAllSystems (system: {
      default = self.packages.${system}.default;
    });

    devShells = forAllSystems (
      system: let
        pkgs = pkgsFor system;
      in {
        default = pkgs.mkShell {
          inputsFrom = [self.packages.${system}.default];
          packages = [pkgs.wayland pkgs.zls];
        };
      }
    );

    formatter = forAllSystems (system: (pkgsFor system).nixfmt-tree);
  };
}
