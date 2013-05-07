#!/bin/sh
sudo apt-get install grep curl ctags cscope 
sudo apt-get build-dep vim
sudo apt-get python3-dev wmctrl
hg clone https://vim.googlecode.com/hg/ vim
git clone https://github.com/larrupingpig/vimgdb-for-vim7.3.git
cd ./vim/src
patch  -p2 < ../../vimgdb-for-vim7.3/vim73.patch

./configure --prefix=/opt/vim73 --with-x --enable-gui=auto --with-features=huge --enable-gdb --enable-cscope --enable-multibyte --enable-fontset --with-compiledby="tracyone<tracyone@live.cn>" --enable-pythoninterp=dynamic --enable-python3interp=dynamic --enable-tclinterp --enable-rubyinterp=dynamic --enable-xim --with-python-config-dir=/usr/lib/python2.7/ --with-python3-config-dir=/usr/lib/python3.3/

make 
sudo make install
cd ../../
rm -rf vimgdb-for-vim7.3-master
rm -rf vim
mkdir ~/.vim/
cd ~/.vim/
git clone https://github.com/tracyone/vim.git
ln -s ./vim/.vimrc ~/.vimrc
