with import <nixpkgs> {};

{
  programs.mbsync = {
    enable = true;
  };

  services.imapnotify.enable = true;
  home.file.".mailpass-icloud.gpg".source = ../secrets/mailpass-icloud.gpg;

  accounts.email.accounts.icloud = {
    primary = true;
    flavor = "plain";
    address = "alex@px.io";
    realName = "Alexandre Peyroux";
    userName = "peyroux";
    passwordCommand = "${gnupg}/bin/gpg2 -q --for-your-eyes-only --no-tty -d ~/.mailpass-icloud.gpg";
    mu.enable = true;
    imapnotify = {
      enable = true;
      boxes = ["Inbox"];
      onNotifyPost = {
        mail = "${libnotify}/bin/notify-send 'Nouveau mail alex@px.io !'";
      };
      onNotify = "${isync}/bin/mbsync -a";
    };
    msmtp = {
      enable = true;
    };
    imap = {
      host = "imap.mail.me.com";
      port = 993;
      # tls.useStartTls = true;
    };
    smtp = {
      host = "smtp.mail.me.com";
      port = 587;
      tls.useStartTls = true;
    };
    gpg = {
        key = "E29E9DCBB3FD297DCCF9D574A4BD77DD1421E5CF";
        signByDefault = true;
      };
    mbsync = {
      enable = true;
      create = "both";
      patterns = ["*"];
      extraConfig.remote = {
        UseNamespace = "no";
      };
    };
  }; 
}
