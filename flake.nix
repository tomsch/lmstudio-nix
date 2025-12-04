{
  description = "LM Studio - Discover, download, and run local LLMs";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      packages.${system} = {
        default = pkgs.callPackage ./package.nix {};
        lmstudio = self.packages.${system}.default;
      };

      overlays.default = final: prev: {
        lmstudio = final.callPackage ./package.nix {};
      };
    };
}
