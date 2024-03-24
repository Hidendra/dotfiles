{ inputs, lib, pkgs, ... }: {
  imports = [ ./vim.nix ./zsh.nix ];

  home = {
    username = "tblair";
    homeDirectory = "/home/tblair";
    packages = builtins.attrValues {
      inherit (pkgs)
        jq
        microsoft-edge
        nixfmt
        python312
        ripgrep

        # yt-dlp and its dependencies
        yt-dlp aria ffmpeg

      ;
    };
  };

  # needed for microsoft-edge
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.gpg.enable = true;

  programs.yt-dlp = {
    enable = true;
    settings = {
      cookies-from-browser = "edge";
      embed-metadata = true;
      embed-chapters = true;
      embed-info-json = true;
      embed-thumbnail = true;
      embed-subs = true;
      write-thumbnail = true;
      sub-langs = "all";
      downloader = "aria2c";
      downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
      # Normal videos -- keep videos separated by uploader
      output = "/home/tblair/ytdlp/%(uploader)s/%(title)s.%(ext)s";
      # Playlists -- order videos by playlist
      # output = "/home/tblair/ytdlp/%(uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s";
    };
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      zsh
    '';
  };

  programs.zsh.shellAliases = {
    rebuild = "home-manager switch --flake .#tblair-home-desktop";
    yt-dlp-video = "yt-dlp --output '/home/tblair/ytdlp/%(uploader)s/%(title)s.%(ext)s'";
    yt-dlp-playlist = "yt-dlp --output '/home/tblair/ytdlp/%(uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'";
  };

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
