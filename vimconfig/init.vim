set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vim/vimrc

if has("gui_vimr")
  set background=light
  :colorscheme railscasts
  let &colorcolumn = 0
endif
