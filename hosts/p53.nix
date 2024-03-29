with import <nixpkgs> {};

let 

  xmobar-sync-status = import (builtins.fetchGit {
    url = "https://github.com/apeyroux/xmobar-sync-status.git";
  });

  molotov = import (builtins.fetchGit {
    url = "https://github.com/apeyroux/molotov.nix.git";
  });

  tresorit-impure = import (builtins.fetchGit {
    url = "https://github.com/apeyroux/tresorit.nix";
  });
  
  uplink-tardigrade = import (builtins.fetchGit {
    url = "https://github.com/apeyroux/uplink-tardigrade.nix";
  });
  
  criptext = import (builtins.fetchGit {
    url = "https://github.com/apeyroux/criptext.nix.git";
  });

in {

  imports = [ 
    # ../nix/protonmail.nix
    ../nix/code.nix
    ../nix/common.nix 
    ../nix/emacs.nix
    # ../nix/fastmail.nix
    ../nix/icloud.nix
    ../nix/gnome.nix
    ../nix/irssi.nix
    ../nix/rclone.nix
    ../nix/xmonad.nix
  ];

  home.file.".ssh/config".source = ../secrets/ssh_config_p53;
  home.file.".xmobarrc".source = ../dotfiles/xmobarrc-p53;
  home.file.".Xresources".source = ../dotfiles/Xresources-p53;
  home.file.".config/kitty/kitty.conf".source = ../dotfiles/kitty.conf;
  home.file.".config/autorandr/desk/postswitch".source = ../dotfiles/autorandr/desk/postswitch;
  home.file.".config/autorandr/mobile/preswitch".source = ../dotfiles/autorandr/desk/preswitch;
  home.file.".config/autorandr/mobile/postswitch".source = ../dotfiles/autorandr/mobile/postswitch;
  # w_scan -c FR -X > tv.conf
  home.file.".config/tv-paris.conf".source = ../dotfiles/tv-paris.conf;

  home.packages = [
    # criptext
    # docker-compose
    # spotify
    # tresorit-impure
    # uplink-tardigrade
    signal-desktop
    evince
    firefox
    git-crypt
    google-chrome
    inkscape
    insync
    libreoffice
    lsof
    mitmproxy
    # molotov
    mtr
    mutt 
    nvtop
    pcmanfm
    scrot
    wireshark
    # xmobar-sync-status
    yubioath-desktop
  ];

  services = {
    hound = {
      enable = false;
      repositories = {
        aiomda = {
          url = "https://code.minsi.fr/mce/aiomda.git";
          ms-between-poll = 10000;
          exclude-dot-files = true;
        };
        nixpkgs = {
          url = "https://github.com/NixOS/nixpkgs.git";
          ms-between-poll = 10000;
          exclude-dot-files = true;
        };
        dev-cyrus-krb = {
          url = "https://code.minsi.fr/mce/dev-cyrus-kerberos.git";
          ms-between-poll = 10000;
          exclude-dot-files = true;
        };
      };
    };
  };

}
