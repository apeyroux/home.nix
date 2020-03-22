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
    ../nix/code.nix
    ../nix/irssi.nix
    ../nix/emacs.nix
    ../nix/gmail.nix
    ../nix/rclone.nix
  ];

  home.file.".xmobarrc".source = ../dotfiles/xmobarrc-xps15;

  home.packages = [
    # criptext
    # docker-compose
    # insync
    evince
    firefox
    git-crypt
    google-chrome
    libreoffice
    lsof
    mitmproxy
    molotov
    mtr
    mutt 
    pcmanfm
    scrot
    # spotify
    # tresorit-impure
    uplink-tardigrade
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
