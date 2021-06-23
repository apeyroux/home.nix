with import <nixpkgs> {};
# with import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {};

let

  # pypi2nix -r emacs-requirements.txt -V python37 --basename emacs-requirements
  # python = import ./emacs-requirements/requirements.nix { inherit (import <nixpkgs> {}); };

  # all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/archive/master.tar.gz") {};
  
  bintools = binutils.bintools;
  # rust-src = fetchFromGitHub {
  #   owner = "mozilla";
  #   repo = "nixpkgs-mozilla";
  #   rev = "master";
  #   sha256 = "0l0vqbbm93hnd1w0qkrfvg4yml7rq62jn554li05hlf90765fy50";
  # };
  # apps = with haskell.packages.ghc861; [
  # apps = with haskellPackages; [
  # apps = with import "${rust-src.out}/rust-overlay.nix" pkgs pkgs; [

  nixghc = writeScriptBin "nixghc" ''
#!/bin/sh
nix-shell -I . --command "${ghc}/bin/ghc $*"
  '';

  # apps = with import "/home/alex/.config/nixpkgs/overlays/rust-overlay.nix" pkgs pkgs; [
  apps = [
    # ((import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {}).php73.withExtensions (e: with e; [ xdebug ]))
    # haskellPackages.ghc-mod
    # haskellPackages.hindent
    # nodejs-11_x
    # python.packages."autopep8"
    # python.packages."epc"
    # python.packages."importmagic"
    # python.packages."ipython"
    # python.packages."jedi"
    # python.packages."virtualenv"
    # python27Packages.rope
    # python37Packages.autopep8
    # python37Packages.epc
    # python37Packages.importmagic
    # python37Packages.ipython
    # python37Packages.jedi
    # python37Packages.virtualenv
    # rustChannels.stable.cargo
    # rustfmt
    # rustracer
    # rustracerd
    ag
    aspellWithDictFR
    autoconf
    automake
    bintools
    binutils
    cabal-install
    cabal2nix
    carnix
    diffstat
    docker-machine
    elmPackages.elm
    emacs-all-the-icons-fonts
    # erlang
    fzf
    gcc
    gdb
    ghostscript
    git
    git-crypt
    gnumake
    go
    godef
    gotools
    gvfs
    # haskell.compiler.ghc882
    haskellPackages.fast-tags
    haskellPackages.ghcid
    haskellPackages.happy
    haskellPackages.hasktags
    haskellPackages.hlint
    haskellPackages.hoogle
    haskellPackages.hpack
    haskellPackages.structured-haskell-mode
    haskellPackages.stylish-haskell
    htmlTidy
    imagemagick
    isync
    libnotify
    libpng
    libxml2
    makeWrapper
    mercurial
    multimarkdown
    ncurses
    nixfmt
    nixghc
    nodePackages.typescript-language-server
    nodejs
    openldap
    php
    poppler # confusion avec poppler haskell
    poppler_utils
    python.interpreter
    ripgrep
    roboto
    roboto-mono
    # rustChannels.stable.rls-preview
    # rustChannels.stable.rust
    # rustChannels.stable.rust-docs
    # rustChannels.stable.rust-src
    # rustChannels.stable.rustfmt-preview
    # rustracer
    siji
    stack
    tetex
    tshark
    w3m
    xclip
    xz
    zip
    zlib
  ];

  aspellWithDictFR = aspellWithDicts (ps: with ps; [ en fr ]);

  myemacs = emacs.overrideDerivation (old: rec {
    # myemacs = (import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {}).emacs.overrideDerivation (old: rec {
    withXwidgets = true;
    postInstall = with python37Packages; (old.postInstall + ''
      # bin
      wrapProgram $out/bin/emacs --prefix PATH : "${lib.makeBinPath apps}"
      # python
      wrapProgram $out/bin/emacs --prefix PYTHONPATH : "$(toPythonPath ${pip})" 
      wrapProgram $out/bin/emacs --prefix PYTHONPATH : "$(toPythonPath ${virtualenv})"
      wrapProgram $out/bin/emacs --prefix PYTHONPATH : "$(toPythonPath ${jedi})"
      wrapProgram $out/bin/emacs --prefix PYTHONPATH : "$(toPythonPath ${autopep8})"
      wrapProgram $out/bin/emacs --prefix PYTHONPATH : "$(toPythonPath ${flake8})"
      # mu4e
      wrapProgram $out/bin/emacs --prefix PATH : ${lib.makeBinPath [mu]}
      wrapProgram $out/bin/emacs --set MU4E ${mu}
      '');
  });

  # emacsPackages = (emacsPackagesNgGen (myemacs.override { withXwidgets = false; }));
  # emacsPackages = (emacsPackagesNgGen (emacsWithMu.override { withXwidgets = false; })).overrideScope (self: super: {
  #   nix-sandbox = emacsPackages.melpaPackages.nix-sandbox.overrideDerivation(oldAttrs: {
  #     src = fetchurl {
  #       url = "https://raw.githubusercontent.com/travisbhartwell/nix-emacs/master/nix-sandbox.el";
  #       sha256 = "0inx5yvni0ik7pd7l02jpddi0866dg1wj9x16dp7glnrs82yib88";
  #       name = "nix-sandbox.el";
  #     };
  #   });

  #   magithubWithGit = emacsPackages.melpaPackages.magithub.overrideDerivation(oldAttrs: {
  #     buildInputs = oldAttrs.buildInputs ++ [ git ];
  #   });
  
  # });

  mu4e = emacsPackages.trivialBuild {
    pname = "mu4e";
    src = "${mu}/share/emacs/site-lisp/mu4e/";
    packageRequires = [ mu ];
  };
  
  mu4e-thread-folding = emacsPackages.trivialBuild {
    pname = "mu4e-thread-folding";
        src = fetchFromGitHub {
      owner  = "rougier";
      repo   = "mu4e-thread-folding";
      rev    = "f125b5eda75ca1e7675dbbd774a8a2f551f52874";
      sha256 = "000vda9xcw4901r05mkwkb7qlq8vzsq3r4wi9687ivmjwb2d141l";
    };
    packageRequires = [ mu4e ];
  };

  nano-emacs = emacsPackages.trivialBuild {
    pname = "nano-emacs";
    src = fetchFromGitHub {
      owner  = "rougier";
      repo   = "nano-emacs";
      rev    = "0a75f78e78fd9f91da77a496344689e3781185c9";
      sha256 = "1i8hwd0dz208kxpijxhbx40m8rdc2xzrp34jxnwmimr1r2q86nxp";
    };
    patches = [ ../patchs/nano-el.patch ];
    packageRequires = [ roboto-mono org ];
  };
  
  elegant-emacs = emacsPackages.trivialBuild {
    pname = "elegant-emacs";
    src = fetchFromGitHub {
      owner  = "rougier";
      repo   = "elegant-emacs";
      rev    = "4dc47a804213ace171dea357268cb3fa111db17a";
      sha256 = "1a0yalq3sz69fn105m75vlcx4qrhlgvn4l9g3lb3wmn1isfam0yz";
    };
    packageRequires = [ roboto-mono ];
  };
  
  ghcid-el = emacsPackages.trivialBuild {
    pname = "ghcid";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/ndmitchell/ghcid/master/plugins/emacs/ghcid.el";
      sha256 = "01n4fwqabx6jdyjqqi1hrpldaf28pib7zm4qcv99ghmrca6qk4xc";
    }; 
  };

  # hs-lint = emacsPackages.trivialBuild {
  #   pname = "hs-lint";
  #   src = fetchurl {
  #     url = "https://raw.githubusercontent.com/ndmitchell/hlint/master/data/hs-lint.el";
  #     sha256 = "0l3ldl5msy1pgjsw16r281ah4szxwmyplh7dhnfp5wj3zly6vgv1";
  #   };
  # };
  
  all-the-icons-ibuffer-el = emacsPackages.trivialBuild {
    pname = "all-the-icons-ibuffer";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/seagle0128/all-the-icons-ibuffer/master/all-the-icons-ibuffer.el";
      sha256 = "0dvmpm5r6gpywab4crmds7shg23jgj24bzjmfx6dznr3mh73d6iy";
    }; 
  };

  org = stdenv.mkDerivation rec {
    name = "emacs-org-${version}";
    version = "20160421";
    src = fetchFromGitHub {
      owner  = "jwiegley";
      repo   = "org-mode";
      rev    = "db5257389231bd49e92e2bc66713ac71b0435eec";
      sha256 = "073cmwgxga14r4ykbgp8w0gjp1wqajmlk6qv9qfnrafgpxic366m";
    };
    preBuild = ''
        rm -f contrib/lisp/org-jira.el
        makeFlagsArray=(
          prefix="$out/share"
          ORG_ADD_CONTRIB="org* ox*"
                                                 );
      '';
    preInstall = ''
        perl -i -pe "s%/usr/share%$out%;" local.mk
      '';
    buildInputs = [ myemacs ] ++ (with pkgs; [ texinfo perl which ]);
    meta = {
      homepage = "https://elpa.gnu.org/packages/org.html";
      license = lib.licenses.free;
    };
  };
  
  base-el = stdenv.mkDerivation {
    name = "base-el";
    src = ../dotfiles;
    buildInputs = [ emacs ];
    buildPhase = ''
    '';
    installPhase = ''
      export OUT=$out
      export HOME=/tmp
      mkdir -p $out/org
      cp emacs.org $out/org/default.org
      cd $out
      emacs -batch -eval '(print "build default.el ...")' -eval "(require 'org)" -eval '(org-babel-tangle-file (concat (getenv "OUT") "/org/default.org"))'
      cat $out/org/default.el
    '';
  };

  default-el = emacsPackages.trivialBuild {
    pname = "default-el";
    src = writeText "default.el" ((lib.readFile "${base-el}/org/default.el")
                                  # + (lib.readFile ../dotfiles/mail.el)
                                  + ''(load "~/.mail.el")''
                                  + ''(setq mu4e-mu-binary "${mu}/bin/mu")''
                                  # + ''(load "~/src/nano-emacs/nano.el")''
    );
    dontBuild = true;
  };

in {
  home.file.".mail.el".source = ../dotfiles/mail.el;
  home.packages = [
    # (all-hies.selection { selector = p: { inherit (p) ghc882 ghc881 ghc865 ghc884; }; })
    git-crypt
    mu
  ];
  programs.emacs = {
    enable = true;
    package = myemacs;
    extraPackages = (epkgs: (with epkgs.melpaStablePackages; [
      # ac-php
      # all-the-icons-ibuffer
      # all-the-icons-ibuffer-el
      # company-box
      # git-timemachine
      # lsp-rust
      # multi-term
      # notmuch
      # smex
      # multi-vterm
      # org-jira
    ]) ++ (with epkgs.melpaPackages; [
      # all-the-icons-ibuffer
      # xwwp
      # xwwp-ace-toggle
      # ace-jump
      nord-theme
      ace-window
      ag
      all-the-icons
      all-the-icons-dired
      all-the-icons-ivy
      amx
      attrap
      ansible
      async
      backup-walker
      bash-completion
      # calfw
      # calfw-ical
      # calfw-org
      # cargo
      centaur-tabs
      clipetty
      company
      company-box
      company-box
      company-cabal
      # company-ghc
      company-ghci
      company-go
      # company-lsp
      company-nixos-options
      company-php
      company-quickhelp
      counsel
      counsel-projectile
      counsel-tramp
      # dante
      dap-mode
      dash
      default-el
      mu4e-thread-folding
      elegant-emacs
      direnv
      docker
      docker-api
      docker-compose-mode
      docker-tramp
      dockerfile-mode
      # doom-modeline
      # doom-themes
      # dracula-theme
      # edit-server
      editorconfig
      eglot
      elm-mode
      # emamux
      # erlang
      esh-autosuggest
      eshell-git-prompt
      eshell-prompt-extras
      f
      flycheck
      flycheck-haskell
      flycheck-pos-tip
      flycheck-rust
      ghc
      gist
      git-auto-commit-mode
      git-gutter
      go-mode
      gocode
      google-translate
      haskell-mode
      nix-haskell-mode
      # hasky-stack
      hl-todo
      # hs-lint
      ht
      impatient-mode
      importmagic
      # intero
      # ivy-erlang-complete
      ivy-explorer
      ivy-posframe
      ivy-yasnippet
      js2-mode
      lorem-ipsum
      lsp-haskell
      lsp-mode
      lsp-ui
      magit
      magit-lfs
      magit-todos
      markdown-mode
      mu4e-alert
      multi-term
      multiple-cursors
      nix-buffer
      nix-mode
      nix-sandbox
      nixos-options
      ob-http
      org-jira
      org-bullets
      org-gcal
      org-mime
      org-rich-yank
      ox-reveal
      pcap-mode
      pcre2el
      pdf-tools
      # perspective
      php-mode
      powerline
      projectile
      py-autopep8
      pyvenv
      # racer
      rainbow-delimiters
      # realgud
      restclient
      rjsx-mode
      rnix-lsp
      rust-mode
      s
      shx
      smex
      spaceline-all-the-icons
      swiper
      terraform-mode
      tide ## typescript
      treemacs
      treemacs-icons-dired
      treemacs-magit
      treemacs-persp
      treemacs-projectile
      unicode-fonts
      virtualenvwrapper
      vterm
      web-mode
      wgrep
      which-key
      yaml-mode
      yasnippet
      yasnippet-snippets
      zeal-at-point
      zerodark-theme
      zoom-window
      ztree
    ]) ++ (with epkgs.elpaPackages; [
      # company-box
      # ivy-explorer
      # tramp
      # csv-mode
      rainbow-mode
      undo-tree
      xclip
    ]) ++ [
      # org
    ]);
  };
}
