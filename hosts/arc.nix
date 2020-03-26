with import <nixpkgs> {};

let 

in {

  imports = [ 
    ../nix/common.nix 
    ../nix/irssi.nix
    ../nix/emacs.nix
    ../nix/gmail.nix
    ../nix/protonmail.nix
    ../nix/rclone.nix
  ];

  home.packages = [
    c14
    youtube-dl
    xsel
  ];

}
