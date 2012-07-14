call pathogen#infect()

set nu  " turn on line numbering
set nrformats=  " treat numbers as decimals (default is octal)
set shiftwidth=2 softtabstop=2 expandtab  "  tab settings
set wildmode=longest,list  " bash-style tab completion
set history=200  " record 200 Ex commands in history
set autoindent  " turn on autoindent
set hlsearch  " turn on highlight for search
set backspace=indent,eol,start  " Backspace over everything in insert mode, http://superuser.com/questions/202848/backspace-key-not-working-in-vim

syntax on  " enable syntax
filetype plugin indent on  " enable filetype plugin

set directory^=$HOME/.vim_swap//   "put all swap files together in one place

let g:syntastic_auto_loc_list=1  " Syntastic: automatically open and close quick fix window for errors
let g:syntastic_javascript_checker="jshint"  " Syntastic: use JSHint in Syntastic plugin

" Tagbar: use F9 to toggle
nnoremap <silent> <F9> :TagbarToggle<CR>
