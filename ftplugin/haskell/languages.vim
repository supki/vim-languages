if exists('g:vim_languages_loaded') && g:vim_languages_loaded
  finish
endif
let g:vim_languages_loaded = 1

if !exists("g:vim_languages_exclude")
  let g:vim_languages_exclude =
    \ [ 'DatatypeContexts'
    \ , 'DoRec'
    \ , 'GeneralisedNewtypeDeriving'
    \ , 'NPlusKPatterns'
    \ , 'OverlappingInstances'
    \ , 'RecordPuns'
    \ , 'Rank2Types'
    \ ]
endif

if !exists("g:vim_languages_include")
  let g:vim_languages_include =
    \ [ 'NoFieldSelectors'
    \ , 'NoImplicitPrelude'
    \ , 'NoMonomorphismRestriction'
    \ ]
endif

function! s:add_command(language)
  execute "command! " . a:language .  " call languages#pragma('" . a:language . "')"
endfunction

function! languages#pragma(language)
  let l:pragma = '{-# LANGUAGE ' . a:language . ' #-}'
  let l:n = line('.')
  let l:m = col('.')
  let l:t = 1
  for l:line in getline(1, line('$'))
    " CPP directives and non-Haddock comments are ignored.
    if l:line =~ '^#' || (l:line =~ '^--' && ! (l:line =~ '^-- |'))
      let l:t += 1
    else
      " CPP is always the first pragma as it can influence the
      " inclusion of other pragmas.
      if a:language != 'CPP' &&
          \ (l:line == '{-# LANGUAGE CPP #-}' || (l:line =~ '^{-# LANGUAGE' && l:line < l:pragma))
        let l:t += 1
      elseif l:line == l:pragma
        call cursor(l:t, 1)
        silent delete
        call cursor(l:n - 1, l:m)
        break
      else
        call cursor(l:t, 1)
        silent put! =l:pragma
        call cursor(l:n + 1, l:m)
        break
      endif
    endif
  endfor
endfunction

function! languages#generate()
  if executable("stack") > 0 && filereadable("stack.yaml")
    if filereadable("shell.nix")
      let l:ghc = "stack --no-nix --system-ghc --no-install-ghc exec -- ghc"
    else
      let l:ghc = "stack exec -- ghc"
    endif
  else
    let l:ghc = "ghc"
  endif
  for l:language in split(system(l:ghc . " --supported-languages"), "\n")
    if ! (l:language =~ '^No\u' || index(g:vim_languages_exclude, l:language) != -1) || index(g:vim_languages_include, l:language) != -1
      call s:add_command(l:language)
    endif
  endfor
endfunction

call languages#generate()
