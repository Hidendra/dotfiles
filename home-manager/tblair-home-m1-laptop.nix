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
    rebuild = "home-manager switch --flake ~/projects/dotfiles#tblair-home-m1-laptop";
    rebuild-darwin = "nix --extra-experimental-features nix-command --extra-experimental-features flakes run nix-darwin -- switch --flake ~/projects/homelab-k8s/nixos-config";
  };

  programs.zsh.initExtra = ''
    # nix-darwin: macOS system updates can break nix installation
    # The workaround is to ensure the nix daemon hook is in the user's zshrc
    # Issue: https://github.com/NixOS/nix/issues/3616
    if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
      source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi

    eval "$(/opt/homebrew/bin/brew shellenv)"
  '';

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
