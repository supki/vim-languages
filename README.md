# vim-language

This is a very simple plugin automatically generating vim commands to add
Haskell language extension pragmas at the top of the file. Different GHC versions support different
extensions, so the output of

```
$ ghc --supported-languages
```

is used to determine which commands to generate. It should be fairly robust; `--supported-languages`
switch exists since at least GHC 7.6. To use the plugin add

```vim
call languages#generate(g:vim_languages_default_filter
```

line to your ~/.vimrc. The argument to `languages#generate` is a Vim regular expression to filter
language extensions. With the default filter the plugin generates commands for
`-XNoMonomorphismRestriction`, for `-XNoImplicitPrelude`, and for all other extensions
not starting with `-XNo`. Command name is the name of the extension, so

```vim
:RankNTypes
```

will add

```haskell
{-# LANGUAGE RankNTypes #-}
```
