"@file       .vimrc & _vimrc
"@brief      config file of vim and gvim for both windows and linux
"@date       2012-12-30 11:01:30
"@author     tracyone,tracyone@live.cn
"@lastchange 2014-04-09/01:04:28
"@note:		Prior to use, in the case of windows vim convert this file's 
"			format into dos,while convert it into unix format in the case 
"			of linux vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"encode {{{
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb1830,big5,euc-jp,euc-kr,gbk
if v:lang=~? '^\(zh\)\|\(ja\)\|\(ko\)'
    set ambiwidth=double
endif
source $VIMRUNTIME/delmenu.vim
lan mes en_US.UTF-8
"set langmenu=nl_NL.ISO_8859-1
"}}}
"system check{{{
if (has("win32")) || has("win64")
    let $HOME=$VIM
    set filetype=dos
    set ffs=dos,unix,mac
    set path=.,d:/MinGW/include/,d:/MinGW/msys/1.0/include
    let $VIMFILES = $VIM.'/vimfiles'
    let g:iswindows=1 "windows menu_flags
elseif has("unix")
    set filetype=unix
    set ffs=unix
    set keywordprg=""
    set shell=bash
    set path=.,/usr/include/,/usr/include/c++/4.7/ "c++ is in /usr/include/c++/...
    let $VIMFILES = $HOME.'/.vim'
    let g:iswindows=0
elseif has("mac")
endif
"}}}
"basic setting{{{
"{{{fold setting
"folding type: "manual", "indent", "expr", "marker" or "syntax"
set foldenable                  " enable folding
autocmd FileType c,cpp set foldmethod=syntax 
autocmd FileType verilog set foldmethod=marker 
autocmd FileType verilog set foldmarker=begin,end 
autocmd FileType sh set foldmethod=indent
set foldlevel=100         " start out with everything folded
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
set foldcolumn=1
function! MyFoldText()
    let line = getline(v:foldstart)
    if match( line, '^[ \t]*\(\/\*\|\/\/\)[*/\\]*[ \t]*$' ) == 0
        let initial = substitute( line, '^\([ \t]\)*\(\/\*\|\/\/\)\(.*\)', '\1\2', '' )
        let linenum = v:foldstart + 1
        while linenum < v:foldend
            let line = getline( linenum )
            let comment_content = substitute( line, '^\([ \t\/\*]*\)\(.*\)$', '\2', 'g' )
            if comment_content != ''
                break
            endif
            let linenum = linenum + 1
        endwhile
        let sub = initial . ' ' . comment_content
    else
        let sub = line
        let startbrace = substitute( line, '^.*{[ \t]*$', '{', 'g')
        if startbrace == '{'
            let line = getline(v:foldend)
            let endbrace = substitute( line, '^[ \t]*}\(.*\)$', '}', 'g')
            if endbrace == '}'
                let sub = sub.substitute( line, '^[ \t]*}\(.*\)$', '...}\1', 'g')
            endif
        endif
    endif
    let n = v:foldend - v:foldstart + 1
    let info = " " . n . " lines"
    let sub = sub . "                                                                                                                  "
    let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
    let fold_w = getwinvar( 0, '&foldcolumn' )
    let sub = strpart( sub, 0, winwidth(0) - strlen( info ) - num_w - fold_w - 1 )
    return sub . info
endfunction
set foldtext=MyFoldText()
nnoremap <silent><Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
"}}}
"list candidate word in statusline
set wildmenu
set wildmode=longest,full
set wic
"set list  "display unprintable characters by set list
set listchars=tab:\|\ ,trail:-  "Strings to use in 'list' mode and for the |:list| command
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif "jump to last position last open in vim
"{{{backup
set backup "generate a backupfile when open file
set backupext=.bak  "backup file'a suffix
set backupdir=$VIMFILES/vimbackup  "backup file's directory
if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
endif
"}}}
"do not Ring the bell (beep or screen flash) for error messages
set noerrorbells
set mat=2  
set report=0  "Threshold for reporting number of lines changed
set lazyredraw  " Don't update the display while executing macros
set helplang=en,cn  "set helplang=en
set autoread   "autoread when a file is changed from the outside
set nonu  "show the line number for each line
set cmdheight=1  "number of lines used for the command-line
set showmatch "when inserting a bracket, briefly jump to its match
set printfont=Yahei_Mono:h10:cGB2312  "name of the font to be used for :hardcopy
set smartcase  "override 'ignorecase' when pattern has upper case characters
set confirm  "start a dialog when a command fails
set smartindent "do clever autoindenting
"set nowrap   "don't auto linefeed
set cindent  "enable specific indenting for C code
set tabstop=4  "number of spaces a <Tab> in the text stands for
set softtabstop=4  "if non-zero, number of spaces to insert for a <Tab>
set smarttab "a <Tab> in an indent inserts 'shiftwidth' spaces
set hlsearch "highlight all matches for the last used search pattern
set shiftwidth=4 "number of spaces used for each step of (auto)indent
set showmode "display the current mode in the status line
"set ruler  "show cursor position below each window
set selection=inclusive  ""old", "inclusive" or "exclusive"; how selecting text behaves
set is  "show match for partly typed search command
"set lbr "wrap long lines at a character in 'breakat'
set backspace=indent,eol,start  "specifies what <BS>, CTRL-W, etc. can do in Insert mode
set whichwrap=b,h,l,<,>,[,]  "list of menu_flags specifying which commands wrap to another line
set mouse=a "list of menu_flags for using the mouse,support all

"unnamed" to use the * register like unnamed register
"autoselect" to always put selected text on the clipboardset clipboard+=unnamed
set clipboard+=unnamed
"set autochdir  "change to directory of file in buffer

"statuslne
set statusline+=%<%t%m%r%h%w%{tagbar#currenttag('[%s]','')}
set statusline+=%=[%{(&fenc!=''?&fenc:&enc)}\|%{&ff}\|%Y][%l,%v][%p%%] 
set statusline+=[%{strftime(\"%m/%d\-\%H:%M\")}]
set guitablabel=%N\ %t  "do not show dir in tab
"0, 1 or 2; when to use a status line for the last window
set laststatus=2 "always show status
set stal=1  "always show the tabline
set sessionoptions-=folds
set sessionoptions-=options

"automatic recognition vt file as verilog 
au BufRead,BufNewFile *.vt set filetype=verilog
"automatic recognition bld file as javascript 
au BufRead,BufNewFile *.bld set filetype=javascript
"automatic recognition xdc file as javascript
au BufRead,BufNewFile *.xdc set filetype=javascript
au BufRead,BufNewFile *.mk set filetype=make
au BufRead,BufNewFile *.make set filetype=make
au BufRead,BufNewFile *.veo set filetype=verilog
au BufRead,BufNewFile * let $CurBufferDir=expand('%:p:h')
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} map <Leader>p :call system("google-chrome " .  shellescape(expand('%')) . " &")<cr>
au FileType verilog set tabstop=3
au FileType verilog set shiftwidth=3
au FileType verilog set softtabstop=3
au FileType c,cpp,java,vim,verilog set expandtab "instead tab with space 
au FileType make set noexpandtab

"##### auto fcitx  ###########
if(!has("gui_running"))
    let g:input_toggle = 1
    function! Fcitx2en()
        let s:input_status = system("fcitx-remote")
        if s:input_status == 2
            let g:input_toggle = 1
            let l:a = system("fcitx-remote -c")
        endif
    endfunction

    function! Fcitx2zh()
        let s:input_status = system("fcitx-remote")
        if s:input_status != 2 && g:input_toggle == 1
            let l:a = system("fcitx-remote -o")
            let g:input_toggle = 0
        endif
    endfunction

    set ttimeoutlen=150
    "exit insert mode
    autocmd InsertLeave * call Fcitx2en()
    autocmd InsertEnter * call Fcitx2zh()
    "##### auto fcitx end ######
endif
"}}}
"key mapping{{{
"map jj to esc..
inoremap jj <c-[>
"fuck the meta key...
if(!has("gui_running"))
    let c='a'
    while c <= 'z'
        exec "set <m-".c.">=\e".c
        exec "imap \e".c." <m-".c.">"
        let c = nr2char(1+char2nr(c))
    endw
    let d='1'
    while d <= '9'
        exec "set <m-".d.">=\e".d
        exec "inoremap \e".d." <m-".d.">"
        let d = nr2char(1+char2nr(d))
    endw
    set timeout timeoutlen=500 ttimeoutlen=1
endif

""no", "yes" or "menu"; how to use the ALT key
set winaltkeys=no

"leader key
let mapleader=","

"visual mode hit tab forward indent ,hit shift-tab backward indent
vmap <TAB>  >gv  
vmap <s-TAB>  <gv 
"Ctrl-tab is not work in vim
nnoremap <silent><c-TAB> :AT<cr>
nnoremap <silent><right> :tabnext<cr>
nnoremap <silent><Left> :tabp<cr>
nmap <m-t> :tabnew<cr>
imap <m-t> <esc>:tabnew<cr>
noremap <m-1> <esc>1gt
noremap <m-2> <esc>2gt
noremap <m-3> <esc>3gt
noremap <m-4> <esc>4gt
noremap <m-5> <esc>5gt
noremap <m-6> <esc>6gt
noremap <m-7> <esc>7gt
noremap <m-8> <esc>8gt
noremap <m-9> <esc>9gt

"update the _vimrc
map <leader>so :source $MYVIMRC<CR>
"open the vimrc in tab
map <leader>vc :tabedit $MYVIMRC<CR>

"insert time info
nmap <F7> a<C-R>=strftime("%Y-%m-%d/%H:%M:%S")<CR><ESC>
imap <F7> <C-R>=strftime("%Y-%m-%d/%H:%M:%S")<CR>

"clear search result
noremap <m-q> :nohls<CR>:MarkClear<cr>

"save file 
"in terminal ctrl-s is used to stop printf..
noremap <C-S>	:update<CR>
vnoremap <C-S>	<C-C>:update<CR>
inoremap <C-S>	<C-O>:update<CR>

"copy,paste and cut 
map <S-Insert> "+gP
imap <c-v>	<C-o>"+gp
cmap <C-V>	<C-R>+
cmap <S-Insert>	<C-R>+
vnoremap <C-X> "+x

"select all
noremap <m-a> gggH<C-O>G
inoremap <m-a> <C-O>gg<C-O>gH<C-O>G
cnoremap <m-a> <C-C>gggH<C-O>G
onoremap <m-a> <C-C>gggH<C-O>G
snoremap <m-a> <C-C>gggH<C-O>G
xnoremap <m-a> <C-C>ggVG

"Alignment
nmap <m-=> <esc>ggVG=``

" CTRL-C and SHIFT-Insert are Paste
vnoremap <C-C> "+y

"change the windows size
noremap <silent> <C-F9> :vertical resize -10<CR>
noremap <silent> <C-F10> :resize +10<CR>
noremap <silent> <C-F11> :resize -10<CR>
noremap <silent> <C-F12> :vertical resize +10<CR>

"move
imap <m-h> <Left>
imap <m-l> <Right>
imap <m-j> <Down>
imap <m-k> <Up>

"move between windos
nmap <m-h> <C-w>h
nmap <m-l> <C-w>l
nmap <m-j> <C-w>j
nmap <m-k> <C-w>k

cmap <m-h> <Left>
cmap <m-l> <Right>
cmap <m-j> <Down>
cmap <m-k> <Up>

"replace
nmap <c-h> :%s/<C-R>=expand("<cword>")<cr>/

"delete the ^M
nmap dm :%s/\r\(\n\)/\1/g<CR>

"cd to current buffer's path
nmap <silent> <c-F7> :lcd %:h<CR>
"resize windows
map <F5> :call Do_Make()<CR>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

nmap <F6> :call Dosunix()<cr>
nmap <leader>o :call Open_url()<cr>

"{{{function definition
function! Do_Make()
    :wa
    execute "silent make"
    set makeprg=make
    execute "normal :"
    execute "cw"
endfunction

func! Getvimrc()
    if g:iswindows==1
        cd $VIM
    else
        cd ~
    endif
    let xx=finddir('vim','.')
    if xx=='vim' "find it
        cd ./vim
        call system('git pull origin master')
        cd ..
    else
        call system('git clone https://github.com/tracyone/vim.git')
    endif
    if g:iswindows==1
        call g:VEPlatform.copyfile('./vim/_vimrc',$VIM)
    else
        call g:VEPlatform.copyfile('./vim/.vimrc',$HOME)
    endif

endfunc
func! Uploadvimrc()
    cd $VIMFILES
    let xx=finddir('vim','.')
    call system('git config --global user.name \"tracyone\"')
    call system('git config --global user.email \"tracyone@live.cn\"')
    "execute ":!git config --global credential.helper \"cache --timeout=360000\""
    if xx=='vim' "find it
        call g:VEPlatform.copyfile($MYVIMRC,'vim')
    else "can not find vim directory
        call system('git clone https://github.com/tracyone/vim.git')
        call g:VEPlatform.copyfile($MYVIMRC,'vim')
    endif
    cd ./vim/
    if g:iswindows==1
        call system('git add _vimrc')
    else
        call system('git add .vimrc')
    endif
    let g:commit_string='git commit -m '.'"'.strftime("%Y-%m-%d %H:%M:%S").'"'
    call system(g:commit_string)
    execute ":!git push origin master"
endfunc

function! Get_pattern_at_cursor(pat)
    let col = col('.') - 1
    let line = getline('.')
    let ebeg = -1
    let cont = match(line, a:pat, 0)
    while (ebeg >= 0 || (0 <= cont) && (cont <= col))
        let contn = matchend(line, a:pat, cont)
        if (cont <= col) && (col < contn)
            let ebeg = match(line, a:pat, cont)
            let elen = contn - ebeg
            break
        else
            let cont = match(line, a:pat, contn)
        endif
    endwhile
    if ebeg >= 0
        return strpart(line, ebeg, elen)
    else
        return ""
    endif
endfunction

function! Open_url()
    let s:url = Get_pattern_at_cursor('\v(https?://|ftp://|file:/{3}|www\.)(\w|[.-])+(:\d+)?(/(\w|[~@#$%^&+=/.?:-])+)?')
    if s:url == ""
        echohl WarningMsg
        echomsg 'It is not a URL on current cursor！'
        echohl None
    else
        echo 'Open URL：' . s:url
        if has("win32") || has("win64")
            call system("cmd /C start " . s:url)
        elseif has("mac")
            call system("open '" . s:url . "'")
        else
            call system("setsid firefox '" . s:url . "' &")
        endif
    endif
    unlet s:url
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

func! Dosunix()
    if &ff == 'unix'
        exec "se ff=dos"
    else
        exec "se ff=unix"
    endif
endfunc
"}}}
"}}}
"plugin setting{{{
"{{{vundle
"
"behave very Vi compatible (not advisable)
set nocp 
" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
filetype off
func! Vundle()
    if g:iswindows==1 
        set rtp+=~/vimfiles/bundle/vundle
    else
        set rtp+=~/.vim/bundle/vundle/
    endif
    " let Vundle manage Vundle
    " required! 
    if g:iswindows==1
        silent! :execute "call vundle#rc('$VIM/vimfiles/bundle')"
    else
        silent! :execute "call vundle#rc()"
    endif
    silent! :execute "Bundle 'gmarik/vundle'"
endfunc
execute "call Vundle()"
"mbbill/VimExplorer
let g:justvundled = exists(':Bundle')
if g:justvundled == 0
    if has('win32')
        cd $VIM
        call mkdir($VIM."\\vimfiles\\bundle\\vundle","p")
        call mkdir($VIM."\\vimfiles\\bundle\\VimExplorer","p")
        call system('git clone https://github.com/gmarik/vundle.git .\vimfiles\bundle\vundle')
        call system('git clone https://github.com/mbbill/VimExplorer.git .\vimfiles\bundle\VimExplorer')
        cd -
        execute "silent! call Vundle()"
    else
        call system('mkdir -p ~/.vim/bundle/vundle')
        call system('mkdir -p ~/.vim/bundle/VimExplorer')
        call system('git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle')
        call system('git clone https://github.com/mbbill/VimExplorer.git ~/.vim/bundle/VimExplorer')
        execute "silent! call Vundle()"
    endif
    :helptags $VIMFILES\bundle\vundle\doc\
endif

Bundle 'a.vim'
Bundle 'tracyone/dict'
Bundle 'EasyGrep'
Bundle 'verilog.vim'
Bundle 'tracyone/Align'
Bundle 'tracyone/calendar'
Bundle 'tracyone/Colour-Sampler-Pack'
Bundle 'altercation/vim-colors-solarized'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'delimitMate.vim'
Bundle 'FuzzyFinder'
Bundle 'genutils'
"Bundle 'youjumpiwatch/vim-neoeclim'
Bundle 'mhinz/vim-startify'
Bundle 'Shougo/neomru.vim'
Bundle 'SirVer/ultisnips'
Bundle 'YankRing.vim'
Bundle 'tracyone/snippets'
Bundle 'dosbatch-indent'
if g:iswindows==0
    Bundle 'sudo.vim'
endif
if ( has("patch885") || version == 704 ) && has('lua')
    let g:use_neocomplete=1
else
    let g:use_neocomplete=0
endif
if g:use_neocomplete==1
    Bundle 'Shougo/neocomplete'
elseif g:use_neocomplete==0
    Bundle 'Shougo/neocomplcache'
endif
Bundle 'The-NERD-Commenter'
Bundle 'tracyone/nerdtree'
Bundle 'ShowMarks7'
Bundle 'surround.vim'
Bundle 'majutsushi/tagbar'
Bundle 'Shougo/unite.vim'
Bundle 'L9'
Bundle 'mattn/emmet-vim'
Bundle 'vimwiki/vimwiki'
Bundle 'VimRepress'
Bundle 'hsitz/VimOrganizer'
Bundle 'adah1972/fencview'
if g:iswindows==0
    Bundle 'LaTeX-Suite-aka-Vim-LaTeX'
endif
Bundle 'DrawIt'
Bundle 'mbbill/VimExplorer'
Bundle 'renamer.vim'
Bundle  'hari-rangarajan/CCTree'
Bundle 'tracyone/mark.vim'
Bundle 'tracyone/MyVimHelp'
Bundle 'scrooloose/syntastic'
Bundle 'Shougo/vimproc.vim'
Bundle 'Shougo/vimshell.vim'
Bundle 'git://github.com/sjl/gundo.vim.git'
if g:iswindows == 1
    Bundle 'tracyone/pyclewn' 
else
    Bundle 'tracyone/pyclewn_linux' 
endif
Bundle 'hallison/vim-markdown'
Bundle 'greyblake/vim-preview'
"}}}
"{{{tohtml
let html_use_css=1
"}}}
"{{{fuzzyfinder
"<CR>  (|g:fuf_keyOpen|)        - opens in a previous window.
"<C-j> (|g:fuf_keyOpenSplit|)   - opens in a split window.
"<C-k> (|g:fuf_keyOpenVsplit|)  - opens in a vertical-split window.
"<C-l> (|g:fuf_keyOpenTabpage|) - opens in a new tab page.
let g:fuf_file_exclude = '\v\~$|\.(o|exe|bak|swp|gif|jpg|png)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])'
let g:fuf_mrufile_exclude = '\v\~$|\.bak$|\.swp|\.howm$|\.(gif|jpg|png)$'
let g:fuf_mrufile_maxItem = 10000
"let g:fuf_enumeratingLimit = 20
let g:fuf_modesDisable = []
let g:fuf_mrufile_maxItem = 20
let g:fuf_mrucmd_maxItem = 20
let g:fuf_dataDir = $VIMFILES . '/.vim-fuf-data'
"recursive open 
nmap <F3> :FufFile **/<cr>   
nmap <silent><leader>ff :FufFile<cr>
nmap <silent><leader>fb :FufBuffer<cr>
nmap <silent><leader>fd :FufDir<cr>
nmap <silent><leader>fm :FufMruFile<cr>
nmap <silent><leader>ft :FufTag<cr>
"}}}
"{{{ZenCoding
let g:user_zen_expandabbr_key='<C-j>'
"}}}
"{{{tagbar
nmap <silent><F9> :TagbarToggle<CR>
let g:tagbar_left=0
let g:tagbar_width=30
let g:tagbar_sort=0
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
let g:tagbar_systemenc='cp936'
"}}}
"{{{cscope
exec "silent! cs add cscope.out"
if $CSCOPE_DB != "" "tpyically it is a include db 
    exec "silent! cs add $CSCOPE_DB"
endif
if $CSCOPE_DB1 != ""
    exec "silent! cs add $CSCOPE_DB1"
endif
if $CSCOPE_DB2 != ""
    exec "silent! cs add $CSCOPE_DB2"
endif
if $CSCOPE_DB3 != ""
    exec "silent! cs add $CSCOPE_DB3"
endif
if has("cscope")
    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag
    set csprg=cscope
    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0
    set cscopequickfix=s-,c-,d-,i-,t-,e-,i-,g-,f-
    " add any cscope database in current directory
    " else add the database pointed to by environment variable 
    set cscopetagorder=0
endif
set cscopeverbose 
" show msg when any other cscope db added
nmap <Leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
nmap <Leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>d :cs find d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>:cw 7<cr>
nmap <Leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
nmap <Leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
nmap <Leader>e :cs find e <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
nmap <Leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>:cw 7<cr>
nmap <Leader>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:cw 7<cr>

nmap <C-@>s :split<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>g :split<CR>:cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>d :split<CR>:cs find d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>
nmap <C-@>c :split<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>t :split<CR>:cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>e :split<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>f :split<CR>:cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-@>i :split<CR>:cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>

nmap <C-\>s :cs find s 
nmap <C-\>g :cs find g 
nmap <C-\>c :cs find c 
nmap <C-\>t :cs find t 
nmap <C-\>e :cs find e 
nmap <C-\>f :cs find f 
nmap <C-\>i :cs find i 
nmap <C-\>d :cs find d 
nnoremap <leader>u :call Do_CsTag()<cr>
nmap <leader>a :cs add cscope.out<cr>
"kill the connection of current dir 
nmap <leader>k :cs kill cscope.out<cr> 
function! Do_CsTag()
    let dir = getcwd()
    if filereadable("tags")
        if(g:iswindows==1)
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif
    if filereadable("cscope.files")
        if(g:iswindows==1)
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if(g:iswindows==1)
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "I cannot delete the cscope.out,try again" | echohl None
            echo "kill the cscope connection"
            if has("cscope") && filereadable("cscope.out")
                silent! execute "cs kill cscope.out"
            endif
            if(g:iswindows==1)
                let csoutdeleted=delete(dir."\\"."cscope.out")
            else
                let csoutdeleted=delete("./"."cscope.out")
            endif
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "I still cannot delete the cscope.out,failed to do cscope" | echohl None
            return
        endif
    endif
    "if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        "silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    "endif
    if(executable('cscope') && has("cscope") )
        if(g:iswindows!=1)
            silent! execute "!find $(pwd) -name \"*.[chsS]\" > ./cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs,*.s,*.asm > cscope.files"
        endif
        silent! execute "!cscope -Rbkq -i cscope.files"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        else
            echohl WarningMsg | echo "No cscope.out" | echohl None
        endif
    endif
endfunction
    "}}}
"{{{neocomplcache or neocomplete
"neocomplete is a new plugin develop by the same author,it required lua
"feature and it is more intelligen of course
if g:use_neocomplete==1
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
    let g:neocomplete#data_directory = $VIMFILES . '/.neocomplete'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
                \ 'default' : '',
                \ 'cpp' : $VIMFILES.'/bundle/dict/cpp.dict',
                \ 'html' : $VIMFILES.'/bundle/dict/html.dict',
                \ 'c' : $VIMFILES.'/bundle/dict/c.dict',
                \ 'sh' : $VIMFILES.'/bundle/dict/bash.dict',
                \ 'dosbatch' : $VIMFILES.'/bundle/dict/batch.dict',
                \ 'tex' : $VIMFILES.'/bundle/dict/latex.dict',
                \ 'vim' : $VIMFILES.'/bundle/dict/vim.dict.txt',
                \ 'verilog' : $VIMFILES.'/bundle/dict/verilog.dict'
                \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    " <TAB>: completion.
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()
    " Or set this.
    "let g:neocomplete#enable_cursor_hold_i = 1
    " Or set this.
    "let g:neocomplete#enable_insert_char_pre = 1

    " AutoComplPop like behavior.
    "let g:neocomplete#enable_auto_select = 1

    "imap <expr> `  pumvisible() ? "\<Plug>(neocomplete_start_unite_quick_match)" : '`'
    " Enable heavy omni completion.
	if !exists('g:neocomplete#sources#omni#input_patterns')
	  let g:neocomplete#sources#omni#input_patterns = {}
	endif
	if !exists('g:neocomplete#force_omni_input_patterns')
	  let g:neocomplete#force_omni_input_patterns = {}
	endif
	let g:neocomplete#sources#omni#input_patterns.php =
	\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
	let g:neocomplete#sources#omni#input_patterns.c =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
	let g:neocomplete#sources#omni#input_patterns.cpp =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    " For smart TAB completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
           \ <SID>check_back_space() ? "\<TAB>" :
           \ neocomplete#start_manual_complete()
     function! s:check_back_space() "{{{
       let col = col('.') - 1
       return !col || getline('.')[col - 1]  =~ '\s'
     endfunction"}}}
 elseif g:use_neocomplete==0 
    let g:acp_enableAtStartup = 0
    " Use neocomplcache.
    let g:neocomplcache_enable_at_startup = 1
    " Use smartcase.
    let g:neocomplcache_enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplcache_min_syntax_length = 3
    "neocomplcache selects the first candidate
    let g:neocomplcache_enable_auto_select = 0
    " Enable heavy features.
    " Use camel case completion.
    "let g:neocomplcache_enable_camel_case_completion = 1
    " Use underbar completion.
    "let g:neocomplcache_enable_underbar_completion = 1
    let g:neocomplcache_auto_completion_start_length = 2
    let g:neocomplcache_manual_completion_start_length = 2
    let g:neocomplcache_min_keyword_length = 3
    let g:neocomplcache_enable_ignore_case = 1
    let g:neocomplcache_temporary_dir = $VIMFILES . '/.neocomplete'
    "fuzzy complete
    let g:neocomplcache_enable_fuzzy_completion=1
    "Define dictionary,in editplus's official website can find many dict with
    "stx suffix
    let g:neocomplcache_dictionary_filetype_lists = {
                \ 'default' : '',
                \ 'cpp' : $VIMFILES.'/bundle/dict/cpp.dict',
                \ 'html' : $VIMFILES.'/bundle/dict/html.dict',
                \ 'c' : $VIMFILES.'/bundle/dict/c.dict',
                \ 'sh' : $VIMFILES.'/bundle/dict/bash.dict',
                \ 'dosbatch' : $VIMFILES.'/bundle/dict/batch.dict',
                \ 'tex' : $VIMFILES.'/bundle/dict/latex.dict',
                \ 'vim' : $VIMFILES.'/bundle/dict/vim.dict.txt',
                \ 'verilog' : $VIMFILES.'/bundle/dict/verilog.dict'
                \ }
    if !exists("g:neocomplcache_include_paths")
        let g:neocomplcache_include_paths = {}
    endif
    if g:iswindows == 1
        let g:neocomplcache_include_paths = {
                    \ 'cpp' : '.,d:/MinGw/lib/gcc/mingw32/4.6.2/include/c++',
                    \ 'c' : '.,d:/MinGW/lib/gcc/mingw32/4.6.2/include,d:/MinGw/include'
                    \ }
    else
        let g:neocomplcache_include_paths = {
                    \ 'cpp' : '.,/usr/include/c++/4.7/',
                    \ 'c' : '.,/usr/include/'
                    \ }
    endif

    let g:neocomplcache_include_patterns = {
                \ 'cpp' : '^\s*#\s*include',
                \ 'c' : '^\s*#\s*include'
                \ }
    " Define keyword.
    if !exists('g:neocomplcache_keyword_patterns')
        let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

    autocmd BufReadPost,BufEnter,BufWritePost :NeoComplCacheCachingBuffer <buffer>:echo "Caching done."<CR>

    " Enable heavy omni completion.
    if !exists('g:neocomplcache_omni_patterns')
        let g:neocomplcache_omni_patterns = {}
    endif
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
    let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplcache#undo_completion()
    inoremap <expr><C-l>     neocomplcache#complete_common_string()
    " <TAB>: completion.
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplcache#close_popup()
    inoremap <expr><C-e>  neocomplcache#cancel_popup()
    " For cursor moving in insert mode(Not recommended)
    "inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
    "inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
    "inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
    "inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
    imap <expr> `  pumvisible() ? "\<Plug>(neocomplcache_start_unite_quick_match)" : '`'
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
endif
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType c setlocal omnifunc=ccomplete#Complete
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
"}}}
"{{{unite.vim 

nnoremap    [unite]   <Nop>
nmap   \ [unite]

nnoremap <silent> [unite]c  :<C-u>UniteWithCurrentDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]b  :Unite buffer -input=!split<CR>
nnoremap <silent> [unite]m  :Unite file_mru<CR>
nnoremap <silent> [unite]d  :Unite directory_mru<CR>
nnoremap <silent> [unite]r  :<C-u>Unite -buffer-name=register register<CR>
nnoremap  [unite]f  :<C-u>Unite source<CR>


autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
    " Overwrite settings.

    nmap <buffer> <ESC>      <Plug>(unite_exit)
    imap <buffer> jj      <Plug>(unite_insert_leave)
    "imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)

    " Start insert.
    " let g:unite_enable_start_insert = 0
endfunction

let g:unite_source_file_mru_limit = 200
let g:unite_enable_split_vertically = 0 "vertical split
let g:unite_data_directory = $VIMFILES . '/.unite'
"}}}
"{{{matchit.vim
"extend %
runtime macros/matchit.vim "important 
let loaded_matchit=0
let b:match_ignorecase=1 
set mps+=<:>
set mps+=":"
"}}}
"{{{nerdtree 
let NERDTreeShowLineNumbers=0	"don't show line number
let NERDTreeWinPos='left'	"show nerdtree in the rigth side
"let NERDTreeWinSize='30'
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
map <F12> :NERDTreeToggle .<CR> 
"map <2-LeftMouse>  *N "double click highlight the current cursor word 
imap <F12> <ESC> :NERDTreeToggle<CR>
"}}}
"{{{a.vim
":A switches to the header file corresponding to the current file being  edited (or vise versa)
":AS splits and switches
":AV vertical splits and switches
":AT new tab and switches
":AN cycles through matches
":IH switches to file under cursor
":IHS splits and switches
":IHV vertical splits and switches
":IHT new tab and switches
":IHN cycles through matches
nmap <leader>ih :IH<cr>
nmap <leader>ihs :IHS<cr>
nmap <leader>ihv :IHV<cr>
nmap <leader>iht :IHT<cr>
nmap <leader>ihn :IHN<cr>
nmap <leader>ia :A<cr>
nmap <leader>ias :AS<cr>
nmap <leader>iav :AT<cr>
nmap <leader>iat :AT<cr>
nmap <leader>ian :AN<cr>
"}}}
"{{{showmark 
"The following mappings are setup by default:

"<Leader>mt   - Toggles ShowMarks on and off.
"<Leader>mo   - Forces ShowMarks on.
"<Leader>mh   - Clears the mark at the current line.
"<Leader>ma   - Clears all marks in the current buffer.
"<Leader>mm   - Places the next available mark on the current line.
let showmarks_enable = 0            " disable showmarks when vim startup 
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" 
let showmarks_ignore_type = "hqm"   " help, Quickfix, non-modifiable 
"}}}
"{{{delimitMate
au FileType verilog,c let b:delimitMate_matchpairs = "(:),[:],{:}"
let delimitMate_nesting_quotes = ['"','`']
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
"}}}
"{{{CCtree
let g:CCTreeKeyTraceForwardTree = '<C-\>>' "the symbol in current cursor's forward tree 
let g:CCTreeKeyTraceReverseTree = '<C-\><'
let g:CCTreeKeyHilightTree = '<C-\>l' " Static highlighting
let g:CCTreeKeySaveWindow = '<C-\>y'
let g:CCTreeKeyToggleWindow = '<C-\>w'
let g:CCTreeKeyCompressTree = 'zs' " Compress call-tree
let g:CCTreeKeyDepthPlus = '<C-\>='
let g:CCTreeKeyDepthMinus = '<C-\>-'
let CCTreeJoinProgCmd = 'PROG_JOIN JOIN_OPT IN_FILES > OUT_FILE'
let  g:CCTreeJoinProg = 'cat' 
let  g:CCTreeJoinProgOpts = ""
"let g:CCTreeUseUTF8Symbols = 1
"map <F7> :CCTreeLoadXRefDBFromDisk $CCTREE_DB<cr> 
"}}}
"{{{calendar
"'close'                     Closes calendar window.             'q'
"'do_action'                 Executes |calendar_action|.           '<CR>'
"'goto_today'                Executes |calendar_today|.            't'
"'show_help'                 Displays a short help message.      '?'
"'redisplay'                 Redraws calendar window.            'r'
"'goto_next_month'           Jumps to the next month.            '<Right>'
"'goto_prev_month'           Jumps to the previous month.        '<Left>'
"'goto_next_year'            Jumps to the next month.            '<Up>'
"'goto_prev_year'            Jumps to the previous month.        '<Down>'
"map <F10> :Calendar<cr>
"}}}
"{{{ctrlp
" Set Ctrl-P to show match at top of list instead of at bottom, which is so
" stupid that it's not default
let g:ctrlp_match_window_reversed = 0

" Tell Ctrl-P to keep the current VIM working directory when starting a
" search, another really stupid non default
let g:ctrlp_working_path_mode = 'w'

" Ctrl-P ignore target dirs so VIM doesn't have to! Yay!
let g:ctrlp_custom_ignore = {
            \ 'dir': '\.git$\|\.hg$\|\.svn$\|target$\|built$\|.build$\|node_modules\|\.sass-cache',
            \ 'file': '\v\.(exe|so|dll|o|proj|out|)$',
            \ }
let g:ctrlp_extensions = ['tag', 'buffertag', 'dir', 'bookmarkdir']
"}}}
"{{{VimExplorer
let g:VEConf_systemEncoding = 'cp936'
map <F11> :silent! VE .<cr>
"}}}
"{{{vimshell
let g:vimshell_user_prompt = '":: " . "(" . fnamemodify(getcwd(), ":~") . ")"'
"let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
let g:vimshell_enable_smart_case = 1
let g:vimshell_editor_command="gvim"
if has('win32') || has('win64')
    " Display user name on Windows.
    let g:vimshell_prompt = $USERNAME."% "
else
    " Display user name on Linux.
    let g:vimshell_prompt = $USER."% "
endif
let g:vimshell_popup_command='rightbelow 10split'
" Initialize execute file list.
let g:vimshell_execute_file_list = {}
call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
let g:vimshell_execute_file_list['rb'] = 'ruby'
let g:vimshell_execute_file_list['pl'] = 'perl'
let g:vimshell_execute_file_list['py'] = 'python'
let g:vimshell_temporary_directory = $VIMFILES . '/.vimshell'
call vimshell#set_execute_file('html,xhtml', 'gexe firefox')
au FileType vimshell :imap <buffer> <HOME> <Plug>(vimshell_move_head)
au FileType vimshell set nonu
au FileType vimshell :imap <c-d> <Plug>(vimshell_exit)
autocmd FileType vimshell
            \ call vimshell#altercmd#define('g', 'git')
            \| call vimshell#altercmd#define('i', 'iexe')
            \| call vimshell#altercmd#define('l', 'll')
            \| call vimshell#altercmd#define('c', 'clear')
"\| call vimshell#hook#add('chpwd', 'my_chpwd', 'g:my_chpwd')

"function! g:my_chpwd(args, context)
"call vimshell#execute('ls')
"endfunction

autocmd FileType int-* call s:interactive_settings()
function! s:interactive_settings()
endfunction
"map <F4> :VimShellPop $CurBufferDir<cr>
map <F4> :VimShellPop<cr>
"}}}
"{{{UltiSnips
let g:UltiSnipsUsePythonVersion = 2 "recommend to use python2.x
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsListSnippets ="<c-tab>"
let g:UltiSnipsJumpForwardTrigge="<c-j>"
let g:UltiSnipsJumpBackwardTrigge="<c-k>"
let g:UltiSnipsSnippetDirectories=["bundle/snippets"]
let g:UltiSnipsSnippetsDir=$VIM."/vimfiles/bundle/snippets"
"}}}
"{{{fencview
let g:fencview_autodetect=0 
let g:fencview_auto_patterns='*.txt,*.htm{l\=},*.c,*.cpp,*.s,*.vim'
noremap <F10> :FencManualEncoding cp936<cr>
"}}}
"{{{renamer
"rename multi file name
map <F2> :Ren<cr>
"}}}
"{{{myvimhelp
let g:startupfile="first_statup.txt"
if g:iswindows==1
    let g:start_path=$VIMFILES.'/first_statup.txt'
else
    let g:start_path=$VIMFILES.'/.first_statup'
endif
if filereadable(g:start_path)
    map <F1> :h MyVimHelp.txt<cr>
else
    execute writefile([g:startupfile], g:start_path)
    execute "silent! h MyVimHelp.txt"
    :only
    map <F1> :h MyVimHelp.txt<cr>
endif
"}}}
"{{{nerdcommander
let g:NERDMenuMode=1
"}}}
"{{{yankring
nmap <c-y> :YRGetElem<CR>
imap <c-y> <esc>:YRGetElem<CR>
let yankring_history_dir = $VIMFILES
let g:yankring_history_file = ".yank_history"
let g:yankring_default_menu_mode = 0
let g:yankring_replace_n_pkey = '<m-p>'
let g:yankring_replace_n_nkey = '<m-n>'
"}}}
"{{{vim-startify
if g:iswindows==1
    let g:startify_session_dir = $VIMFILES .'\sessions'
else
    let g:startify_session_dir = $VIMFILES .'/sessions'
endif
let g:startify_list_order = ['files', 'bookmarks', 'sessions']
let g:startify_change_to_dir = 1
let g:startify_files_number = 5 
let g:startify_change_to_vcs_root = 0
let g:startify_custom_header = [
            \ '   __      ___            ',
            \ '   \ \    / (_)           ',
            \ '    \ \  / / _ _ __ ___   ',
            \ '     \ \/ / | | ''_ ` _ \ ',
            \ '      \  /  | | | | | | | ',
            \ '       \/   |_|_| |_| |_| ',
            \ '',
            \ '    Help <F1> ',
            \ '    tracyone@live.cn',
            \ '',
            \ '',
            \ ]
noremap <F8> :SSave<cr>
autocmd FileType startify setlocal buftype=
"}}}
"{{{eclim
let g:EclimCompletionMethod = 'omnifunc'
if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.cpp =
            \ '[^. *\t]\.\w*\|\h\w*::'
"}}}
filetype plugin indent on
syntax on
"}}}
"gui releate{{{
"list of menu_flags that specify how the GUI works
if(has("gui_running"))
    if g:iswindows==0
        au GUIEnter * call MaximizeWindow()
        set guifont=Monaco\ 12
        set gfw=YaHei_Mono_Hybird_Consolas\ 12.5
    else
        au GUIEnter * simalt~x "maximize window
        set guifont=Monaco:h12:cANSI
        set gfw=YaHei_Mono:h12.5:cGB2312
    endif
    " If using a dark background within the editing area and syntax highlighting
    " turn on this option as well
    set novb
    au GUIEnter * set vb t_vb=
    set t_vb=
    set guioptions-=b
    set guioptions-=m "whether use menu
    set guioptions-=r "whether show the rigth scroll bar
    set guioptions-=l "whether show the left scroll bar
    set guioptions-=T "whether show toolbar or not
    "highlight the screen line of the cursor
    let g:menu_flag=1
    func! MenuToggle()
        if g:menu_flag==0
            :set guioptions+=mT<cr>  
            let g:menu_flag=1
        else
            :set guioptions-=mT<cr>  
            let g:menu_flag=0
        endif
    endfunc
    :call MenuToggle()
    nnoremap <c-F9> :call MenuToggle()<cr>
    set cul
    "{{{toolbar
    if has("toolbar")
        if exists("*Do_toolbar_tmenu")
            delfun Do_toolbar_tmenu
        endif
        fun Do_toolbar_tmenu()
            tmenu ToolBar.Open		Open File
            tmenu ToolBar.Save		Save File
            tmenu ToolBar.SaveAll	Save All
            tmenu ToolBar.Print		Print
            tmenu ToolBar.Undo		Undo
            tmenu ToolBar.Redo		Redo
            tmenu ToolBar.Cut		Cut
            tmenu ToolBar.Copy		Copy
            tmenu ToolBar.Paste		Paste
            tmenu ToolBar.Find		Find&Replace
            tmenu ToolBar.FindNext	Find Next
            tmenu ToolBar.FindPrev	Find Prev
            tmenu ToolBar.Replace	Replace
            tmenu ToolBar.LoadSesn	Load Session
            tmenu ToolBar.SaveSesn	Save Session
            tmenu ToolBar.RunScript	Run a Vim Script
            tmenu ToolBar.Make		Make
            tmenu ToolBar.Shell		Shell
            tmenu ToolBar.RunCtags	ctags! -R
            tmenu ToolBar.TagJump	Jump to next tag
            tmenu ToolBar.Help		Help
            tmenu ToolBar.FindHelp	Search Help
        endfun
    endif
    "}}}
    "{{{mouse
    " Set up the gui cursor to look nice
    set guicursor=n-v-c:block-Cursor-blinkon0,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
    amenu PopUp.-SEP3-	<Nop>
    ""extend", "popup" or "popup_setpos"; what the right
    set mousemodel=popup_setpos
    amenu PopUp.&Undo :GundoToggle<CR>
    amenu PopUp.&Goto\ Definition :cs find g <C-R>=expand("<cword>")<CR><CR>
    amenu PopUp.&Find\ Text :silent! execute "vimgrep " . expand("<cword>") . " **/*.[ch]". " **/*.cpp" . " **/*.cc"<cr>:cw 5<cr>
    amenu PopUp.&Open\ Header/Source :AT<cr>
    "}}}
    "{{{colorscheme
    "{{{colorscheme solarized setting
    "let g:solarized_termtrans=0
    " let g:solarized_degrade=0
    let g:solarized_bold=1
    let g:solarized_underline=0
    " let g:solarized_italic=1
    let g:solarized_termcolors=256
    " let g:solarized_contrast="normal"
    " let g:solarized_visibility="normal"
    " let g:solarized_diffmode="normal"
    " let g:solarized_hitrail=0
    set background=dark
    let g:solarized_menu=0
    func! Turnonoff()
        if &background == 'light'
            exec "set background=dark"
        else
            exec "set background=light"
        endif
    endfunc
    noremap <c-F8> :call Turnonoff()<cr>
    "}}}
    let g:colorscheme_file='' "color thmem's name  
    if g:iswindows == 0
        let g:slash='/'
        let g:love_path=$VIMFILES.'/.love'
    else
        let g:slash='\'
        let g:love_path=$VIMFILES.'\love.txt'
    endif

    command! Love call LoveCS()
    function! LoveCS()
        let g:colorscheme_file=g:colors_name
        execute writefile([g:colorscheme_file], g:love_path)
    endfunction
    function! ApplyCS()
        let cmd='colorscheme '.g:colorscheme_file
        execute cmd
    endfunction

    let r=findfile(g:love_path)
    if r != ''
        let loves=readfile(g:love_path)
        if len(loves) > 0
            let g:colorscheme_file=loves[0]
            call ApplyCS()
        endif
    else
        colorscheme solarized "default setting 
    endif

    
    "}}}
    
    function! MaximizeWindow()
        :win 1999 1999
        silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
    endfunction
endif
"}}}
"default is on but it is off when you are root,so we put it here
set modeline
" vim: set fdm=marker foldlevel=0 foldmarker&: 
