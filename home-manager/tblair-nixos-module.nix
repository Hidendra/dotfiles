{ inputs, lib, pkgs, ... }: {
  imports = [ ./vim.nix ./zsh.nix ];

  home = {
    username = "tblair";
    homeDirectory = "/home/tblair";
    packages = builtins.attrValues { inherit (pkgs) jq ripgrep; };
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

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
