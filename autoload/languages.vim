if exists('g:vim_languages_loaded') && g:vim_languages_loaded
	finish
endif
let g:vim_languages_loaded = 1

if !exists("g:vim_languages_default_filter")
	let g:vim_languages_default_filter = '^\(NoMonomorphismRestriction\|NoImplicitPrelude\|[^N][^o]\)'
endif

function! s:add_command(language)
	execute "command! " . a:language .  " call languages#pragma('" . a:language . "')"
endfunction

function! languages#pragma(language)
	let l:pragma = '{-# LANGUAGE ' . a:language . ' #-}'
	let l:n = line('.') + 1
	let l:m = col('.')
	let l:t = 1
	for l:line in getline(1, line('$'))
		if l:line =~ '{-# LANGUAGE' && l:line < l:pragma
			let l:t += 1
		else
			break
		endif
	endfor
	call cursor(l:t, 1)
	silent put! =l:pragma
	call cursor(l:n, l:m)
endfunction

function! languages#generate(filter)
	for l:language in split(system("ghc --supported-languages"), "\n")
		if l:language =~ a:filter
			call s:add_command(l:language)
		endif
	endfor
endfunction
