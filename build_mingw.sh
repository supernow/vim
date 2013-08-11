#!/bin/bash
# author        :tracyone
# date          :2013-08-11/10:54:37
# description   :build gvim/vim from src;install;clean;
# usage         :usage:./build_mingw.sh all|gvim|vim|clean|install|getsrc|uninstall
#echo -e "all:build gvim and vim then install to /d/Program Files/Vim"
#echo -e "gvim:get src if not exist then build gvim"
#echo -e "vim:get src if not exist then build vim"
#echo -e "install:install gvim to /d/Program Files/Vim"
#echo -e "uninstall:vim from /d/Program Files/Vim"
#echo -e "getsrc:use hg command to get vim\'s source "
# history       :
function getsrc(){
which thg
if [ "$?" == 0 ];then
    echo -e "deleting old vim source..."
    echo -e "This may take for a moment"
    rm -rf vim
    echo -e "clone vim src to local.... "
    hg clone --verbose -- https://vim.googlecode.com/hg/ vim
    while [ "$?" -ne 0 ]
    do
        echo "Try again,press ctrl-c to exit"
        sleep 3
        hg clone --verbose -- https://vim.googlecode.com/hg/ vim
    done
else
    echo -e "Error!!thg command not found!!"
    echo -e "You may forget add thg in your Path env"
    echo -e "You can download thg from:http://tortoisehg.bitbucket.org/"
    exit 0
fi
}
function build_vim(){
if [ -d "vim" ];then
    echo -e "we found vim src directory!"
    echo -e "start build...."
    cd vim/src
    make -f Make_ming.mak clean
else
    echo -e "srcdir:vim was not found!"
    echo -e "get vim src from the internet!"
    getsrc
    cd vim/src
fi
if [ "$1" == "vim" ];then
    make -f Make_ming.mak FEATURES=HUGE GUI=no OLE=yes STATIC_STDCPLUS=yes  LUA=/c/Lua/5.1 LUA_VER=51 PYTHON=/c/Python27 DYNAMIC_PYTHON=yes PYTHON_VER=27  PYTHON3=/c/Python32 DYNAMIC_PYTHON3=yes PYTHON3_VER=32 TCL=/c/Tcl DYNAMIC_TCL=yes TCL_VER=85 RUBY=/c/Ruby200 DYNAMIC_RUBY=yes RUBY_VER=200 RUBY_VER_LONG=2.0.0 RUBY_PLATFORM=i386-mingw32 USERNAME=tracyone\<tracyone USERDOMAIN=live.cn\>
    if [ "$?" -ne 0 ]; then
        echo "Make sure you have installed softwares below:"
        echo "ruby200 in /c/Ruby200"
        echo "python32 in /c/Python32"
        echo "python27 in /c/Python27"
        echo "tcl85 in /c/Tcl"
        echo "lua51 in /c/Lua/5.1"
    fi
elif [ "$1" == "gvim" ];then
    make -f Make_ming.mak FEATURES=HUGE OLE=yes STATIC_STDCPLUS=yes  LUA=/c/Lua/5.1 LUA_VER=51 PYTHON=/c/Python27 DYNAMIC_PYTHON=yes PYTHON_VER=27  PYTHON3=/c/Python32 DYNAMIC_PYTHON3=yes PYTHON3_VER=32 TCL=/c/Tcl DYNAMIC_TCL=yes TCL_VER=85 RUBY=/c/Ruby200 DYNAMIC_RUBY=yes RUBY_VER=200 RUBY_VER_LONG=2.0.0 RUBY_PLATFORM=i386-mingw32 USERNAME=tracyone\<tracyone USERDOMAIN=live.cn\>
    if [ "$?" -ne 0 ]
    then
        echo "Make sure you have installed softwares below:"
        echo "ruby200 in /c/Ruby200"
        echo "python32 in /c/Python32"
        echo "python27 in /c/Python27"
        echo "tcl85 in /c/Tcl"
        echo "lua51 in /c/Lua/5.1"
    fi
else
    echo -e "function build_vim error!"
    exit 0
fi
cd ../..
}
function install(){
if [ "$1" == "uninstall" ]
then
    /d/Program\ Files/Vim/vim74/uninstal.exe
    taskkill //f //im explorer.exe
echo -e "clean up...this take for a while.."
    rm -rf /d/Program\ Files/Vim/
    echo -e "restart explorer.exe"
    sleep 3
    wmic process call create explorer.exe
else
    cd vim
    mkdir -p /d/Program\ Files/Vim/vim74
    mkdir vim74
    echo -e "start copy..."
    cp -a runtime/* vim74
    cp -a src/*.exe vim74
    cp -a src/GvimExt/gvimext.dll vim74
    cp -a src/xxd/xxd.exe vim74
    cp -a vimtutor.bat vim74
    cp -a vim74/* /d/Program\ Files/Vim/vim74
    echo -e "copy finish..."
    rm -rf vim74
    /d/Program\ Files/Vim/vim74/install.exe
    cd ..
fi
}
#start process
date
if [ "$#" -ne 1 ]; then
    echo -e "Error!!!lack of argument."
    echo -e "usage:$0 all|gvim|vim|clean|install|getsrc|uninstall"
    echo -e "all:\t\tbuild gvim and vim then install to /d/Program Files/Vim"
    echo -e "gvim:\t\tget src if not exist then build gvim"
    echo -e "vim:\t\tget src if not exist then build vim"
    echo -e "install:\tinstall gvim to /d/Program Files/Vim"
    echo -e "uninstall:\tuninstall vim from /d/Program Files/Vim"
    echo -e "getsrc:\t\tuse hg command to get vim\'s source "
    exit 0  
else
    if [ "$1" == "gvim" ]; then
        build_vim gvim
    elif [ "$1" == "vim" ]; then
        build_vim vim
    elif [ "$1" == "clean" ]; then
        cd vim/src
        rm -rf obji386/
        make -f Make_ming.mak clean
    elif [ "$1" == "install" ]; then
        install
    elif [ "$1" == "getsrc" ]; then
        getsrc
    elif [ "$1" == "all" ]; then
        build_vim gvim
        install
        build_vim vim
        cp -a vim/src/vim.exe /d/Program\ Files/Vim/vim74/
    elif [ "$1" == "uninstall" ]; then
        install uninstall
    else
        echo -e "Argument Error!!"
        echo -e "usage:$0 all|gvim|vim|clean|install|getsrc|uninstall"
        echo -e "all:\t\tbuild gvim and vim then install to /d/Program Files/Vim"
        echo -e "gvim:\t\tget src if not exist then build gvim"
        echo -e "vim:\t\tget src if not exist then build vim"
        echo -e "install:\tinstall gvim to /d/Program Files/Vim"
        echo -e "uninstall:\tuninstall vim from /d/Program Files/Vim"
        echo -e "getsrc:\t\tuse hg command to get vim\'s source "
        exit 0
    fi
fi
# vim:ft=sh:sw=4:et:nu:fdm=indent:fdl=100
