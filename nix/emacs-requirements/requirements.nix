# generated using pypi2nix tool (version: 2.0.4)
# See more at: https://github.com/nix-community/pypi2nix
#
# COMMAND:
#   pypi2nix -r emacs-requirements.txt -V python37
#

{ pkgs ? import <nixpkgs> {},
  overrides ? ({ pkgs, python }: self: super: {})
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.stdenv.lib) fix' extends inNixShell;

  pythonPackages =
  import "${toString pkgs.path}/pkgs/top-level/python-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv;
    python = pkgs.python37;
  };

  commonBuildInputs = [];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreterWithPackages = selectPkgsFn: pythonPackages.buildPythonPackage {
        name = "python37-interpreter";
        buildInputs = [ makeWrapper ] ++ (selectPkgsFn pkgs);
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter} \
              $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "
              (selectPkgsFn pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -x "$prog" ] && [ -f "$prog" ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          ln -s ${pythonPackages.python.executable} \
              python3
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };

      interpreter = interpreterWithPackages builtins.attrValues;
    in {
      __old = pythonPackages;
      inherit interpreter;
      inherit interpreterWithPackages;
      mkDerivation = args: pythonPackages.buildPythonPackage (args // {
        nativeBuildInputs = (args.nativeBuildInputs or []) ++ args.buildInputs;
      });
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (
          drv.drvAttrs // f drv.drvAttrs // { meta = drv.meta; }
        );
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {
    "aiosmtpd" = python.mkDerivation {
      name = "aiosmtpd-1.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/16/01/e0898673668f7a64eb4f6f37958da02a94bef3a6769230fa74b034ca396e/aiosmtpd-1.2.tar.gz";
        sha256 = "b7ea7ee663f3b8514d3224d55c4e8827148277b124ea862a0bbfca1bc899aef5";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."atpublic"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://aiosmtpd.readthedocs.io/";
        license = licenses.asl20;
        description = "aiosmtpd - asyncio based SMTP server";
      };
    };

    "atpublic" = python.mkDerivation {
      name = "atpublic-1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/1d/71/125eefdde54cf640eb2c22f868158fb0595fce1512c6c51201b105c44e63/atpublic-1.0.tar.gz";
        sha256 = "7dca670499e9a9d3aae5a8914bc799475fe24be3bcd29c8129642dda665f7a44";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://public.readthedocs.io/";
        license = licenses.asl20;
        description = "public -- @public for populating __all__";
      };
    };

    "ldap3" = python.mkDerivation {
      name = "ldap3-2.6.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/de/d8/2457e098ba4d93e42773e19f6dcf3748653392e51cdd6926e4a48cfbf9cd/ldap3-2.6.1.tar.gz";
        sha256 = "27cb673e7afcb539f6adcae5a3ecac4e74eb37ca0a2d50dc98f29a3829eee529";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."pyasn1"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/cannatag/ldap3";
        license = licenses.lgpl3;
        description = "A strictly RFC 4510 conforming LDAP V3 pure Python client library";
      };
    };

    "ptvsd" = python.mkDerivation {
      name = "ptvsd-4.3.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/43/0c/baf985198b25f32b3fb75cbf1a51689ca02f6f80039d3105211b92962e41/ptvsd-4.3.2.zip";
        sha256 = "3b05c06018fdbce5943c50fb0baac695b5c11326f9e21a5266c854306bda28ab";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://aka.ms/ptvs";
        license = licenses.mit;
        description = "Remote debugging server for Python support in Visual Studio and Visual Studio Code";
      };
    };

    "pyasn1" = python.mkDerivation {
      name = "pyasn1-0.4.8";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz";
        sha256 = "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/etingof/pyasn1";
        license = licenses.bsdOriginal;
        description = "ASN.1 types and codecs";
      };
    };
  };
  localOverridesFile = ./requirements_override.nix;
  localOverrides = import localOverridesFile { inherit pkgs python; };
  commonOverrides = [
        (let src = pkgs.fetchFromGitHub { owner = "nix-community"; repo = "pypi2nix-overrides"; rev = "ebc21a64505989717dc395ad92f0a4d7021c44bc"; sha256 = "1p1bqm80anxsnh2k26y0f066z3zpngwxpff1jldzzkbhvw8zw77i"; } ; in import "${src}/overrides.nix" { inherit pkgs python; })
  ];
  paramOverrides = [
    (overrides { inherit pkgs python; })
  ];
  allOverrides =
    (if (builtins.pathExists localOverridesFile)
     then [localOverrides] else [] ) ++ commonOverrides ++ paramOverrides;

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            allOverrides
         )
   )