{ inputs, lib, pkgs, ... }: {
  imports = [ ./vim.nix ./zsh.nix ];

  home = {
    username = "tblair";
    homeDirectory = "/Users/tblair";
    packages =
      builtins.attrValues { inherit (pkgs) nixfmt jq htop ripgrep python312; };
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
    rebuild = "home-manager switch --flake .#tblair-home-m1-laptop";
  };

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
