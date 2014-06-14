# vim-languages

This is a very simple plugin that automatically generates vim commands to add or remove
Haskell language extension pragmas.  Different GHC versions support different extensions,
so the output of

```sh
$ ghc --supported-languages
```

is used to determine which commands to generate.  It should be fairly robust: `--supported-languages`
switch exists since at least GHC 7.6.  The plugin supports [pathogen][vim-pathogen], so
to install it you can just do

```sh
cd ~/.vim/bundle && git clone git@github.com/supki/vim-languages
```

and be done.  By default commands for `-XNoMonomorphismRestriction`, for `-XNoImplicitPrelude`,
and for all other extensions not starting with `-XNo` are generated.  If you are not happy
with the defaults, please modify `g:vim_languages_filter` variable to your favorite regex.
The generated command name is the name of the extension, so

```vim
:RankNTypes
```

will add

```haskell
{-# LANGUAGE RankNTypes #-}
```

Another call to `RankNTypes` will remove the pragma.

_Note_ that the plugin expects the file to have all LANGUAGE pragmas as one big block
at the top; it tolerates the single line comment syntax and pre-processor instructions
but nothing else (e.g. OPTIONS_GHC pragmas interspersed in the list of LANGUAGE pragmas
will break everything)


![Screencast](asset/screencast.gif)

  [vim-pathogen]: https://github.com/tpope/vim-pathogen
