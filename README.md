Installation:

    git clone git://github.com/luislee818/dotvim.git ~/.vim

Create symlinks:

    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/gvimrc ~/.gvimrc

Switch to the `~/.vim` directory, and fetch submodules:

    cd ~/.vim
    git submodule init
    git submodule update

Borrowed from [Drew Neil](https://github.com/nelstrom), see [his episode of VimCast](http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/) for details.