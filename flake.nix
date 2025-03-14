{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell rec {
            nativeBuildInputs = with pkgs; [
              mise
              # python313
              # uv
              # cilium-cli
              # cloudflared
              # cue
              # age
              # sops
              # fluxcd
              # go-task
              # kubernetes-helm
              # helmfile
              # jq
              # kustomize
              # yq-go
              # kubeconform
              # makejinja
              # python313Packages.netaddr
              dig
              kdash
            ];
            buildInputs = nativeBuildInputs;
          };
        }
      );
    };
}
