call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

set nu  " turn on line numbering
set nrformats=  " treat numbers as decimals (default is octal)
set shiftwidth=2 softtabstop=2 expandtab  "  tab settings
set wildmode=longest,list  " bash-style tab completion
set history=200  " record 200 Ex commands in history
set autoindent  " turn on autoindent
set hlsearch  " turn on highlight for search
set backspace=indent,eol,start  " Backspace over everything in insert mode, http://superuser.com/questions/202848/backspace-key-not-working-in-vim
syntax on  " enable syntax highlighting