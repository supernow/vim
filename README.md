vim config
===

.vimrc for linux  

_vimrc for windows  
			
build_mingw.sh
===

build_mingw.sh is a shell script to build vim7.4 with MinGw and install it into /d/Program\ Files\Vim  

usage:  
   ./build_mingw.sh all|gvim|vim|clean|install|getsrc|uninstall  

	all			:build gvim and vim then install it to /d/Program Files/Vim  

	gvim		:get src if not exist then build gvim  

	vim			:get src if not exist then build vim  

	install		:install gvim to /d/Program Files/Vim  

	uninstall	:uninstall vim from /d/Program Files/Vim  

	getsrc		:use hg command to get vim's source  



