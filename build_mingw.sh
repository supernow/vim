#!/bin/bash
# author        :tracyone
# date          :2013-08-11/10:54:37
# description   :build gvim/vim from src;install;clean;
# usage         :usage:./build_mingw.sh all|gvim|vim|clean|install|getsrc
#                       "all:build gvim and vim then install
#                       "gvim:get src if not exist then build gvim"
#                       "vim:get src if not exist then build vim"
#                       "install:install gvim 
#                       "getsrc:use hg command to get vim\'s source "

#Download vim source by tortoisehg
#default install directory
INSTALL_DIR="/d/Program Files/Vim"

CUR_DIR="$(pwd)"

function getsrc(){
which thg
if [ "$?" == 0 ];then
    echo -e "get vim src from the internet!"
    echo -e "This may take for a moment"
    sleep 2
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
if [ -d "vim" -a -d "vim/src" ];then
    echo -e "we found vim src directory!"
    read -p 'Do you want to upadte vim source??[y]' UPDATE_OR_NOT
    if [[ "${UPDATE_OR_NOT}" == "" || "${UPDATE_OR_NOT}" == "y" ]]; then
        cd vim/src
        make -f Make_ming.mak clean
        cd ..
        
        hg pull
        while [ "$?" -ne 0 ]
        do
            
            hg pull 
            
            hg update
        done
        
        hg update
        cd ..
    fi
else
    echo -e "srcdir:vim was not found!"
    sleep 2
    getsrc
    cd vim/src
fi
cd vim/src
if [ "$1" == "vim" ];then
    make -f Make_ming.mak FEATURES=HUGE GUI=no OLE=yes STATIC_STDCPLUS=yes  LUA=/c/Lua/5.1 LUA_VER=51 PYTHON=/c/Python27 DYNAMIC_PYTHON=yes PYTHON_VER=27  PYTHON3=/c/Python32 DYNAMIC_PYTHON3=yes PYTHON3_VER=32 TCL=/c/Tcl DYNAMIC_TCL=yes TCL_VER=85 RUBY=/c/Ruby200 DYNAMIC_RUBY=yes RUBY_VER=200 RUBY_VER_LONG=2.0.0 RUBY_PLATFORM=i386-mingw32 USERNAME=tracyone\<raoxiaowen USERDOMAIN=gmail.cn\>
    if [ "$?" -ne 0 ]; then
        echo "Make sure you have installed softwares below:"
        echo "ruby200 in /c/Ruby200"
        echo "python32 in /c/Python32"
        echo "python27 in /c/Python27"
        echo "tcl85 in /c/Tcl"
        echo "lua51 in /c/Lua/5.1"
    fi
elif [ "$1" == "gvim" ];then
    make -f Make_ming.mak FEATURES=HUGE OLE=yes STATIC_STDCPLUS=yes  LUA=/c/Lua/5.1 LUA_VER=51 PYTHON=/c/Python27 DYNAMIC_PYTHON=yes PYTHON_VER=27  PYTHON3=/c/Python32 DYNAMIC_PYTHON3=yes PYTHON3_VER=32 TCL=/c/Tcl DYNAMIC_TCL=yes TCL_VER=85 RUBY=/c/Ruby200 DYNAMIC_RUBY=yes RUBY_VER=200 RUBY_VER_LONG=2.0.0 RUBY_PLATFORM=i386-mingw32 USERNAME=tracyone\<raoxiaowen USERDOMAIN=gmail.com\>
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
mkdir -p "${INSTALL_DIR}/vim74"

echo -e "@echo off\n" > uninstall.bat
echo -e "taskkill /f /im explorer.exe\n" >> uninstall.bat
echo -e "vim74\\uninstal.exe\n" >> uninstall.bat
echo -e "wmic process call create explorer.exe\n" >> uninstall.bat
echo -e "cd ..\n" >> uninstall.bat
echo -e "rmdir /s /q Vim" >> uninstall.bat
echo -e "echo Uninstall finish!" >> uninstall.bat
cp uninstall.bat "${INSTALL_DIR}"
mv uninstall.bat "/c/Documents and Settings/Administrator/"

cd vim
mkdir vim74
echo -e "start copy...\n"
cp -a runtime/* vim74
cp -a src/*.exe vim74
cp -a src/GvimExt/gvimext.dll vim74
cp -a src/xxd/xxd.exe vim74
cp -a vimtutor.bat vim74
cp -a vim74/* "${INSTALL_DIR}/vim74"
echo -e "copy finish...\n"
echo -e "start install....\n"
rm -rf vim74
echo "d" | "${INSTALL_DIR}/vim74/install.exe"
cd ..
}

#start process
if [ "$#" -ne 1 ]; then
    echo -e "Error!!!lack of argument."
    echo -e "usage:$0 all|gvim|vim|clean|install|getsrc|uninstall"
    echo -e "all:\t\tbuild gvim and vim then install"
    echo -e "gvim:\t\tget src if not exist then build gvim"
    echo -e "vim:\t\tget src if not exist then build vim"
    echo -e "install:\tinstall gvim"
    echo -e "uninstall:\tuninstall vim"
    echo -e "getsrc:\t\tuse hg command to get vim\'s source "
    exit 0  
else
    
    read -p "Input the directory you want to install Vim[/d/Program Files/Vim]" user_input
    if [[ "${user_input}" == "" || "${user_input}" == "y" ]]; then
        INSTALL_DIR="/d/Program Files/Vim"
    else
        while [[ ! -d "${user_input}" ]]; do
            echo "The ${user_input} is not exist,we will create it!"
            mkdir "${user_input}"
            if [[ $? -ne 0 ]]; then
                echo "Create ${user_input} failed"
                read -p "Input another directory you want to install Vim[/d/Program Files/Vim]" user_input
            fi
        done
        INSTALL_DIR=${user_input}
    fi
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
        cp -a vim/src/vim.exe "${INSTALL_DIR}/vim74/"
    else
        echo -e "Argument Error!!"
        echo -e "usage:$0 all|gvim|vim|clean|install|getsrc|uninstall"
        echo -e "all:\t\tbuild gvim and vim then install"
        echo -e "gvim:\t\tget src if not exist then build gvim"
        echo -e "vim:\t\tget src if not exist then build vim"
        echo -e "install:\tinstall gvim"
        echo -e "uninstall:\tuninstall vim"
        echo -e "getsrc:\t\tuse hg command to get vim\'s source "
        exit 0
    fi
fi
# vim:ft=sh:sw=4:et:nu:fdm=indent:fdl=100
