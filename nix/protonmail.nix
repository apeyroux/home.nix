with import <nixpkgs> {};

{

  home.file.".proton.crt".source = ../files/proton.crt;
  programs.mbsync = {
    enable = true;
  };

  services.imapnotify.enable = true;
  accounts.email.accounts.proton = {
    userName = "alex@px.io";
    primary = true;
    passwordCommand = "${gnupg}/bin/gpg2 -q --for-your-eyes-only --no-tty -d ~/.mailpass-proton.gpg";
    imapnotify = {
      enable = true;
      boxes = ["Inbox" "Famille"];
      onNotifyPost = {
        mail = "${libnotify}/bin/notify-send 'Nouveau mail!'";
      };
      onNotify = "${isync}/bin/mbsync -a";
    };
    imap = {
      host = "127.0.0.1";
      port = 1143;
      tls = {
        certificatesFile = ~/.proton.crt;
        useStartTls = true;
      };
    };
    # msmtp = {
    #   enable = true;
    # };
    mbsync = {
      enable = true;
      create = "both";
      expunge = "both";
      extraConfig.remote = {
        UseNamespace = "no";
      };
    };
  };
}
