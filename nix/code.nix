with import <nixpkgs> {};

let

  # ./pkgs/misc/vscode-extensions/update_installed_exts.sh > /tmp/vscode-exts.nix
  vscode-exts = vscode-utils.extensionsFromVscodeMarketplace (import ./vscode-exts.nix).extensions;

  # ghcide = (import (builtins.fetchTarball "https://github.com/hercules-ci/ghcide-nix/tarball/master") {}).ghcide-ghc882;
  
in {

  home.file.".ngrok2/ngrok.yml".source = ../secrets/ngrok.yml;

  services.lorri.enable = true;
  home.packages = [
    ag
    ansible
    binutils-unwrapped
    # cabal-install
    # cabal2nix
    cachix
    ctop
    docker-compose
    emacs-all-the-icons-fonts
    gdb
    miniserve
    # vscode
    # ghcid
    gist
    nixfmt
    gnumake
    godef
    teams
    gotools
    gsasl
    # haskell.compiler.ghc882pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
    # haskellPackages.ghcide
    ngrok
    nix-prefetch-scripts
    nixpkgs-review
    niv
    nmap
    nodejs
    openssl
    swaks
    pypi2nix
    # (python3.withPackages(p: [p.django p.ipython p.xhtml2pdf p.weasyprint ]))
    # (import ./emacs-requirements/requirements.nix { inherit (import <nixpkgs> {}); }).interpreter
    # ghcide
    # (import (fetchFromGitHub {
    #   owner = "nix-community";
    #   repo = "pypi2nix";
    #   rev = "73322bc61dfcace6c22d1ae5c043b2b72ad94c3e";
    #   sha256 = "0l1n79cbzvl0c767v6nanbibfc44f6spwpmfj4fi4mfxmvr2mfwx";
    # }) {})
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
      haskell = {
        enable = true;
        hie = {
          enable = false;
          executablePath = "${haskellPackages.hie}/bin/hie-wrapper";
        };
      };
      userSettings = {
        # "update.channel" = "none";
        # "workbench.statusBar.visible" = false;
        "python.formatting.autopep8Path" = "${python3Packages.autopep8}/bin/autopep8";
        "python.jediPath" = "${python3Packages.jedi}/bin/jedi";
        "python.linting.flake8Path" = "${python3Packages.flake8}/bin/flake8";
        "python.linting.mypyPath" = "${python3Packages.mypy}/bin/mypy";
        "python.linting.pycodestylePath" = "${python3Packages.pycodestyle}/bin/pycodestyle";
        "python.linting.pylintPath" = "${python3Packages.pylint}/bin/pylint";
        "workbench.statusBar.visible" = false;
        "workbench.colorTheme" = "GitHub Light";
        "git.autofetch" = true;
        # "php.validate.executablePath" = "${((import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {}).php.withExtensions (e: with e; [ xdebug ]))}/bin/php";
        # "hic.executablePath" = "${ghcide}/bin/ghcide";
      };
      extensions = vscode-exts;
    };
  };
}
