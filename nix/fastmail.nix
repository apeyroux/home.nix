with import <nixpkgs> {};

{
  accounts.email.accounts.fastmail = {
    userName = "alex@px.io";
    realName = "Alexandre Peyroux";
    address = "alex@px.io";
    flavor = "plain";
    passwordCommand = "${gnupg}/bin/gpg2 -q --for-your-eyes-only --no-tty -d ~/.mailpass-fastmail.gpg";
    mu.enable = false;
    smtp = {
      host = "smtp.fastmail.com";
      port = 465;
    };
    msmtp = {
      enable = true;
    };
  }; 
}
