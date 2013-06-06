#!/bin/sh
sudo apt-get install grep curl ctags cscope 
sudo apt-get build-dep vim
sudo apt-get install  python3-dev wmctrl
hg clone https://vim.googlecode.com/hg/ vim
git clone https://github.com/larrupingpig/vimgdb-for-vim7.3.git
cd ./vim/src

./configure  --with-x --enable-gui=auto --with-features=huge --enable-gdb --enable-cscope --enable-multibyte --enable-fontset --with-compiledby="tracyone<tracyone@live.cn>" --enable-pythoninterp=yes --enable-tclinterp --enable-rubyinterp=dynamic --enable-xim 
#sudo make uninstall
make 
sudo make install
cd ../../
git clone https://github.com/tracyone/vim.git
ln -s ~/.vim/vim/.vimrc ~/.vimrc
