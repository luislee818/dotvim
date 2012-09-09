call pathogen#infect()

set nu  " turn on line numbering
set nrformats=  " treat numbers as decimals (default is octal)
set wildmode=longest,list  " bash-style tab completion
set history=200  " record 200 Ex commands in history
set autoindent  " turn on autoindent
set hlsearch  " turn on highlight for search
set incsearch  " turn on incrementing search
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

" vim-trailing-whitespace plugin
nmap <leader>ws :FixWhitespace<CR>

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

" sample highlight (space or tab) syntax
"highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
"highlight ExtraTabs ctermbg=red guibg=red
"match ExtraWhitespace /\s\+$/
"match ExtraTabs /\t\+/

" 100-character guide http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
" match OverLength /\%101v.\+/
" au BufWinEnter * let w:m1=matchadd('OverLength', '\%101v.\+', -1)

" 100-character guide with colorcolumn feature in Vim 7.3
set colorcolumn=100
" au BufWinEnter * highlight ColorColumn ctermbg=red ctermfg=white guibg=#cb4b16

" map leader-U to upcase the current word
nmap <leader>U gUiw

" map command to custom script for TFS shortcuts
command! Tco !t co "%:p"
command! Tundo !t undo "%:p"

if has('win32') || has('win64')
	imap <c-j>d <c-r>=system('node %USERPROFILE%\vimfiles\utils\guid.js')<cr>
else
	imap <c-j>d <c-r>=system('node ~/.vim/utils/guid.js')<cr>
endif

" map ctrl+p/n to Up/Down (filters commands in history)
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
