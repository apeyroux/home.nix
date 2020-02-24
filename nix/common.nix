
with import <nixpkgs> {};

let

in {

  home.sessionVariables = { EDITOR = "vim"; };
  home.packages = [
    # pass
    # passExtensions.pass-import
    (pass.withExtensions(ex: with ex;[pass-import pass-otp pass-audit pass-update]))
    bind
    git-crypt
    # git-bug
    libressl
    mailutils
    mosh
    mtr
    pigz
    restic
    traceroute
    unzip
    whois
    xsel
  ];

  nixpkgs.config.allowUnfree = true;

  # services.password-store-sync = {
  #   enable = true;
  # };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };

  accounts.email.maildirBasePath = ".mail";

  programs = {

    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
      };
    };
    
    tmux = {
      enable = true;
      baseIndex = 0;
      clock24 = true;
      terminal = "screen-256color";
      plugins = with pkgs; [
        tmuxPlugins.battery
        {
          plugin = tmuxPlugins.battery;
          extraConfig = ''
          set -g status-right ' #{battery_status_bg} #{battery_icon} #{battery_percentage} #{battery_remain} #[bg=default] %a %d %h %H:%M '
          set -g @batt_charged_icon ""
          set -g @batt_charging_icon ""
          set -g @batt_attached_icon ""
          set -g @batt_full_charge_icon " "
          set -g @batt_high_charge_icon " "
          set -g @batt_medium_charge_icon " "
          set -g @batt_low_charge_icon " "
          '';
        }
        tmuxPlugins.cpu
        {
          plugin = tmuxPlugins.resurrect;
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
          '';
        }
      ];
      aggressiveResize = true;
    };

    gpg = {
      enable = true;
    };

    jq.enable = true;

    bash = {
      enable = true;
      enableAutojump = true;
      shellAliases = {
        git-crypt-users = "pushd .git-crypt/keys/default/0; for file in *.gpg; do echo \"$\{file\} : \" && git log -- $\{file\} | sed -n 9p; done; popd";
      };
    };

    direnv.enable = true;

    htop.enable = true;

    vim = {
      enable = true;
      plugins = [
        vimPlugins.coc-css
        vimPlugins.coc-git
        vimPlugins.coc-go
        vimPlugins.coc-html
        vimPlugins.coc-json
        vimPlugins.coc-python
        vimPlugins.coc-yaml
        vimPlugins.coc-tsserver
        vimPlugins.coc-tslint
        vimPlugins.haskell-vim
        vimPlugins.rust-vim
        # vimPlugins.stylishHaskell
        vimPlugins.vim-addon-nix
        vimPlugins.vim-javascript
      ];
      settings = {
        expandtab = true;
      };
      extraConfig = ''
        syntax on                  " Enable syntax highlighting.
        filetype plugin indent on  " Enable file type based indentation.

        set autoindent             " Respect indentation when starting a new line.
        set expandtab              " Expand tabs to spaces. Essential in Python.
        set tabstop=4              " Number of spaces tab is counted for.
        set shiftwidth=4           " Number of spaces to use for autoindent.
        set directory=$HOME/.vim/
        set backspace=2            " Fix backspace behavior on most terminals.
        set wildmenu                    " Enable enhanced tab autocomplete.
        set wildmode=list:longest,full  " Complete till longest string,
      ''; 
    };

    newsboat = {
      enable = true;
      urls = [
        { url="https://linuxfr.org/news.atom"; tags=["linuxfr"]; }
        { url="https://www.lemonde.fr/rss/une.xml"; tags=["lemonde" "info"]; }
        { url="https://www.lefigaro.fr/rss/figaro_actualites.xml"; tags=["lefigaro" "info"]; }
      ];
    };
  };
}
