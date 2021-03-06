call pathogen#infect()

" ignore plugin
set runtimepath-=~/.vim/bundle/ctrlp

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

set guioptions-=T  " Hide gVim toolbar
set guioptions-=m  " Hide gVim menu bar

scriptencoding utf-8
set encoding=utf-8

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

" grep settings
" set grepprg=rg\ -H\ --no-heading\ --vimgrep
" set grepformat=$f:$l:%c:%m

syntax on  " enable syntax
filetype plugin indent on  " enable filetype plugin

set tabstop=2 shiftwidth=2 softtabstop=2 expandtab  "  (no)tab settings
autocmd BufRead,BufNewFile *_spec.rb set filetype=rspec
autocmd BufRead,BufNewFile *.hamlc set filetype=haml
autocmd BufRead,BufNewFile *.es6 set filetype=javascript  " for ES6 files
autocmd BufRead,BufNewFile ~/Release/* set background=light  "  change background color for Release
autocmd FileType ruby setlocal expandtab  "  expandtab for Ruby files
autocmd FileType rspec setlocal expandtab  "  expandtab for RSpec files
autocmd FileType coffee setlocal expandtab  "  expandtab for CoffeeScript files
autocmd FileType javascript setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4 "  for JavaScript files
autocmd FileType html setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4 "  for Html files
autocmd FileType elm setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4 "  for elm files
set listchars=tab:▸\ ,eol:¬  " Use the same symbols as TextMate for tabstops and EOLs


autocmd BufWritePost *.exs silent :!mix format %
autocmd BufWritePost *.ex silent :!mix format %

" swap file settings
set noswapfile  "disable swap file
"set directory=$HOME/.vim_swap//   "put all swap files together in one place

set undofile
if !has('nvim')
	set undodir=~/.vim/undo
endif
augroup vimrc
	autocmd!
	autocmd BufWritePre /tmp/* setlocal noundofile
augroup END

" so fugitive.vim will work on Windows
if has("win32") || has("win64")
   set directory+=,~/tmp,$TMP
else
   set directory=~/tmp
end

highlight Search cterm=underline  " use underline in color terminal for search matches

let mapleader=","

" key binding for toggle paste
set pastetoggle=<leader>p

" Restore cursor position
autocmd BufReadPost *
	\ if line("'\"") > 1 && line("'\"") <= line("$") |
	\   exe "normal! g`\"" |
	\ endif

" Enable matchit.vim plugin, used by vim-textobj-rubyblock plugin
runtime macros/matchit.vim

" Use ag instead of ack
let g:ackprg = 'ag --nogroup --nocolor --column'

" Fix snippet issue on Windows
if has('win32') || has('win64')
	let snippets_dir = substitute(substitute(globpath(&rtp, 'snippets/'), "\n", ',', 'g'), 'snippets\\,', 'snippets,', 'g')
end

" tsuquyomi
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi'] " You shouldn't use 'tsc' checker.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256 " 256 colors
set background=dark
" color grb256
colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make saving and closing file easier
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>qq :qa<cr>

" Make copying to system clipboard easier
map <leader>y "+y

" Show invisible characters - use vim-umipaired instead
" nmap <leader>l :set list!<CR>  " Shortcut to rapidly toggle `set list`

" Insert a hash rocket with <c-l>
imap <c-l> <space>=><space>
" Insert a stabby lambda with <c-k>
imap <c-k> <space>-><space>
" Insert a pipe operator with <c-p>
imap <c-p> \|><space>
imap <c-r> <space><\|<space>

" Open Gst window in fugitive
nnoremap <leader>f :Gst<cr>

" Use k, j, 0 and $ linewise
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$

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
" nnoremap <leader>a <c-^>

" map ctrl+p/n to Up/Down (filters commands in history)
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
let g:ctrlp_user_command='ag %s -l --nocolor --hidden -g ""'

" map leader-U to upcase the current word
nmap <leader>U gUiw

" map space to toggle fold
nnoremap <Space> za

" map shortcuts to change foldmethod
map <leader>fi :setlocal foldmethod=indent<cr>
map <leader>fs :setlocal foldmethod=syntax<cr>

" search word under cursor in Dash.app
nmap <silent> <c-\> <Plug>DashSearch

" Set region to American English
set spelllang=en_us

function! SolarizedDark()
	:colorscheme solarized
	:set background=dark
endfunction

function! SolarizedLight()
	:colorscheme solarized
	:set background=light
endfunction

map <leader>sd :exec SolarizedDark()<cr>
map <leader>sl :exec SolarizedLight()<cr>


" set indentation to be four spaces
map ,tt :set tabstop=4 shiftwidth=4 softtabstop=4 expandtab<cr>

" toggle NERDTree pane
map ,d :NERDTreeToggle<cr>

" open and close quick fix window (for vim-dispatch)
nmap <leader>co :Copen<cr>
nmap <leader>cl :cclose<cr>

if has('nvim')
  " terminal mode mapping
  " tnoremap <C-v><Esc> <Esc>
  " tnoremap <Esc> <C-\><C-n>
  tnoremap <C-[> <C-\><C-n>
  " tnoremap <c-h> <c-\><c-n><c-w>h
  " tnoremap <c-j> <c-\><c-n><c-w>j
  " tnoremap <c-k> <c-\><c-n><c-w>k
  " tnoremap <c-l> <c-\><c-n><c-w>l

  " highlight terminal cursor
  highlight! link TermCursor Cursor
  highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle relativenumber
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! NumberToggle()
	if(&relativenumber == 1)
		set norelativenumber
	else
		set relativenumber
	endif
endfunction

nnoremap <leader>rn :call NumberToggle()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AUTO-RESIZE SPLITS, FROM THOUGHTBOT VIM SCREENCAST
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set winwidth=84
" set winheight=8
" set winminheight=8
" set winheight=999

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PREFER COMBINATIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>
imap <BS> <Nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cnoremap %% <C-R>=expand('%:h').'/'<cr>
" map <leader>e :edit %%
" map <leader>s :split %%
" map <leader>v :vnew %%

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CONFIGS FOR PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic plugin
let g:syntastic_auto_loc_list=1  " Syntastic: automatically open and close quick fix window for errors
let g:syntastic_javascript_checkers=["eslint"]
let g:syntastic_html_checkers=['']

" Tagbar plugin
" Tagbar: use F9 to toggle
nnoremap <silent> <F9> :TagbarToggle<CR>

" Taglist-plus plugin
nnoremap <silent> <F8> :TlistToggle<CR>
let Tlist_Use_Right_Window=1  " Taglist-plus: display window on the right
let Tlist_Show_One_File=1  " Taglist-plus: show tags for teh current buffer only
let Tlist_GainFocus_On_ToggleOpen=1  " Taglist-plus: move focus to taglist when :TlistToggle command was invoked

" ctrlp plugin - ignore the following file/dir
" let g:ctrlp_custom_ignore = {
" \	'dir': '\.git$\|build$\|docs$\|node_modules$',
" \	'file': '\.exe$\|\.dll$\|\.pdb$\|\.jpg$\|\.png$\|\.gif$\|\.pdf$\|\.swp$'
" \	}
let g:ctrlp_map = '<c-m>'

" FZF
nnoremap <C-p> :<C-u>Files<CR>
nnoremap <C-p><C-f> :<C-u>Buffers<CR>
" TODO: how to let fzf accept ctrl-f
" let g:fzf_action = {
"   \ 'ctrl-f': 'Buffers',
"   \ 'ctrl-t': 'tab split',
"   \ 'ctrl-x': 'split',
"   \ 'ctrl-v': 'vsplit' }

" For JavaScript files, use `eslint` (and only eslint)
 let g:ale_linters = {
 \   'javascript': ['eslint'],
 \   'typescript': ['tslint']
 \ }
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_save = 1  " default
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
" Mappings in the style of unimpaired-next
" nmap <silent> [W <Plug>(ale_first)
" nmap <silent> [w <Plug>(ale_previous)
" nmap <silent> ]w <Plug>(ale_next)
" nmap <silent> ]W <Plug>(ale_last)

let g:grepper       = {}
let g:grepper.tools = ['rg', 'git', 'grep']
function! SetupCommandAlias(input, output)
    exec 'cabbrev <expr> '.a:input
            \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:input.'")'
            \ .'? ("'.a:output.'") : ("'.a:input.'"))'
endfunction
call SetupCommandAlias("rg", "GrepperRg")

" Search for the current word
nnoremap <Leader>* :Grepper -cword -noprompt<CR>

" Search for the current selection
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" vim-test
let test#strategy = "dispatch"

" vim-trailing-whitespace plugin
nmap <leader>ws :FixWhitespace<CR>

" disable GoldenView's default mappings
let g:goldenview__enable_default_mapping = 0

" tmuxline
let g:tmuxline_separators = {
    \ 'left' : '',
    \ 'left_alt': '>',
    \ 'right' : '',
    \ 'right_alt' : '<',
    \ 'space' : ' '}

" vim-coffee-script and coffee-lint
let coffee_linter = '/usr/local/bin/coffeelint'

" dash.vim
let g:dash_map = {
	\ 'ruby' : ['ruby', 'ruby19', 'rails', 'rails4'],
	\ 'coffee' : ['js', 'underscore', 'angularjs', 'coffee']
	\ }

" RSpec.vim mappings
let g:rspec_command="Dispatch bin/rspec {spec}"
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

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
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
	let new_file = AlternateForCurrentFile()
	exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
	let current_file = expand("%")
	let new_file = current_file
	let in_spec = match(current_file, '^spec/') != -1
	let going_to_spec = !in_spec
	let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
	if going_to_spec
		if in_app
			let new_file = substitute(new_file, '^app/', '', '')
		end
		let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
		let new_file = 'spec/' . new_file
	else
		let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
		let new_file = substitute(new_file, '^spec/', '', '')
		if in_app
			let new_file = 'app/' . new_file
		end
	endif
	return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

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
" PUT SCRIPTNAMES RESULT INTO SCRATCH BUFFER
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:Scratch (command, ...)
   redir => lines
   let saveMore = &more
   set nomore
   execute a:command
   redir END
   let &more = saveMore
   call feedkeys("\<cr>")
   new | setlocal buftype=nofile bufhidden=hide noswapfile
   put=lines
   if a:0 > 0
      execute 'vglobal/'.a:1.'/delete'
   endif
   if a:command == 'scriptnames'
      %substitute#^[[:space:]]*[[:digit:]]\+:[[:space:]]*##e
   endif
   silent %substitute/\%^\_s*\n\|\_s*\%$
   let height = line('$') + 3
   execute 'normal! z'.height."\<cr>"
   0
endfunction

command! -nargs=? Scriptnames call <sid>Scratch('scriptnames', <f-args>)
command! -nargs=+ Scratch call <sid>Scratch(<f-args>)

" Enable seeing-is-believing mappings only for Ruby
augroup seeingIsBelievingSettings
  autocmd!

  autocmd FileType ruby nmap <buffer> <leader>rb <Plug>(seeing-is-believing-mark-and-run)
  autocmd FileType ruby xmap <buffer> <leader>rb <Plug>(seeing-is-believing-mark-and-run)

  autocmd FileType ruby nmap <buffer> <leader>rm <Plug>(seeing-is-believing-mark)
  autocmd FileType ruby xmap <buffer> <leader>rm <Plug>(seeing-is-believing-mark)
  autocmd FileType ruby imap <buffer> <leader>rm <Plug>(seeing-is-believing-mark)

  autocmd FileType ruby nmap <buffer> <leader>rr <Plug>(seeing-is-believing-run)
  autocmd FileType ruby imap <buffer> <leader>rr <Plug>(seeing-is-believing-run)
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" JUNKDRAWER
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" sample highlight (space or tab) syntax
"highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
"highlight ExtraTabs ctermbg=red guibg=red
"match ExtraWhitespace /\s\+$/
"match ExtraTabs /\t\+/
