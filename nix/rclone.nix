with import <nixpkgs> {};

{

  home.packages = [
    rclone
  ];

  home.file.".rclone.conf".source = ../dotfiles/rclone.conf;
}
