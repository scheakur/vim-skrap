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


let g:skrap_directory = get(g:, 'skrap_directory', expand('~/tmp/skrap'))


" Create a scrap file.
" @param {string} ext
" @param {number} immediately
" @param {string} suffix
function! s:new_skrap(ext, immediately, suffix)
	let skrap_dir = g:skrap_directory . strftime('/%Y/%m')

	if !isdirectory(skrap_dir)
		call mkdir(skrap_dir, 'p')
	endif

	let skrap_file = skrap_dir . strftime('/%Y-%m-%d-%H%M%S')
	if !empty(a:suffix)
		let skrap_file .= '-' . a:suffix
	endif
	let skrap_file .= '.' . a:ext

	if !a:immediately
		let skrap_file = input('Scrap File: ', skrap_file)
	endif

	if skrap_file != ''
		execute 'edit' skrap_file
	endif
endfunction


" deafult skrap command
command!
\	-nargs=?
\	Skrap
\	call s:new_skrap('', 0, <q-args>)


" type specified skrap command
for type in get(g:, 'skrap_types', [])
	execute
	\	'command!'
	\	'-nargs=?'
	\	'Skrap' . type
	\	'call s:new_skrap(''' . type . ''', 1, <q-args>)'
endfor


" restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}

" vim:fdm=marker:fen:
