{ flake, config, pkgs, ... }:

{
  imports = [
    ./modules/minimal.nix
    ./modules/home.nix
    ./modules/sf.nix
    ./modules/nvim
  ];

  home.stateVersion = "23.11";

  home = {
    username = "vladislavwohlrath";
    homeDirectory = "/Users/vladislavwohlrath";
  };

  home.shellAliases = {
    e = "nvim";
    rebuild = "darwin-rebuild switch --flake git+file:/etc/nixos#darwin";
    deploy-kulich = "nixos-rebuild switch --fast --flake git+file:/etc/nixos#kulich --build-host root@kulich --target-host root@kulich";

    v = ". ~/venv/bin/activate";
    V = "deactivate";
    t = "nix flake init --template";
  };


  programs.ssh.extraConfig = ''
    Host kulich
        User vladidobro
        HostName 37.205.14.94
        IdentityFile ~/.ssh/id_private

    Host github.com
        IdentityFile ~/.ssh/id_private

    Host *
        IdentityFile ~/.ssh/id_rsa
  '';

  home.packages = with pkgs; [
    nixos-rebuild
    qemu
    cachix

    nodePackages_latest.pyright
    poetry
    (python3.withPackages (ps: with ps; [ pip ]))
    ruff

    rust-analyzer
  ];
}
