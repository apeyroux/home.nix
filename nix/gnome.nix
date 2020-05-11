with import <nixpkgs> {};

{
  home.file.".config/user-dirs.dirs".source = ../dotfiles/user-dirs.dirs;
  home.packages = [
    gnomeExtensions.appindicator
    gnome3.gnome-tweaks
  ];
}
