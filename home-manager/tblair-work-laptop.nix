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
    sessionVariables = {
      # Don't forward the display for now
      DISPLAY = "";
    };
    packages = builtins.attrValues { inherit (pkgs) azure-cli awscli2 nixfmt ripgrep python312; };
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.gpg.enable = true;

  programs.bash = {
    enable = true;
    profileExtra = ''
      # Exit out when running from the dummy persistent systemd session
      # This extra session races for who creates the gpg/ssh socket tunnels
      # See: https://github.com/microsoft/WSL/issues/9817#issuecomment-1563056025
      if [[ -n "''${XDG_SESSION_ID}" && "''${TERM}" == "dumb" && "$(ps -p $PPID -o comm=)" == "login" ]]; then
          # Running in the background login process. Do nothing.
          return
      fi
    '';
    initExtra = ''
      # SSH Socket
      # Removing Linux SSH socket and replacing it by link to wsl2-ssh-pageant socket
      # See: https://github.com/BlackReloaded/wsl2-ssh-pageant#bashzsh
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.sock"
      if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
        rm -f "$SSH_AUTH_SOCK"
        wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
        if test -x "$wsl2_ssh_pageant_bin"; then
          (setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin" >/dev/null 2>&1 &)
        else
          echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
        fi
        unset wsl2_ssh_pageant_bin
      fi

      # GPG Socket
      # See: https://github.com/BlackReloaded/wsl2-ssh-pageant#bashzsh
      export GPG_AGENT_SOCK="$(gpgconf --list-dirs socketdir)/S.gpg-agent"
      if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
        rm -rf "$GPG_AGENT_SOCK"
        mkdir -p "$(gpgconf --list-dirs socketdir)"
        wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
        if test -x "$wsl2_ssh_pageant_bin"; then
          (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpgConfigBasepath 'C:/Users/tblair/AppData/Local/gnupg' --gpg S.gpg-agent" >/dev/null 2>&1 &)
        else
          echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
        fi
        unset wsl2_ssh_pageant_bin
      fi

      zsh
    '';
  };

  programs.zsh.shellAliases = {
    rebuild = "home-manager switch --flake .#tblair-work-laptop";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}