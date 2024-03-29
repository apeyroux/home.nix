with import <nixpkgs> {};

{
  programs.mbsync = {
    enable = true;
  };

  services.imapnotify.enable = true;
  home.file.".mailpass-gmail.gpg".source = ../secrets/mailpass-gmail.gpg;

  accounts.email.accounts.gmail = {
    primary = true;
    address = "alex@px.io";
    flavor = "gmail.com";
    passwordCommand = "${gnupg}/bin/gpg2 -q --for-your-eyes-only --no-tty -d ~/.mailpass-gmail.gpg";
    mu.enable = true;
    imapnotify = {
      enable = true;
      boxes = ["Inbox" "Famille"];
      onNotifyPost = {
        mail = "${libnotify}/bin/notify-send 'Nouveau mail alex@px.io !'";
      };
      onNotify = "${isync}/bin/mbsync -a";
    };
    msmtp = {
      enable = true;
    };
    mbsync = {
      enable = true;
      create = "both";
      patterns = ["*" "![Gmail]/Spam"];
      extraConfig.remote = {
        UseNamespace = "no";
      };
    };
  }; 
}
