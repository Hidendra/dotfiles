{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./vim.nix
    ./zsh.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "tblair";
    homeDirectory = "/home/tblair";
    packages = builtins.attrValues { inherit (pkgs) nixfmt ripgrep python312; };
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.gpg.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      zsh
    '';
  };

  programs.zsh.shellAliases = {
    rebuild = "home-manager switch --flake .#'tblair-home-desktop'";
  };

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
