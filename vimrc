call pathogen#infect()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

set guioptions-=T  " Hide gVim toolbar
set guioptions-=m  " Hide gVim menu bar

set hidden  " allow unsaved background buffers and remember marks/undo for them
set number  " turn on line numbering
set laststatus=2  " always show command line
set nrformats=  " treat numbers as decimals (default is octal)
set wildmode=longest,list  " bash-style tab completion
set history=200  " record 200 Ex commands in history
set autoindent  " turn on autoindent
set backspace=indent,eol,start  " Backspace over everything in insert mode, http://superuser.com/questions/202848/backspace-key-not-working-in-vim
set cursorline  " highlight current line
set showmatch  " jumps to opening bracket briefly

set hlsearch  " turn on highlight for search
set incsearch  " turn on incrementing search
set ignorecase smartcase  " make searches case-sensitive only if they contain upper-case characters

set tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab  "  tab settings
set listchars=tab:▸\ ,eol:¬  " Use the same symbols as TextMate for tabstops and EOLs

syntax on  " enable syntax
filetype plugin indent on  " enable filetype plugin

set directory^=$HOME/.vim_swap//   "put all swap files together in one place

highlight Search cterm=underline  " use underline in color terminal for search matches

let mapleader=","

" (uncommet on Windows) Fix snippet issue on Windows
" let snippets_dir = substitute(substitute(globpath(&rtp, 'snippets/'), "\n", ',', 'g'), 'snippets\\,', 'snippets,', 'g')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256 " 256 colors
set background=dark
color grb256

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make copying to system clipboard easier
map <leader>y "+y
nmap <leader>l :set list!<CR>  " Shortcut to rapidly toggle `set list`

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Clear the search buffer when hitting ctrl-n
function! MapC_N()
  nnoremap <c-n> :nohlsearch<cr>
endfunction
call MapC_N()
nnoremap <leader><leader> <c-^>

" map ctrl+p/n to Up/Down (filters commands in history)
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" map leader-U to upcase the current word
nmap <leader>U gUiw

" map space to toggle fold
nnoremap <Space> za

" map shortcuts to change foldmethod
map <leader>fi :setlocal foldmethod=indent<cr>
map <leader>fs :setlocal foldmethod=syntax<cr>

" Toggle spell checking on and off with `<leader>s`
nmap <silent> <leader>s :set spell!<CR>

" Set region to American English
set spelllang=en_us

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ARROW KEYS ARE UNACCEPTABLE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CONFIGS FOR PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FOR JsDoc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" generate jsdoc comment template
" starts from http://stackoverflow.com/questions/7942738/vim-plugin-to-generate-javascript-documentation-comments
map <leader>c :call GenerateDOCComment()<cr>

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SHOW GUIDELINE AT 100 CHARACTER
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 100-character guide http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
" match OverLength /\%101v.\+/
" au BufWinEnter * let w:m1=matchadd('OverLength', '\%101v.\+', -1)

" au BufWinEnter * highlight ColorColumn ctermbg=red ctermfg=white guibg=#cb4b16

" toggle colored red right border after 100 chars
" guide with colorcolumn feature in Vim 7.3
set colorcolumn=101
let s:color_column_old = 0

function! s:ToggleColorColumn()
	if s:color_column_old == 0
		let s:color_column_old = &colorcolumn
		windo let &colorcolumn = 0
	else
		windo let &colorcolumn=s:color_column_old
		let s:color_column_old = 0
	endif
endfunction

" map ,g to toggle guide line
nnoremap <Leader>g :call <SID>ToggleColorColumn()<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INVOKE CUSTOM NODE.JS SCRIPT
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('win32') || has('win64')
	imap <c-j>d <c-r>=system('node %USERPROFILE%\vimfiles\utils\guid.js')<cr>
else
	imap <c-j>d <c-r>=system('node ~/.vim/utils/guid.js')<cr>
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INVOKE CUSTOM SHELL SCRIPTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" map command to custom script for TFS shortcuts
command! Tco !t co "%:p"
command! Tundo !t undo "%:p"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" JUNKDRAWER
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" sample highlight (space or tab) syntax
"highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
"highlight ExtraTabs ctermbg=red guibg=red
"match ExtraWhitespace /\s\+$/
"match ExtraTabs /\t\+/
