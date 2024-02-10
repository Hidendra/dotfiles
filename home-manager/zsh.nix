

{ ... }: {
  programs.eza.enable = true;

  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;
    history = {
      # ${config.xdg.dataHome}
      path = "$HOME/.local/share/zsh/history";
      save = 100000;
      size = 100000;
      share = true;
      ignoreAllDups = true;
    };
    shellAliases = {
      nixd = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
      reload = "exec zsh";
      ls = "eza --long --group --all --group-directories-first";
      lr = "eza --long --group --tree --level 3 --group-directories-first";
      lR = "eza --long --group --tree --group-directories-first";
      nixgc = "nix-collect-garbage -d";
    };
    oh-my-zsh = {
      enable = true;
      theme = "lukerandall";
      plugins = [ "git" ];
    };
    # initExtra = builtins.readFile ./zshrc;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
  };

  programs.z-lua = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
  };
}
