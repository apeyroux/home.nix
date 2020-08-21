with import <nixpkgs> {};

let

  # pypi2nix -r emacs-requirements.txt -V python37 --basename emacs-requirements
  python = import ./emacs-requirements/requirements.nix { inherit (import <nixpkgs> {}); };

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

  apps = with import "/home/alex/.config/nixpkgs/overlays/rust-overlay.nix" pkgs pkgs; [
    ag
    aspellWithDictFR
    autoconf
    automake
    bintools
    binutils
    cabal-install
    cabal2nix
    diffstat
    docker-machine
    emacs-all-the-icons-fonts
    elmPackages.elm
    erlang
    gcc
    gdb
    haskell.compiler.ghc882
    gvfs
    git
    git-crypt
    gnumake
    ghostscript
    go
    godef
    gotools
    haskellPackages.fast-tags
    haskellPackages.ghcid
    haskellPackages.happy
    haskellPackages.hasktags
    # haskellPackages.hindent
    haskellPackages.hlint
    # haskellPackages.ghc-mod
    haskellPackages.hoogle
    haskellPackages.hpack
    haskellPackages.structured-haskell-mode
    haskellPackages.stylish-haskell
    htmlTidy
    imagemagick
    isync
    openldap
    libnotify
    libpng
    libxml2
    makeWrapper
    mercurial
    multimarkdown
    ncurses
    nixghc
    fzf
    # nodejs-11_x
    nodejs
    # ((import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {}).php73.withExtensions (e: with e; [ xdebug ]))
    php
    poppler # confusion avec poppler haskell
    poppler_utils
    # python27Packages.rope
    python.interpreter
    # python37Packages.epc
    # python37Packages.autopep8
    # python37Packages.importmagic
    # python37Packages.ipython
    # python37Packages.jedi
    # python37Packages.virtualenv
    # python.packages."epc"
    # python.packages."autopep8"
    # python.packages."importmagic"
    # python.packages."ipython"
    # python.packages."jedi"
    # python.packages."virtualenv"
    # rustChannels.stable.cargo
    carnix
    rustracer
    rustChannels.stable.rust
    rustChannels.stable.rust-src
    rustChannels.stable.rustfmt-preview
    rustChannels.stable.rls-preview
    rustChannels.stable.rust-docs
    # rustfmt
    # rustracer
    # rustracerd
    siji
    stack
    tshark
    tetex
    w3m
    ripgrep
    xclip
    xz
    zip
    zlib
  ];

  aspellWithDictFR = aspellWithDicts (ps: with ps; [ en fr ]);

  myemacs = emacs.overrideDerivation (old: rec {
  # myemacs = (import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {}).emacs.overrideDerivation (old: rec {
    postInstall = with python37Packages; (old.postInstall + ''
      # bin
      wrapProgram $out/bin/emacs --prefix PATH : "${lib.makeBinPath apps}"
      # python
      wrapProgram $out/bin/emacs --prefix PYTHONPATH : "$(toPythonPath ${pip})" 
      wrapProgram $out/bin/emacs --prefix PYTHONPATH : "$(toPythonPath ${virtualenv})"
      wrapProgram $out/bin/emacs --prefix PYTHONPATH : "$(toPythonPath ${jedi})"
      wrapProgram $out/bin/emacs --prefix PYTHONPATH : "$(toPythonPath ${autopep8})"
      wrapProgram $out/bin/emacs --prefix PYTHONPATH : "$(toPythonPath ${flake8})"
      wrapProgram $out/bin/emacs --prefix PYTHONPATH : "$(toPythonPath ${rope})"
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

  flycheck-grammalecte = stdenv.mkDerivation {
    name = "flycheck-grammalecte";
    src = fetchgit {
      url = "https://gitlab.com/geeklhem/flycheck-grammalecte.git";
      rev = "6fa0d0cefa9c324831c7bf97d6cc360dcdaa85e0";
      sha256 = "1s66py788f2vvmjsnka2lcjkravvdliznbvmfi5z7kpcq62jiccw";
      fetchSubmodules = true;
    };

    buildInputs = [ (emacsWithPackages (ps: with ps; with emacsPackagesNg; [ flycheck org ])) ];

    buildPhase = ''
      emacs --batch -f batch-byte-compile flycheck-grammalecte.el
    '';

    installPhase = ''
      install -d $out/share/emacs/site-lisp
      install flycheck-grammalecte.el $out/share/emacs/site-lisp
      install flycheck-grammalecte.elc $out/share/emacs/site-lisp
      install flycheck-grammalecte.py $out/share/emacs/site-lisp
    '';
  };
  
  ghcid-el = emacsPackages.trivialBuild {
    pname = "ghcid";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/ndmitchell/ghcid/master/plugins/emacs/ghcid.el";
      sha256 = "01n4fwqabx6jdyjqqi1hrpldaf28pib7zm4qcv99ghmrca6qk4xc";
    }; 
  };

  hs-lint = emacsPackages.trivialBuild {
    pname = "hs-lint";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/ndmitchell/hlint/master/data/hs-lint.el";
      sha256 = "0l3ldl5msy1pgjsw16r281ah4szxwmyplh7dhnfp5wj3zly6vgv1";
    };
  };
  
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
      calfw
      calfw-ical
      calfw-org
      cargo
      centaur-tabs
      clipetty
      company
      company-box
      company-box
      company-cabal
      company-ghc
      company-ghci
      company-go
      company-lsp
      company-nixos-options
      company-php
      company-quickhelp
      counsel
      counsel-projectile
      counsel-tramp
      dante
      dap-mode
      dash
      default-el
      direnv
      docker
      docker-api
      docker-compose-mode
      docker-tramp
      dockerfile-mode
      doom-modeline
      doom-themes
      dracula-theme
      edit-server
      editorconfig
      eglot
      elm-mode
      emamux
      erlang
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
      git-gutter
      go-mode
      gocode
      google-translate
      haskell-mode
      nix-haskell-mode
      hasky-stack
      hl-todo
      hs-lint
      ht
      impatient-mode
      importmagic
      intero
      ivy-erlang-complete
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
      perspective
      php-mode
      powerline
      projectile
      py-autopep8
      pyvenv
      racer
      rainbow-delimiters
      realgud
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
      tide
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
      csv-mode
      rainbow-mode
      undo-tree
      xclip
    ]) ++ [
      # org
    ]);
  };
}
