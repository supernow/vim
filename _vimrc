"@file       .vimrc & _vimrc
"@brief      config file of vim and gvim for both windows and linux
"@date       2012-12-30 11:01:30
"@author     tracyone,tracyone@live.cn
"@lastchange 2013-06-16/00:07:44
"@note:		Prior to use, in the case of windows vim convert this file's 
"			format into dos,while convert it into unix format in the case 
"			of linux vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"encode {{{
set encoding=utf-8
if has("win32") || has("win64")
	set fileencoding=utf-8
else
	set fileencoding=gbk
endif
set fileencodings=ucs-bom,utf-8,cp936,gb1830,big5,euc-jp,euc-kr,latin1
set termencoding=utf-8
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
	behave  xterm
	"set path=
	let $VIMFILES = $VIM.'/vimfiles'
	let g:iswindows=1 "windows flags
elseif has("unix")
	set filetype=unix
	set ffs=unix,dos
	set keywordprg=""
	behave xterm
	set shell=bash
	runtime! debian.vim
	set path=.,/usr/include/ "c++ is in /usr/include/c++/...
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
autocmd FileType verilog set foldmethod=manual 
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
autocmd FileType vim set foldmethod=marker 
autocmd FileType vim set foldlevel=0
nmap <TAB> za
"set foldtext=foldtext()
"}}}
"highlight Pmenu ctermbg=13 guibg=LightGray
"highlight PmenuSel ctermbg=7 guibg=DarkBlue guifg=White
"highlight PmenuSbar ctermbg=7 guibg=DarkGray
"highlight PmenuThumb guibg=Black
" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

nmap <F6> :call Dosunix()<cr>
func! Dosunix()
	if &ff == 'unix'
		exec "se ff=dos"
	else
		exec "se ff=unix"
	endif
endfunc
"display unprintable characters by set list
"set list
"Strings to use in 'list' mode and for the |:list| command
set listchars=tab:\|\ ,trail:-

" Uncomment the following to have Vim jump to the last position when
" reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"{{{backup
set backup "generate a backupfile when open file

set backupext=.bak  "backup file'a suffix

set directory=$HOME/vimbackup  "swp file's directory
if !isdirectory(&directory)
	call mkdir(&directory, "p")
endif

set backupdir=$HOME/vimbackup  "backup file's directory
if !isdirectory(&backupdir)
	call mkdir(&backupdir, "p")
endif
"}}}

set report=0  "Threshold for reporting number of lines changed

"help doc dir
"let helptags=$VIMFILES.'/doc'

set helplang=en,cn  "set helplang=en
"autoread when a file is changed from the outside
set autoread

"show the line number for each line
set nu

"number of lines used for the command-line
set cmdheight=1

"when inserting a bracket, briefly jump to its match
set showmatch

"name of the font to be used for :hardcopy
set printfont=Yahei_Mono:h10:cGB2312

"override 'ignorecase' when pattern has upper case characters
set smartcase

"list of flags for using the mouse,support all
set mouse=a

""extend", "popup" or "popup_setpos"; what the right
"set mousemodel=extend

"start a dialog when a command fails
set confirm

set smartindent "do clever autoindenting

"set nowrap   "don't auto linefeed

"enable specific indenting for C code
set cindent

"number of spaces a <Tab> in the text stands for
set tabstop=4

"if non-zero, number of spaces to insert for a <Tab>
set softtabstop=4

"a <Tab> in an indent inserts 'shiftwidth' spaces
set smarttab

"highlight all matches for the last used search pattern
set hlsearch

"number of spaces used for each step of (auto)indent
set shiftwidth=4

"display the current mode in the status line
set showmode

"show cursor position below each window
"set ruler

""old", "inclusive" or "exclusive"; how selecting text behaves
set selection=inclusive

"show match for partly typed search command
set is

"wrap long lines at a character in 'breakat'
"set lbr

"specifies what <BS>, CTRL-W, etc. can do in Insert mode
set backspace=indent,eol,start

"list of flags specifying which commands wrap to another line
set whichwrap=b,h,l,<,>,[,]

"unnamed" to use the * register like unnamed register
"autoselect" to always put selected text on the clipboardset clipboard+=unnamed
set clipboard+=unnamed

"change to directory of file in buffer
set autochdir

"statusline
set statusline+=%<%f%m%r%h%w%{tagbar#currenttag('[%s]','')}
set statusline+=%=[FORMAT=%{(&fenc!=''?&fenc:&enc)}:%{&ff}:%Y]\ [ASCII=\%03.3b]\ [POS=%l,%v][%p%%] 
set statusline+=%{strftime(\"%y/%m/%d\-\%H:%M\")}
"0, 1 or 2; when to use a status line for the last window
set laststatus=2 "always show status
hi StatusLine guifg=Black guibg=White gui=none
highlight StatusLineNC guifg=LightGrey guibg=LightSlateGrey	
if version >= 700 
	au InsertEnter * hi StatusLine guibg=#818D29 guifg=#FCFCFC gui=none
	au InsertLeave * hi StatusLine guifg=Black guibg=White gui=none
endif
"always show the tabline
set stal=2
nmap <F7> a<C-R>=strftime("%Y-%m-%d/%H:%M:%S")<CR><ESC>
imap <F7> <C-R>=strftime("%Y-%m-%d/%H:%M:%S")<CR>
"automatic recognition vt file as verilog 
au BufRead,BufNewFile *.vt set filetype=verilog

"automatic recognition bld file as javascript 
au BufRead,BufNewFile *.bld set filetype=javascript

"automatic recognition xdc file as javascript
au BufRead,BufNewFile *.xdc set filetype=javascript

au BufRead,BufNewFile *.mk set filetype=make
"}}}
"key mapping{{{

""key map timeouts
"set notimeout 
"set timeoutlen=4000
"set ttimeout
"set ttimeoutlen=100
""no", "yes" or "menu"; how to use the ALT key
set winaltkeys=no
"visual mode hit tab forward indent ,hit shift-tab backward indent
vmap <TAB>  >gv  
vmap <s-TAB>  <gv 
"leader key
let mapleader=","
"open the vimrc
nmap <leader>vc :tabedit $MYVIMRC<cr>
"update the _vimrc
nmap <leader>so :source $MYVIMRC<CR>:e<CR>

"clear search result
noremap <a-q> :nohls<CR>

"save file
" Use CTRL-S for saving, also in Insert mode
noremap <C-S>		:update<CR>
vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<C-O>:update<CR>

map <S-Insert>		"+gP
imap <c-v>		<C-o>"+gp
cmap <C-V>		<C-R>+
cmap <S-Insert>		<C-R>+

"select all
noremap <m-a> gggH<C-O>G
inoremap <m-a> <C-O>gg<C-O>gH<C-O>G
cnoremap <m-a> <C-C>gggH<C-O>G
onoremap <m-a> <C-C>gggH<C-O>G
snoremap <m-a> <C-C>gggH<C-O>G
xnoremap <m-a> <C-C>ggVG

"Alignment
nmap <m-=> <esc>ggVG=``

" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x

"do not Ring the bell (beep or screen flash) for error messages
set noerrorbells
set novisualbell 
"set vb t_vb= "close visual bell
set mat=2

" CTRL-C and SHIFT-Insert are Paste
vnoremap <C-C> "+y

" CTRL-V and SHIFT-Insert are Paste
"
"move
imap <A-h> <Left>
imap <A-l> <Right>
imap <A-j> <Down>
imap <A-k> <Up>
"move between windos
nmap <A-h> <C-w>h
nmap <A-l> <C-w>l
nmap <A-j> <C-w>j
nmap <A-k> <C-w>k
"replace
nmap <c-h> :%s/<C-R>=expand("<cword>")<cr>/

map <F5> :call Do_make()<CR>

function! Do_make()
	set makeprg=make
	execute "silent make"
	execute "copen"
endfunction 

"compile and run open quickfix if wrong

"delete the ^M
nmap dm :%s/\r\(\n\)/\1/g<CR>
nmap <m-1> <esc>1gt
nmap <m-2> <esc>2gt
nmap <m-3> <esc>3gt
nmap <m-4> <esc>4gt
nmap <m-5> <esc>5gt
nmap <m-6> <esc>6gt
nmap <m-7> <esc>7gt
nmap <m-8> <esc>8gt
nmap <m-9> <esc>9gt

func! Updatevimrc()
	cd $VIM
	call system('git clone https://github.com/tracyone/vim.git')
	call g:VEPlatform.copyfile('./vim/_vimrc',$VIM)
	cd ..
endfunc
func! Uploadvimrc()
	cd $VIM
	pwd
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
	cd ../..
endfunc
nmap <Leader>dc :call Updatevimrc()<cr>
nmap <Leader>uc :call Uploadvimrc()<cr>
" {{{Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

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
"}}}
"}}}
"plugin setting{{{

"behave very Vi compatible (not advisable)
set nocp 
" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
filetype plugin indent on
syntax on

"{{{vundle
"
func! Vundle()
	if g:iswindows==1 
		set rtp+=$VIM\\vimfiles\\bundle\\vundle
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
let g:justvundled = exists(':Bundle')
if g:justvundled == 0
    if has('win32')
		cd $VIM
		call mkdir($VIM."\\vimfiles\\bundle\\vundle","p")
        call system('git clone https://github.com/gmarik/vundle.git .\vimfiles\bundle\vundle')
		cd -
		execute "silent! call Vundle()"
    else
        call system('mkdir -p ~/.vim/bundle/vundle')
        call system('git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle')
		execute "silent! call Vundle()"
    endif
	:helptags $VIMFILES\bundle\vundle\doc\
endif

" My Bundles here:
"
" original repos on github
" Bundle 'tpope/vim-fugitive'
" Bundle 'Lokaltog/vim-easymotion'
" Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
" Bundle 'tpope/vim-rails.git'
" vim-scripts repos
Bundle 'a.vim'
Bundle 'tracyone/dict'
Bundle 'Align'
Bundle 'tracyone/calendar'
Bundle 'Colour-Sampler-Pack'
Bundle 'tracyone/ConqueShell'
Bundle 'amiorin/ctrlp-z'
Bundle 'ctrlp.vim'
Bundle 'delimitMate.vim'
Bundle 'FuzzyFinder'
Bundle 'genutils'
if g:iswindows==0 && has("patch584")
	let g:use_ycm=1
else
	let g:use_ycm=0
endif
if g:use_ycm==0
	Bundle 'Shougo/neocomplcache'
	"Bundle 'Shougo/neosnippet'
	"Bundle 'honza/vim-snippets'
else
	Bundle 'Valloric/YouCompleteMe'
endif
Bundle 'The-NERD-Commenter'
Bundle 'scrooloose/nerdtree'
Bundle 'ShowMarks7'
Bundle 'wesleyche/SrcExpl'
Bundle 'surround.vim'
Bundle 'majutsushi/tagbar'
Bundle 'Shougo/unite.vim'
Bundle 'L9'
Bundle 'ZenCoding.vim'
Bundle 'vimwiki'
Bundle 'matrix.vim--Yang'
Bundle 'adah1972/fencview'
Bundle 'Markdown'
Bundle 'LaTeX-Suite-aka-Vim-LaTeX'
Bundle 'DrawIt'
Bundle 'mbbill/VimExplorer'
Bundle 'renamer.vim'
Bundle 'tracyone/doxygen-support'
Bundle 'tracyone/CCtree'
Bundle 'hallison/vim-markdown'
Bundle 'TeTrIs.vim'
Bundle 'tracyone/mark.vim'
Bundle 'tracyone/MyVimHelp'
Bundle 'sunuslee/vim-plugin-random-colorscheme-picker' 
Bundle 'scrooloose/syntastic'
if g:iswindows == 1
	Bundle 'tracyone/pyclewn' 
else
	Bundle 'tracyone/pyclewn_linux' 
endif
" non github reposo
" Bundle 'git://git.wincent.com/command-t.git'
" ...
 
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
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
let g:tagbar_left=1
let g:tagbar_width=30
let g:tagbar_sort=0
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
let g:tagbar_systemenc='cp936'
"}}}
"{{{cscope
au VimEnter *.c,*.cpp,*.s,*.cc,*.h exec "silent! cs add cscope.out"
if $CSCOPE_DB != "" "tpyically it is a include db 
	au VimEnter *.c,*.cpp,*.s,*.cc,*.h exec "silent! cs add $CSCOPE_DB"
endif
if $CSCOPE_DB1 != ""
	au VimEnter *.c,*.cpp,*.s,*.cc,*.h exec "silent! cs add $CSCOPE_DB1"
endif
if $CSCOPE_DB2 != ""
	au VimEnter *.c,*.cpp,*.s,*.cc,*.h exec "silent! cs add $CSCOPE_DB2"
endif
if $CSCOPE_DB3 != ""
	au VimEnter *.c,*.cpp,*.s,*.cc,*.h exec "silent! cs add $CSCOPE_DB3"
endif
if filereadable('ccglue.out') "this guy is more efficiency 
	au VimEnter *.c,*.cpp,*.s,*.cc,*.h exec "silent! CCTreeLoadXRefDBFromDisk ccglue.out"
endif
if has("cscope")
	" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
	set cscopetag
	set csprg=cscope
	" check cscope for definition of a symbol before checking ctags: set to 1
	" if you want the reverse search order.
	set csto=0
	set cscopequickfix=s-,c-,d-,i-,t-,e-,i-,g-
	" add any cscope database in current directory
	" else add the database pointed to by environment variable 
	set cscopetagorder=0
endif
	set cscopeverbose 
" show msg when any other cscope db added
func! Cscopemap()
	nmap <Leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
	nmap <Leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
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

	nmap <C-@><C-@>s :vert split<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@><C-@>g :vert split<CR>:cs find g <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@><C-@>d :vert split<CR>:cs find d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>
	nmap <C-@><C-@>c :vert split<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@><C-@>t :vert split<CR>:cs find t <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@><C-@>e :vert split<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@><C-@>f :vert split<CR>:cs find f <C-R>=expand("<cfile>")<CR><CR>
	nmap <C-@><C-@>i :vert split<CR>:cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>

	nmap <C-\>s :cs find s 
	nmap <C-\>g :cs find g 
	nmap <C-\>c :cs find c 
	nmap <C-\>t :cs find t 
	nmap <C-\>e :cs find e 
	nmap <C-\>f :cs find f 
	nmap <C-\>i :cs find i 
	nmap <C-\>d :cs find d 
	if g:iswindows==1 
		nmap <leader>u :call Do_CsTag()<cr>
	else
		nmap <leader>u :call CreateCscopeTags()<cr>
	endif
nmap <leader>a :cs add cscope.out<cr>:CCTreeLoadDB cscope.out<cr>
endfunc
au FileType c,cpp,asm call Cscopemap()

"kill the connection of current dir 
if has("cscope") && filereadable("cscope.out")
	nmap <leader>k :cs kill cscope.out<cr> 
endif
function! CreateCscopeTags()
	if has("cscope") && filereadable("cscope.out")
		cs kill cscope.out "kill the cscope.out in current dir only 
	endif
	if filereadable("cscope.files")
		call delete("cscope.files")
		call delete("cscope.out")
		call delete("tags")
		execute "echo \"Updating cscope.files...\r\"" 
	else
		execute "echo \"Creating cscope.files...\r\"" 
	endif
	call system("touch cscope.files")
	call system("find $PWD -name \"*.[chsS]\" > ./cscope.files")
	call system("cscope -Rbckq -i cscope.files")
	call system("ctags -R")
	execute "echo \"finish!\"" 
	if filereadable("cscope.out")
		execute "cs add cscope.out"
		execute "CCTreeLoadDB cscope.out"
	else
endfunction
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
	if(executable('ctags'))
		silent! execute "!ctags -R --c-types=+p --fields=+S *"
		silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
	endif
	if(executable('cscope') && has("cscope") )
		if(g:iswindows!=1)
			silent! execute "!find . -name \"*.[chsS]\" > ./cscope.files"
		else
			silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
		endif
		silent! execute "!cscope -Rbkq -i cscope.files"
		"silent! execute "!ccglue -S cscope.out -o ccglue.out"   "don not know how to use
		execute "normal :"
		if filereadable("cscope.out")
			execute "cs add cscope.out"
			execute "CCTreeLoadDB cscope.out"
			"execute "CCTreeLoadXRefDBFromDisk ccglue.out"
		else
			echohl WarningMsg | echo "No cscope.out" | echohl None
		endif
	endif
endfunction
"}}}
"{{{srcexpl.vim
" // The switch of the Source Explorer                                         
map <F8> :SrcExplToggle<CR>
imap <F8> <ESC>:SrcExplToggle<CR>i
"                                                                              
" // Set the height of Source Explorer window                                  
let g:SrcExpl_winHeight = 8
"                                                                              
" // Set 100 ms for refreshing the Source Explorer                             
let g:SrcExpl_refreshTime = 100
"                                                                              
" // Set "Enter" key to jump into the exact definition context                 
let g:SrcExpl_jumpKey = "<ENTER>"
"                                                                              
" // Set "Space" key for back from the definition context                      
"let g:SrcExpl_gobackKey = "<SPACE>"
"                                                                              
" // In order to Avoid conflicts, the Source Explorer should know what plugins 
" // are using buffers. And you need add their bufname into the list below     
" // according to the command ":buffers!"                                      
let g:SrcExpl_pluginList = [
			\ "__Tag_List__",
			\ "_NERD_tree_",
			\ "Source_Explorer",
			\ "*unite*"
			\ ]
"
" // Enable/Disable the local definition searching, and note that this is not  
" // guaranteed to work, the Source Explorer doesn't check the syntax for now. 
" // It only searches for a match with the keyword according to command 'gd'   
" let g:SrcExpl_searchLocalDef = 1
"                                                                              
" // Do not let the Source Explorer update the tags file when opening          
let g:SrcExpl_isUpdateTags = 0
"                                                                              
" // Use 'Exuberant Ctags' with '--sort=foldcase -R .' or '-L cscope.files' to 
" //  create/update a tags file                                                
let g:SrcExpl_updateTagsCmd = "ctags --sort=foldcase -R ."
"                                                                              
" // Set "<F12>" key for updating the tags file artificially                   
"let g:SrcExpl_updateTagsKey = "<F3>"
" // Set "<F3>" key for displaying the previous definition in the jump list 
 let g:SrcExpl_prevDefKey = "<c-p>" 

 " // Set "<F4>" key for displaying the next definition in the jump list 
 let g:SrcExpl_nextDefKey = "<C-n>" 

                                                                             
"}}}
"{{{neocomplcache or neocomplete
"neocomplete is a new plugin develop by the same author,it required lua
"feature and it is more intelligen of course...but is is unstable..so we
"use neocomplcache
if g:use_ycm==0
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
	let g:neocomplcache_include_paths = {
				\ 'cpp' : '.,d:/MinGw/lib/gcc/mingw32/4.6.2/include/c++',
				\ 'c' : '.,d:/MinGW/lib/gcc/mingw32/4.6.2/include,c:/Program Files/MinGw/include'
				\ }
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
	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
	autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
	autocmd FileType c setlocal omnifunc=ccomplete#Complete
	autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

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
	inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
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
endif
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"}}}
"{{{unite.vim 

nnoremap    [unite]   <Nop>
nmap   <SPACE> [unite]

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
let NERDTreeWinPos='right'	"show nerdtree in the rigth side
"let NERDTreeWinSize='30'
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
map <F12> :NERDTreeToggle .<CR> 
"map <2-LeftMouse>  *N "double click highlight the current cursor word 
imap <F12> <ESC> :NERDTreeToggle<CR>
"}}}
"{{{conqueterm.vim
"ConqueTerm        <command>: open in current window<command> 
"ConqueTermSplit    <command>:horizontal split window<command> 
"ConqueTermVSplit <command>:vertical split window<command> 
"ConqueTermTab    <command>:open in tab<command>
if g:iswindows==1
    let g:ConqueTerm_PyVersion = 3
else
    let g:ConqueTerm_PyVersion = 2
endif
let g:ConqueTerm_FastMode = 0        " enable fast mode 
let g:ConqueTerm_Color=0          " diable terminal colors 
let g:ConqueTerm_CloseOnEnd = 1      " close buffer when program exits 
let g:ConqueTerm_InsertOnEnter = 1
let g:ConqueTerm_StartMessages = 0
let g:ConqueTerm_PromptRegex = '^\w\+@[0-9A-Za-z_.-]\+:[0-9A-Za-z_./\~,:-]\+\$'
let g:ConqueTerm_Syntax = 'conque'
let g:ConqueTerm_CodePage=0
let g:ConqueTerm_CWInsert = 1
if (has("win32")) || has("win64")
	map <F4> :ConqueTermSplit cmd.exe<cr> 
else
	map <F4> :ConqueTermSplit bash<cr> 
endif

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
"{{{doxygen
nmap <leader>dh :DoxyFILEHeader<cr>
nmap <leader>df :DoxyFunction<cr>
map <leader>db :DoxyBlockLong<cr>
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
"let g:CCTreeUseUTF8Symbols = 1
"map <F7> :CCTreeLoadXRefDBFromDisk $CCTREE_DB<cr> 
"}}}
"{{{vimwiki
let g:vimwiki_use_mouse = 1
let g:vimwiki_list = [{'path': 'c:/vimwiki/',
\ 'path_html': 'c:/vimwiki/html/',
\ 'html_header': 'c:/vimwiki/template/header.tpl',}] 
let g:vimwiki_use_calendar=1 "use calendar plugin 
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
map <F10> :Calendar<cr>
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
    \ 'file': '\.ttc$',
    \ }
let g:ctrlp_extensions = ['tag', 'buffertag', 'dir', 'bookmarkdir']
"}}}
"{{{pyclewn
function! Pyclewnmap()
	silent! nmap <tab> :C
	exec "Cmapkeys"
	 silent! :execute "Cdbgvar"
	:execute "only"
	:rightbelow 35vsplit (clewn)_console
	:set syntax=cpp
	:wincmd h
	" watch
	:rightbelow 5split (clewn)_dbgvar
	:set syntax=cpp
	:wincmd k
endfunction
function! Pyclewnunmap()
	nmap <TAB> za
	exec "silent! Cunmapkeys"
	silent!	bwipeout (clewn)_console
	silent!	bdelete (clewn)_console
	silent! bwipeout (clewn)_dbgvar
	silent! ccl
endfunction
func! OpenClosedbgvar()
if bufexists("(clewn)_dbgvar")
	silent! bwipeout (clewn)_dbgvar
else
	:rightbelow 5split (clewn)_dbgvar
	:set syntax=cpp
endif
endfunc
let g:openflag=0
func! LoadProj()
	if filereadable(".proj")
		:silent! Pyclewn
		:call Pyclewnmap()
		:Csource .proj
		:Cstart
	else
		echohl WarningMsg | echo "No .proj file!!You must create it first( use <leader>pc )\n" | echohl None
		echohl WarningMsg | echo "wait for a second...starting Pyclewn.." | echohl None
		:5sleep
		:silent! Pyclewn
		:call Pyclewnmap()
	endif
endfunc
if g:iswindows==0
	let g:pyclewn_args = "--args=-q --gdb=async --terminal=gnome-terminal,-x"
else
	let g:pyclewn_args = "--args=-q --gdb=async"
endif
silent!	nmap <leader>pw :silent! Cdbgvar <C-R><C-W><CR>
silent! nmap <leader>pf :silent! exe "Cfoldvar " . line(".")<CR>
nmap <leader>ps :silent! Pyclewn<cr>:silent! call Pyclewnmap()<cr>
nmap <leader>pp :call LoadProj()<cr>
nmap <leader>pd :call Pyclewnunmap()<cr>:Cquit<cr>:nbclose<cr>
nmap <leader>pc :Cproject .proj<cr>
"}}}
"{{{YouCompleteMe
"it's very complicated to compile YouCompleteMe and libcang in windows,
"and its efficiency is low..so we use it only in linux or mac.
if g:use_ycm==1
	let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
	let g:ycm_complete_in_strings                           = 1
	let g:ycm_complete_in_comments                          = 1
	let g:ycm_max_diagnostics_to_display                    = 14
	let g:ycm_collect_identifiers_from_comments_and_strings = 1
	" let g:ycm_add_preview_to_completeopt                  = 1
	let g:ycm_complete_in_comments_and_strings              = 1
	let g:ycm_autoclose_preview_window_after_completion     = 1
	let g:ycm_autoclose_preview_window_after_insertion      = 1
	let g:ycm_filetypes_to_completely_ignore                = {}
	let g:ycm_filetype_blacklist                            = {
				\ 'notes'    : 1,
				\ 'markdown' : 1,
				\ 'python'   : 1,
				\ 'conque_term' : 1,
				\ 'vimwiki'  : 1
				\}
	let g:ycm_filetype_whitelist                            = {
				\ '*'	   : 1
				\}
	" let g:ycm_filetype_specific_completion_to_disable     = {}
	let g:ycm_allow_changing_updatetime                     = 0
	let g:ycm_register_as_syntastic_checker                 = 1
	let g:ycm_seed_identifiers_with_syntax                  = 1
	"let g:ycm_key_invoke_completion                       = '<C-Space>'
	" let g:ycm_key_detailed_diagnostics                    = '<leader>d'
	let g:ycm_key_list_select_completion                    = ['<Down>']
	let g:ycm_key_list_previous_completion                  = ['<Up>']
endif
"}}}
"let g:loaded_indentLine=0
"let g:indentLine_color_gui = '#A4E57E'
"let g:indentLine_enabled = 1
let g:fencview_autodetect=0 "it is look like a conflict with c.vim 
let g:fencview_auto_patterns='*.txt,*.htm{l\=},*.c,*.cpp,*.s,*.vim'
let g:NERDMenuMode=0
"rename multi file name
map <F2> :Ren<cr>
map <F11> :VE<cr><cr>
let g:startupfile="first_statup.txt"
if g:iswindows==1
	let g:start_path=$VIM.'/first_statup.txt'
else
	let g:start_path=$HOME.'/.first_statup'
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
"gui releate{{{
"list of flags that specify how the GUI works
if(has("gui_running"))
	if g:iswindows==0
		au GUIEnter * call MaximizeWindow()
		set guifont=Consolas\ 14
	else
		au GUIEnter * simalt~x "maximize window
		set guifont=Consolas:h14:cANSI
		"set gfw=Yahei_Mono:h14.5:cGB2312
		set gfw=YaHei_Consolas_Hybrid:h14.5:cGB2312
	endif
	set guioptions-=b
	"set guioptions-=m "whether use menu
	set guioptions+=r "whether show the rigth scroll bar
	set guioptions-=l "whether show the left scroll bar
	"set guioptions-=T "whether show toolbar or not
	set guitablabel=%N\ %t  "do not show dir in tab
	"set t_Co=256
	"highlight the screen line of the cursor
	"set cul
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
		amenu ToolBar.-Sep- :
		if g:iswindows==1
			amenu icon=$VIMFILES/bundle/pyclewn/debug_icons/dbgrun.bmp ToolBar.Run :silent! Pyclewn<cr>:silent! call Pyclewnmap()<cr>
			amenu icon=$VIMFILES/bundle/pyclewn/debug_icons/run.bmp ToolBar.Start :Cstart<cr>
			amenu icon=$VIMFILES/bundle/pyclewn/debug_icons/stop.bmp ToolBar.Quit :call Pyclewnunmap()<cr>:Cquit<cr>:nbclose<cr>:call Pyclewnunmap()<cr>
			amenu icon=$VIMFILES/bundle/pyclewn/debug_icons/dbgnext.bmp ToolBar.Next :Cnext<cr>
			amenu icon=$VIMFILES/bundle/pyclewn/debug_icons/dbgstep.bmp ToolBar.Step :Cstep<cr>
			amenu icon=$VIMFILES/bundle/pyclewn/debug_icons/dbgstepi.bmp ToolBar.Stepi :Cstepi<cr>
			amenu icon=$VIMFILES/bundle/pyclewn/debug_icons/dbgrunto.bmp ToolBar.Runto :Ccontinue<cr>
			amenu icon=$VIMFILES/bundle/pyclewn/debug_icons/dbgstepout.bmp ToolBar.Finish :Cfinish<cr>
			amenu icon=$VIMFILES/bundle/pyclewn/debug_icons/dbgwindow.bmp ToolBar.Watch :call OpenClosedbgvar()<cr>
			if filereadable(".proj")
				amenu icon=$VIMFILES/bundle/pyclewn/debug_icons/project.bmp ToolBar.Project :silent! Pyclewn<cr>:call Pyclewnmap()<cr>:Csource .proj<cr>:Cstart<cr>
			endif
			amenu icon=$VIMFILES/bundle/pyclewn/debug_icons/filesaveas.bmp ToolBar.SaveProject :Cproject .proj<cr>
		else
			amenu icon=$VIMFILES/bundle/pyclewn_linux/debug_icons/dbgrun.png ToolBar.Run :silent! Pyclewn<cr>:silent! call Pyclewnmap()<cr>:Cinferiortty<cr>
			amenu icon=$VIMFILES/bundle/pyclewn_linux/debug_icons/run.png ToolBar.Start :Cstart<cr>
			amenu icon=$VIMFILES/bundle/pyclewn_linux/debug_icons/dbgstop.png ToolBar.Quit :call Pyclewnunmap()<cr>:Cquit<cr>:nbclose<cr>:call Pyclewnunmap()<cr>
			amenu icon=$VIMFILES/bundle/pyclewn_linux/debug_icons/dbgnext.png ToolBar.Next :Cnext<cr>
			amenu icon=$VIMFILES/bundle/pyclewn_linux/debug_icons/dbgstep.png ToolBar.Step :Cstep<cr>
			amenu icon=$VIMFILES/bundle/pyclewn_linux/debug_icons/dbgstepi.png ToolBar.Stepi :Cstepi<cr>
			amenu icon=$VIMFILES/bundle/pyclewn_linux/debug_icons/dbgrunto.png ToolBar.Runto :Ccontinue<cr>
			amenu icon=$VIMFILES/bundle/pyclewn_linux/debug_icons/dbgstepout.png ToolBar.Finish :Cfinish<cr>
			amenu icon=$VIMFILES/bundle/pyclewn_linux/debug_icons/dbgwindow.png ToolBar.Watch :call OpenClosedbgvar()<cr>
			if filereadable(".proj")
				amenu icon=$VIMFILES/bundle/pyclewn_linux/debug_icons/project.png ToolBar.Project :silent! Pyclewn<cr>:call Pyclewnmap()<cr>:Cinferiortty<cr>:Csource .proj<cr>:Cstart<cr>
			endif
			amenu icon=$VIMFILES/bundle/pyclewn_linux/debug_icons/filesaveas.png ToolBar.SaveProject :Cproject .proj<cr>
		endif
		tmenu ToolBar.Run Connect pyclewn-->Map keys-->Cfile <user input>
		tmenu ToolBar.Start	Start debug(Cstart)
		tmenu ToolBar.Quit Stop debug
		tmenu ToolBar.Next	Next(Cnext)
		tmenu ToolBar.Step	Step(Cstep)
		tmenu ToolBar.Stepi	Stepi(Cstepi)
		tmenu ToolBar.Finish Stepout(Cfinish)
		tmenu ToolBar.Watch Open or close watch windows 
		tmenu ToolBar.Runto	Continue(Cconinue)
		tmenu ToolBar.Project Load project and start debug
		tmenu ToolBar.SaveProject Save Project setting(save as .proj)
endif
"chose your colorscheme
	let g:colorscheme_file='' "color thmem's name  
	if g:iswindows == 0
		let g:slash='/'
		let g:love_path=$HOME.'/.love'
	else
		let g:slash='\'
		let g:love_path=$HOME.'\love.txt'
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
		colorscheme wombat256 "default setting 
	endif
	function! MaximizeWindow()
		silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
	endfunction
endif
"}}}

