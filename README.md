# 我的vim配置文件

**文件列表**

- `.vimrc` for linux  

- `_vimrc` for windows  

- `build_mingw.sh`,用于在windows使用MinGw编译vim源代码的小脚本。

# vimrc

.vimrc和_vimrc的内容是一样的，你可以将_vimrc拿到linux发行版下用，仅仅需要更换名称和转换文本格式为UNIX即可(可以使用`dos2unix工具`)。

下面用一些截图来说明使用我这个配置之后能完成的功能:

1. 万能补全，采用[Shougo的neocomplete插件](https://github.com/Shougo/neocomplete.vim),对多种编程语言补全很好，但是对java和c++这些不给力。

	![Vim completion with animation.](https://f.cloud.github.com/assets/214488/623496/94ed19a2-cf68-11e2-8d33-3aad8a39d7c1.gif)

2. 插件管理是[vundle](https://github.com/gmarik/Vundle.vim)，此插件可以通过git和github代码托管网站在线更新插件，一句话评论：够用

	![my plugin list](https://cloud.githubusercontent.com/assets/4246425/3328131/c0472718-f7b8-11e3-87ab-3483a2bfd61e.png)

3. [CtrlP](https://github.com/kien/ctrlp.vim)，当前目录及其子目录快速定位打开文件，历史记录，书签，tags和缓冲区等，一句话评论:神器。

	![ctrlp](https://cloud.githubusercontent.com/assets/4246425/3328197/a0574cfc-f7b9-11e3-86c1-0dc9ab460e91.png)

4. 文件管理器[VimExplorer](https://github.com/mbbill/VimExplorer.git),拥有几乎所有文件浏览器的功能，移动、复制、粘贴、书签、重命名和调用外部程序打开对应后缀的文件。它是直接调用的是系统的命令。它的操作当然是VIM模式，比如说p就是粘贴..dd就是删除..

	![VimExplorer](https://cloud.githubusercontent.com/assets/4246425/3328302/1a53973a-f7bb-11e3-9159-5698f91b4bd8.png)

5. [TagBar](https://github.com/majutsushi/tagbar.git)，这个大家很熟悉了，就是浏览源代码的tags.这个插件比[vim.org](www.vim.org)上下载量最高的taglist要好用和准确。

	![tagbar](https://cloud.githubusercontent.com/assets/4246425/3328527/8bbe2bcc-f7bd-11e3-9f8e-fcba3f34cb17.png)

6. [vim-startify](https://github.com/mhinz/vim-startify)，定制你的"开机启动画面"，有点夸大，其实这个插件就是代替打开vim时显示的内容，取而代之的是自定义字符（可以用字符画出你能画出来的东西），还有列出最近打开的文件和已经保存的会话，支持快捷键快速打开(没一行前面的字符)

	![startify](https://cloud.githubusercontent.com/assets/4246425/3328744/7a04d42e-f7bf-11e3-9eb0-6fd8ea07deed.png)

7. [ultisnips](https://github.com/SirVer/ultisnips)，也就是代码片段生成，插件本身自带了很多种的snippets，自己定义snippets也非常简单，一句话评价：神器

	![GIF Demo](https://raw.github.com/SirVer/ultisnips/master/doc/demo.gif)

8. [vimshell](https://github.com/Shougo/vimshell.vim)，这是目前为止比较好的在vim中嵌入shell的解决方案。



# build_mingw

`build_mingw.sh`是一个可以在MinGw(Win32下的gcc编译器,或者说gnu命令行集合环境)下运行的shell脚本,它的功能就是从源代码中编译可在win32平台下的运行的gvim和vim。在运行脚本之前你必须安装以下必要的组件:

1. mercurial hg,这是获最新vim源代码的CVS工具.并且将hg加入Path环境变量

2. ruby200安装于C:\Ruby200目录

3. python32安装与C:\Python32目录

4. python27安装与C:\Python27目录

5. tcl85安装于C:\Tcl

6. lua51安装于C:\Lua\5.1

7. MinGw

**语法**

```bash
./build_mingw.sh all|gvim|vim|clean|install|getsrc|uninstall  
```

	all			:build gvim and vim then install it to /d/Program Files/Vim  [^tes]

	gvim		:get src if not exist then build gvim  

	vim			:get src if not exist then build vim  

	install		:install gvim to /d/Program Files/Vim  

	uninstall	:uninstall vim from /d/Program Files/Vim  

	getsrc		:use hg command to get vim's source  

