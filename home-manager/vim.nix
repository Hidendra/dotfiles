{ ... }: {
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

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
