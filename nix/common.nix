
with import <nixpkgs> {};

let

  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/4b6aab017cdf96a90641dc287437685675d598da") {};
  
in {

  nixpkgs.overlays = [
    (import ../overlays/vscode.nix)
    (self: super: {
      haskellPackages = super.haskellPackages.override (oldArgs: {
        overrides =
          self.lib.composeExtensions (oldArgs.overrides or (_: _: {}))
            (hself: hsuper: {
              xmonad-extras = haskell.lib.appendPatch super.haskellPackages.xmonad-extras ../patchs/Brightness.hs.patch;
            });
      });
    })
  ];
  
  home.sessionVariables = { EDITOR = "emacsclient -c"; VISUAL = "emacsclient -c"; };
  home.packages = [
    # pass
    # passExtensions.pass-import
    (pass.withExtensions(ex: with ex;[pass-import pass-otp pass-audit pass-update]))
    bind
    git-crypt
    # git-bug
    # libressl
    mailutils
    bat
    mosh
    # icons-in-terminal
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
        theme = "simple";
        plugins = [ "git"
                    "sudo"
                    "docker"
                    "docker-compose"
                    "web-search"];
      };
    };
    
    tmux = {
      enable = true;
      baseIndex = 0;
      clock24 = true;
      terminal = "screen-256color";
      # extraConfig = ''
      #   set-option -g status-style "fg=default,bg=#7E3C90"
      # '';
      plugins = with pkgs; [
        # tmuxPlugins.battery
        # {
        #   plugin = tmuxPlugins.battery;
        #   extraConfig = ''

        #   # https://github.com/spudlyo/clipetty
        #   set -ag update-environment "SSH_TTY"

        #   # tmux-256color instead of screen-256color enables italics
        #   set -g default-terminal "tmux-256color"

        #   # Tc enables true color
        #   set -ag terminal-overrides ",*256col*:colors=256:Tc"

        #   # Ms modifies OSC 52 clipboard handling to work with mosh, see
        #   # https://gist.github.com/yudai/95b20e3da66df1b066531997f982b57b
        #   # set -ag terminal-overrides "vte*:XT:Ms=\\E]52;c;%p2%s\\7,xterm*:XT:Ms=\\E]52;c;%p2%s\\7"
        #   set -ga terminal-overrides "screen*:Ms=\\E]52;%p1%s;%p2%s\\007,tmux*:Ms=\\E]52;%p1%s;%p2%s\\007"

        #   # enable OSC 52 clipboard
        #   # https://medium.freecodecamp.org/tmux-in-practice-integration-with-system-clipboard-bcd72c62ff7b
        #   set -g set-clipboard on

        #   # use bracketed paste, if the running application (vim/emacs/weechat) has
        #   # sent the terminal code to enable it.
        #   bind-key ] paste-buffer -p

        #   setw -g aggressive-resize on

        #   # http://comments.gmane.org/gmane.emacs.vim-emulation/1557
        #   set -s escape-time 0

        #   set -g status-right ' #{battery_status_bg} #{battery_icon} #{battery_percentage} #{battery_remain} #[bg=default] %a %d %h %H:%M '
        #   set -g @batt_charged_icon ""
        #   set -g @batt_charging_icon ""
        #   set -g @batt_attached_icon ""
        #   set -g @batt_full_charge_icon " "
        #   set -g @batt_high_charge_icon " "
        #   set -g @batt_medium_charge_icon " "
        #   set -g @batt_low_charge_icon " "
        #   '';
        # }
        # tmuxPlugins.cpu
        # {
        #   plugin = tmuxPlugins.resurrect;
        # }
        # {
        #   plugin = tmuxPlugins.continuum;
        #   extraConfig = ''
        #   set -g @continuum-restore 'on'
        #   set -g @continuum-save-interval '60' # minutes
        #   '';
        # }
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
        ec = "emacsclient";
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
