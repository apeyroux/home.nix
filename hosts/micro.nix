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
  
in {

  imports = [ 
    ../nix/common.nix 
    ../nix/code.nix
    ../nix/irssi.nix
    ../nix/emacs.nix
    ../nix/gmail.nix
    ../nix/protonmail.nix
    ../nix/rclone.nix
  ];

  home.packages = [
    # docker-compose
    # insync
    firefox
    git-crypt
    google-chrome
    libreoffice
    lsof
    mitmproxy
    # molotov
    mtr
    mutt 
    pcmanfm
    scrot
    # tresorit-impure
    wireshark
    yubioath-desktop
  ];
}
