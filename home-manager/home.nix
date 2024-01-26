# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "tblair";
    homeDirectory = "/home/tblair";
    packages = builtins.attrValues { inherit (pkgs) nixfmt ripgrep; };
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  programs.home-manager.enable = true;
  programs.git.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      zsh
    '';
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      nixd = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
      rebuild = "home-manager switch --flake .#'tblair@home'";
      ls = "eza --long --group --group-directories-first";
      la = "eza --long --group --group-directories-first";
      lr = "eza --long --group --tree --level 3 --group-directories-first";
      lR = "eza --long --group --tree --group-directories-first";
      nixgc = "nix-collect-garbage -d";
    };
    oh-my-zsh = {
      enable = true;
      theme = "lukerandall";
    };
    # initExtra = builtins.readFile ./zshrc;
  };

  programs.eza.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
    settings = {
      copyindent = true;
      expandtab = true;
      hidden = true;
      history = 100;
      mouse = "a";
      number = true;
    };
    extraConfig = ''
      filetype plugin indent on
      syntax on

      set backspace=indent,eol,start
      set ruler
      set display=truncate
      set incsearch
      set nrformats-=octal
      set mouse=a
    '';
  };

  programs.z-lua = {
    enable = true;
    enableZshIntegration = true;
  };

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
