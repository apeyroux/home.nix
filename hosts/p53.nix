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
    ../nix/common.nix 
    ../nix/xmonad.nix
    ../nix/gnome.nix
    ../nix/code.nix
    ../nix/irssi.nix
    ../nix/emacs.nix
    ../nix/gmail.nix
    # ../nix/protonmail.nix
    ../nix/rclone.nix
  ];

  home.file.".xmobarrc".source = ../dotfiles/xmobarrc-p53;
  home.file.".Xresources".source = ../dotfiles/Xresources-p53;
  home.file.".config/kitty/kitty.conf".source = ../dotfiles/kitty.conf;
  home.file.".config/autorandr/desk/postswitch".source = ../dotfiles/autorandr/desk/postswitch;
  home.file.".config/autorandr/mobile/preswitch".source = ../dotfiles/autorandr/desk/preswitch;
  home.file.".config/autorandr/mobile/postswitch".source = ../dotfiles/autorandr/mobile/postswitch;

  home.packages = [
    # criptext
    # docker-compose
    spotify
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
    molotov
    mtr
    mutt 
    nvtop
    pcmanfm
    scrot
    wireshark
    xmobar-sync-status
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
