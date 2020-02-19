self: super:
{
  vscode = super.vscode.overrideDerivation (old: {
    postFixup = with self.python3Packages; ''
      wrapProgram $out/bin/code --prefix PATH : "${self.lib.makeBinPath [ pylint flake8 ]}"
      wrapProgram $out/bin/code --prefix PATH : "${self.lib.makeBinPath [ self.ghc self.cabal-install self.stack ]}"
    '';
  });
}
