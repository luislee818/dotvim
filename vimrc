call pathogen#infect()

set nu  " turn on line numbering
set nrformats=  " treat numbers as decimals (default is octal)
set wildmode=longest,list  " bash-style tab completion
set history=200  " record 200 Ex commands in history
set autoindent  " turn on autoindent
set hlsearch  " turn on highlight for search
set backspace=indent,eol,start  " Backspace over everything in insert mode, http://superuser.com/questions/202848/backspace-key-not-working-in-vim

" Indentation settings
set tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab  "  tab settings
nmap <leader>l :set list!<CR>  " Shortcut to rapidly toggle `set list`
set listchars=tab:▸\ ,eol:¬  " Use the same symbols as TextMate for tabstops and EOLs

syntax on  " enable syntax
filetype plugin indent on  " enable filetype plugin

" (uncommet on Windows) Fix snippet issue on Windows
" let snippets_dir = substitute(substitute(globpath(&rtp, 'snippets/'), "\n", ',', 'g'), 'snippets\\,', 'snippets,', 'g')

set directory^=$HOME/.vim_swap//   "put all swap files together in one place

" Syntastic plugin
let g:syntastic_auto_loc_list=1  " Syntastic: automatically open and close quick fix window for errors
let g:syntastic_javascript_checker="jshint"  " Syntastic: use JSHint in Syntastic plugin

" Tagbar plugin
" Tagbar: use F9 to toggle
nnoremap <silent> <F9> :TagbarToggle<CR>

" Taglist-plus plugin
nnoremap <silent> <F8> :TlistToggle<CR>
let Tlist_Use_Right_Window=1  " Taglist-plus: display window on the right
let Tlist_Show_One_File=1  " Taglist-plus: show tags for teh current buffer only
let Tlist_GainFocus_On_ToggleOpen=1  " Taglist-plus: move focus to taglist when :TlistToggle command was invoked

" ctrlp plugin - ignore the following file/dir
let g:ctrlp_custom_ignore = {
\	'dir': '\.git$\|build$\|lib$\|docs$',
\	'file': '\.exe$\|\.dll$\|\.pdb$\|\.jpg$\|\.png$\|\.gif$\|\.pdf$'
\	}

" generate jsdoc comment template
" starts from http://stackoverflow.com/questions/7942738/vim-plugin-to-generate-javascript-documentation-comments
map <LocalLeader>c :call GenerateDOCComment()<cr>

function! GenerateDOCComment()
	let l    = line('.')
	let i    = indent(l)
	let pre  = repeat(' ',i)
	let text = getline(l)
	let params   = matchstr(text,'([^)]*)')
	let paramPat = '\([$a-zA-Z_0-9]\+\)[, ]*\(.*\)'
	echomsg params
	let vars = []
	let m    = ' '
	let ml = matchlist(params,paramPat)

	if ml==[]  " no parameter
		let vars += [pre.' * @memberOf ']
		let vars += [pre.' * @function']
		let vars += [pre.' * @return {} ']
	endif

	if ml!=[]  " has parameters
		let [_,var;rest]= ml
		let vars += [pre.' * @memberOf ']
		let vars += [pre.' * @function']

		while ml!=[]  " loop through parameters
			let [_,var;rest]= ml
			let vars += [pre.' * @param {} '.var.' ']
			let ml = matchlist(rest,paramPat,0)
		endwhile

		let vars += [pre.' * @return {} ']
	endif

	let comment = [pre.'/**',pre.' * ',pre.' *'] + vars + [pre.' */']
	call append(l-1,comment)
	call cursor(l+1,i+3)
endfunction

" show unwanted whitespaces
" http://vim.wikia.com/wiki/Highlight_some_whitespace_characters
nnoremap <Leader>ws :call ToggleShowWhitespace()<CR>
highlight ExtraWhitespace ctermbg=darkred guibg=darkred

" Highlight whitespace problems.
" flags is '' to clear highlighting, or is a string to
" specify what to highlight (one or more characters):
"   e  whitespace at end of line
"   i  spaces used for indenting
"   s  spaces before a tab
"   t  tabs not at start of line
function! ShowWhitespace(flags)
	let bad = ''
	let pat = []
	for c in split(a:flags, '\zs')
		if c == 'e'
			call add(pat, '\s\+$')
		elseif c == 'i'
			call add(pat, '^\t*\zs \+')
		elseif c == 's'
			call add(pat, ' \+\ze\t')
		elseif c == 't'
			call add(pat, '[^\t]\zs\t\+')
		else
			let bad .= c
		endif
	endfor
	if len(pat) > 0
		let s = join(pat, '\|')
		exec 'syntax match ExtraWhitespace "'.s.'" containedin=ALL'
	else
		syntax clear ExtraWhitespace
	endif
	if len(bad) > 0
		echo 'ShowWhitespace ignored: '.bad
	endif
endfunction

function! ToggleShowWhitespace()
	if !exists('b:ws_show')
		let b:ws_show = 0
	endif
	if !exists('b:ws_flags')
		let b:ws_flags = 'eist'  " default (which whitespace to show)
	endif
	let b:ws_show = !b:ws_show
	if b:ws_show
		call ShowWhitespace(b:ws_flags)
	else
		call ShowWhitespace('')
	endif
endfunction

" sample highlight (space or tab) syntax
"highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
"highlight ExtraTabs ctermbg=red guibg=red
"match ExtraWhitespace /\s\+$/
"match ExtraTabs /\t\+/

" 100-character guide http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
highlight OverLength ctermbg=red ctermfg=white guibg=#cb4b16
match OverLength /\%101v.\+/

" map leader-U to upcase the current word
nmap \U gUiw
