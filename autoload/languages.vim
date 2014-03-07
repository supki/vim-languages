if exists('g:vim_languages_loaded') && g:vim_languages_loaded
	finish
endif
let g:vim_languages_loaded = 1

if !exists("g:vim_languages_default_filter")
	let g:vim_languages_default_filter = '^\(NoMonomorphismRestriction\|NoImplicitPrelude\|[^N][^o]\)'
endif

function! s:add_command(language)
	execute "command! " . a:language .
		\ " let n = line('.') + 1 | 0put ='{-# LANGUAGE " . a:language . " #-}' | execute n"
endfunction

function! languages#generate(filter)
	for l:language in split(system("ghc --supported-languages"), "\n")
		if l:language =~ a:filter
			call s:add_command(l:language)
		endif
	endfor
endfunction
