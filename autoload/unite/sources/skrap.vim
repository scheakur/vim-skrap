"=============================================================================
" vim-skrap - Create and view scrap files
" Copyright (c) 2012 Scheakur <http://scheakur.com/>
"
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

scriptencoding utf-8

" save 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

function! unite#sources#skrap#define()
	return s:source
endfunction


let s:source = deepcopy(unite#get_all_sources('file_rec'))

let s:source.name = 'skrap'
let s:source.description = 'candidates from scrap files'

let s:source.source__skrap_gather_candidates = s:source.gather_candidates


function! s:source.gather_candidates(args, context)
	let year_month = get(a:args, 0, strftime('%Y/%m'))

	" Remove trailing slash
	let year_month = substitute(year_month, '/$', '', '')

	if year_month =~# '^p\%[revious]$'
		let [y, m] = split(strftime('%Y,%m'), ',')
		let year_month = join(s:get_prev_year_month(y, m), '/')
	endif

	" Remove directory string because the argument contains g:skrap_directory
	" when redrawing
	let length = strlen(year_month)
	if length > 7
		let year_month = strpart(year_month, length - 7)
	endif

	let dir = g:skrap_directory . '/' . year_month
	if len(a:args)
		let a:args[0] = dir
	else
		call add(a:args, dir)
	endif
	return s:source.source__skrap_gather_candidates(a:args, a:context)
endfunction


function! s:get_prev_year_month(y, m)
	let y = str2nr(a:y, 10)
	let m = str2nr(a:m, 10)
	if m > 1
		return [string(y), ('0' . (m - 1))[-2:]]
	endif
	return [string(y - 1), '12']
endfunction


function! s:source.complete(args, context, arglead, cmdline, cursorpos)
	let base_dir = g:skrap_directory . '/'
	let arglead = base_dir . a:arglead
	let dirs = unite#sources#file#complete_directory(
	\		a:args, a:context, arglead, a:cmdline, a:cursorpos)
	let dirs = map(dirs, 'substitute(v:val, base_dir, "", "") . "/"')
	call add(dirs, 'previous')
	return dirs
endfunction

" TODO This may not be right way to set sorters.
call unite#custom_source('skrap', 'sorters', ['sorter_word', 'sorter_reverse'])

" restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}

" vim:fdm=marker:fen:
