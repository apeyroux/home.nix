with import <nixpkgs> {};

let
  
  vscode-ext-language-haskell = vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "language-haskell";
      publisher = "justusadam";
      version = "2.6.0";
      sha256 = "1891pg4x5qkh151pylvn93c4plqw6vgasa4g40jbma5xzq8pygr4";
    };
  };

  vscode-ext-python = vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "python";
      publisher = "ms-python";
      version = "2019.11.50794";
      sha256 = "1imc4gc3aq5x6prb8fxz70v4l838h22hfq2f8an4mldyragdz7ka";
    };
  };

  vscode-ext-php-debug = vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "php-debug";
      publisher = "felixfbecker";
      version = "1.13.0";
      sha256 = "0h0md2w1zjjf87313ydknld85i118r7lqghmi11hfgi2f496qxj6";
    };
  };
  
  vscode-ext-docker = vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-docker";
      publisher = "ms-azuretools";
      version = "0.9.0";
      sha256 = "0wka4sgq5xjgqq2dc3zimrdcbl9166lavscz7zm6v4n6f9s2pfj0";
    };
  };

  vscode-ext-ghcide = vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "ghcide";
      publisher = "DigitalAssetHoldingsLLC";
      version = "0.0.2";
      sha256 = "02gla0g11qcgd6sjvkiazzk3fq104b38skqrs6hvxcv2fzvm9zwf";
    };
  };
  
  vscode-ext-remote-containers = vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "remote-containers";
      publisher = "ms-vscode-remote";
      version = "0.96.0";
      sha256 = "1yyalywcqxhlmsv80ykmizzha5sj95068v73h1khv3nza4rrbf0c";
    };
  };

  ghcide = (import (builtins.fetchTarball "https://github.com/hercules-ci/ghcide-nix/tarball/master") {}).ghcide-ghc865;
  
in {

  nixpkgs.overlays = [ (import ../overlays/vscode.nix) ];

  home.file.".ngrok2/ngrok.yml".source = ../secrets/ngrok.yml;

  services.lorri.enable = true;
  home.packages = [
    ag
    ansible
    cabal-install
    binutils-unwrapped
    ctop
    docker-compose
    emacs-all-the-icons-fonts
    gdb
    ghc
    gist
    gnumake
    godef
    gotools
    gsasl
    ngrok
    nix-prefetch-scripts
    nixpkgs-review
    nmap
    nodejs
    openssl
    swaks
    # (python3.withPackages(p: [p.django p.ipython p.xhtml2pdf p.weasyprint ]))
    (import ./emacs-requirements/requirements.nix { inherit (import <nixpkgs> {}); }).interpreter
    # ghcide
    (import (fetchFromGitHub {
      owner = "nix-community";
      repo = "pypi2nix";
      rev = "73322bc61dfcace6c22d1ae5c043b2b72ad94c3e";
      sha256 = "0l1n79cbzvl0c767v6nanbibfc44f6spwpmfj4fi4mfxmvr2mfwx";
    }) {})
  ];

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      userEmail = "alex@px.io";
      userName = "Alexandre Peyroux";
      signing = {
        signByDefault = true;
        key = "E29E9DCBB3FD297DCCF9D574A4BD77DD1421E5CF";
      };
      extraConfig = {
        http = {
          sslverify = false;
        };
        github = {
          user = "apeyroux";
        };
        git-bug."auth.08c9e0028d8650bc3afca87d043d1fc364516881f37c9fd2ed9af2d5f2f524b7" = {
	        kind = "token";
	        userid = "919a88f99874e1f2d62b2deb1fd4cec6f8fb7569";
          target = "gitlab";
          createtime = "1580849689";
          value = "x41mXRFaHRoRwzZD36N8";
        };
        credential.helper = "store";
        credential."https://github.com" = {
          username = "apeyroux";
          password = builtins.readFile ../secrets/github.password;
        };
        url."https://" = {
          instedOf = "git://";
        };
      };
    };
    go.enable = true;
    vscode = {
      enable = true;
      userSettings = {
        "update.channel" = "none";
        "workbench.statusBar.visible" = false;
        "python.formatting.autopep8Path" = "${python3Packages.autopep8}/bin/autopep8";
        "python.jediPath" = "${python3Packages.jedi}/bin/jedi";
        "python.linting.flake8Path" = "${python3Packages.flake8}/bin/flake8";
        "python.linting.mypyPath" = "${python3Packages.mypy}/bin/mypy";
        "python.linting.pycodestylePath" = "${python3Packages.pycodestyle}/bin/pycodestyle";
        "python.linting.pylintPath" = "${python3Packages.pylint}/bin/pylint";
        # "php.validate.executablePath" = "${((import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {}).php.withExtensions (e: with e; [ xdebug ]))}/bin/php";
        # "hic.executablePath" = "${ghcide}/bin/ghcide";
      };
      extensions = [
        vscode-ext-docker
        vscode-ext-ghcide
        vscode-ext-language-haskell
        vscode-ext-python
        vscode-ext-remote-containers
        vscode-ext-php-debug
      ];
    };
  };
}
