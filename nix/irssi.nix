with import <nixpkgs> {};

let 

  irssi-password = builtins.readFile ../secrets/irssi.password;

in {
  programs.irssi = {
    enable = true;
    extraConfig = ''
ignores = (
  {
    level = "JOINS PARTS QUITS NICKS";
    channels = (
      "#nixos",
      "#haskell",
      "#haskell-fr",
      "#online",
      "#tmux",
      "#nixos-fr"
    );
  }
);
    '';
    networks = {
      freenode = {
        nick = builtins.readFile ../secrets/irssi.freenode.login;
        autoCommands = [
          "/^msg nickserv identify ${irssi-password};wait 10000"
        ];
        server = {
          address = "chat.freenode.net";
          port = 6697;
          autoConnect = true;
          ssl.verify = false;
        };
        channels = {
          nixos.autoJoin = true;
          nixos-fr.autoJoin = true;
          haskell.autoJoin = true;
          haskell-fr.autoJoin = true;
          tmux.autoJoin = true;
        };
      };
      online = {
        nick = builtins.readFile ../secrets/irssi.online.login;
        server = {
          address = "irc.online.net";
          port = 6697;
          autoConnect = true;
          ssl.verify = false;
        };
        channels = {
          online.autoJoin = true;
        };
      };
    };
  };
}
