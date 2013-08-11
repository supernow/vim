vim config
===

1,.vimrc for linux _vimrc for windows.
	put .vimrc in your home dir and _vimrc in your $VIM dir

2,build_mingw.sh:a shell script to build shell script and install in mingw
				it will work in other shell like cygwin
 usage         :usage:./build_mingw.sh all|gvim|vim|clean|install|getsrc|uninstall
"all:build gvim and vim then install to /d/Program Files/Vim"
"gvim:get src if not exist then build gvim"
"vim:get src if not exist then build vim"
"install:install gvim to /d/Program Files/Vim"
"uninstall:vim from /d/Program Files/Vim"
"getsrc:use hg command to get vim\'s source "


