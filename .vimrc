"@file       .vimrc
"@brief      for linux's gvim
"@date       2012-12-30 11:01:30
"@author     tracyone,tracyone@live.cn
"@lastchange 2013-05-05 15:42:47
""""""""""""""""""""""""""""""""""""""""""""""""""""

"behave very Vi compatible (not advisable)
set nocp 
" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
filetype plugin indent on

""{{{fuck the encoding
"function! Utf8()
	"character encoding used in Vim: "latin1", "utf-8"
	set encoding=utf-8

	set termencoding=utf-8
	"automatically detected character encodings
	set fileencodings=utf-8,chinese,latin-1,cp936,gb18030,usc-bom,euc-jp,gbk,gb2312

	"character encoding for the current file(local to buffer)
	set fileencoding=utf-8

	"dealing with menu and the right key encode
	source $VIMRUNTIME/delmenu.vim
	source $VIMRUNTIME/menu.vim

	"consle output encode
	language messages zh_CN.utf-8
"endfunction
"set fileencodings=utf-8,chinese,latin-1,cp936,gb18030,usc-bom,euc-jp,gbk,gb2312
"set ambiwidth=double
""}}}
"{{{system check
if (has("win32"))
	let $HOME=$VIM
	set filetype=dos
	"list of directory names used for file searching
	set path=./,C:\Program\ Files\IAR\ Systems\Embedded\ Workbench\ 6.0\arm\inc\,C:\MinGW\include,C:\Program\ Files\IAR\ Systems\Embedded\ Workbench\ 6.0\arm\CMSIS\Include,,
	let $VIMFILES = $VIM.'/vimfiles'
	let g:iswindows=1 "windows flags
elseif has("unix")
	set filetype=unix
	if filereadable("/etc/vim/vimrc.local")
		source /etc/vim/vimrc.local
	endif
	set shell=bash
	runtime! debian.vim
	"list of directory names used for file searching
	set path=./,/usr/include/,,
	let $VIMFILES = $HOME.'/.vim'
	let g:iswindows=0
elseif has("mac")
endif
"}}}
"{{{fold setting
"folding type: "manual", "indent", "expr", "marker" or "syntax"
set foldenable                  " enable folding
set foldcolumn=1                " add a fold column and specific it's width
autocmd FileType c,cpp set foldmethod=syntax 
autocmd FileType vim set foldmethod=marker " detect triple-{ style fold markers
autocmd FileType verilog set foldmethod=manual 
au BufRead,BufNewFile *.vimprojects set filetype=project
au FileType project,vim set foldlevel=0
set foldlevel=100         " start out with everything folded
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
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
"set foldtext=foldtext()
"}}}
"{{{basic setting
highlight StatusLine guifg=White guibg=Orange	

highlight StatusLineNC guifg=LightGrey guibg=LightSlateGrey	

highlight ModeMsg guifg=White guibg=LimeGreen	
set showfulltag

"open syntax
syntax on

"display unprintable characters by set list
"set list
"Strings to use in 'list' mode and for the |:list| command
set listchars=tab:\|\ ,trail:-

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"{{{backup
"generate a backupfile when open file
set backup

"backup file'a suffix
set backupext=.bak

"swp file's directory
set directory=$HOME/vimbackup
if !isdirectory(&directory)
	call mkdir(&directory, "p")
endif

"backup file's directory
set backupdir=$HOME/vimbackup
if !isdirectory(&backupdir)
	call mkdir(&backupdir, "p")
endif
"}}}

function! MaximizeWindow()
	silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
endfunction

"Threshold for reporting number of lines changed
set report=0

"help doc dir
"let helptags=$VIMFILES.'/doc'
"choose help helplang

set helplang=en,cn  "set helplang=en

"autoread when a file is changed from the outside
set autoread

"show the line number for each line
set nu

"number of lines used for the command-line
set cmdheight=1

"when inserting a bracket, briefly jump to its match
set showmatch

"name of the font to be used for :hardcopy,打印
set printfont=yaheimono:h10:cGB2312

"override 'ignorecase' when pattern has upper case characters
set smartcase

"list of flags for using the mouse,support all
set mouse=a

""extend", "popup" or "popup_setpos"; what the right
"set mousemodel=extend

"start a dialog when a command fails
set confirm

"do clever autoindenting
set smartindent

"don't auto linefeed
"set nowrap   

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

"highlight the screen line of the cursor
"set cul

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

"alternate format to be used for a status line
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}

"0, 1 or 2; when to use a status line for the last window
set laststatus=2 "always show status

"automatic recognition vt file as verilog 
au BufRead,BufNewFile *.vt set filetype=verilog

"automatic recognition bld file as javascript 
au BufRead,BufNewFile *.bld set filetype=javascript

"automatic recognition xdc file as javascript
au BufRead,BufNewFile *.xdc set filetype=javascript

"automatic recognition cfg file as javascript
au BufRead,BufNewFile *.cfg set filetype=javascript
"}}}
"{{{key mapping

""no", "yes" or "menu"; how to use the ALT key
set winaltkeys=no

"leader key
let mapleader=","
"open the vimrc
nmap <leader>vc :e $MYVIMRC<cr>
"update the _vimrc
map <leader>so :source $MYVIMRC<CR>:e<CR>

nmap vv V
" <Enter> always means inserting line.
nmap <Enter> o<ESC>

"clear search result
noremap <a-q> :nohls<CR>

"save file
nmap <c-s> <esc>:w<cr>
imap <c-s> <esc>:w<cr>a

"heightlight when double click
map <2-LeftMouse>  *N
"map! <2-LeftMouse> <c-o>*
"autocmd CursorMoved * silent! exe printf('match Underlined /\<%s\>/', expand('<cword>'))
"autocmd CursorHold * silent! exe printf('match Underlined /\<%s\>/', expand('<cword>'))
set ut=1500
"select all
nmap <m-a> <esc>ggVG

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
imap <C-V>		<esc>"+gP
cmap <c-v>	<c-r>*

"move
imap <A-h> <Left>
imap <A-l> <Right>
imap <A-j> <Down>
imap <A-k> <Up>

"replace
nmap <c-h> :%s/<C-R>=expand('<cword>')<cr>

"{{{compile releate
map <F1> :call Do_OneFileMake()<CR>

map <F6> :call Do_make()<CR>
map <c-F6> :silent make clean<CR>

"debug func
function! Debug()
	exec "w"
	"c program
	if &filetype == 'c'
		exec "!gcc % -g -o %<.exe"
		exec "!gdb %<.exe"
	elseif &filetype == 'cpp'
		exec "!g++ % -g -o %<.exe"
		exec "!gdb %<.exe"
	endif
endfunc

function! Do_make()
	set makeprg=make
	execute "silent make"
	execute "copen"
endfunction 

"compile and run open quickfix if wrong
function! Do_OneFileMake()
	if expand("%:p:h")!=getcwd()
		echohl WarningMsg | echo "Fail to make! This file is not in the current dir! Press <F7> to redirect to the dir of this file." | echohl None
		return
	endif
	let sourcefileename=expand("%:t")
	if (sourcefileename=="" || (&filetype!="cpp" && &filetype!="c"))
		echohl WarningMsg | echo "Fail to make! Please select the right file!" | echohl None
		return
	endif
	let deletedspacefilename=substitute(sourcefileename,' ','','g')
	if strlen(deletedspacefilename)!=strlen(sourcefileename)
		echohl WarningMsg | echo "Fail to make! Please delete the spaces in the filename!" | echohl None
		return
	endif
	if &filetype=="c"
		if g:iswindows==1
			set makeprg=gcc\ -g\ -o\ %<.exe\ %
		else
			set makeprg=gcc\ -g\ -o\ %<\ %
		endif
	elseif &filetype=="cpp"
		if g:iswindows==1
			set makeprg=g++\ -o\ %<.exe\ %
		else
			set makeprg=g++\ -o\ %<\ %
		endif
		"elseif &filetype=="cs"
		"set makeprg=csc\ \/nologo\ \/out:%<.exe\ %
	endif
	if(g:iswindows==1)
		let outfilename=substitute(sourcefileename,'\(\.[^.]*\)' ,'.exe','g')
		let toexename=outfilename
	else
		let outfilename=substitute(sourcefileename,'\(\.[^.]*\)' ,'','g')
		let toexename=outfilename
	endif
	if filereadable(outfilename)
		if(g:iswindows==1)
			let outdeletedsuccess=delete(getcwd()."\\".outfilename)
		else
			let outdeletedsuccess=delete("./".outfilename)
		endif
		if(outdeletedsuccess!=0)
			set makeprg=make
			echohl WarningMsg | echo "Fail to make! I cannot delete the ".outfilename | echohl None
			return
		endif
	endif
	execute "silent make"
	set makeprg=make
	execute "normal :"
	if filereadable(outfilename)
		if(g:iswindows==1)
			execute "!".toexename
		else
			execute "!./".toexename
		endif
	endif
	execute "copen"
endfunction

nmap <F2> :run macros/gdb_mappings.vim<CR>
"}}}

"delete the ^M
nmap dm :%s/\r\(\n\)/\1/g<CR>

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

vnoremap <silent> > >gv
vnoremap <silent> < <gv
"}}}
"{{{plugin setting

"{{{tohtml
let html_use_css=1
"}}}
"{{{fuzzyfinder
"<CR>  (|g:fuf_keyOpen|)        - opens in a previous window.
"<C-j> (|g:fuf_keyOpenSplit|)   - opens in a split window.
"<C-k> (|g:fuf_keyOpenVsplit|)  - opens in a vertical-split window.
"<C-l> (|g:fuf_keyOpenTabpage|) - opens in a new tab page.
let g:fuf_modesDisable = []
"let g:fuf_enumeratingLimit = 10
let g:fuf_mrufile_maxItem = 20
let g:fuf_mrucmd_maxItem = 20
"recursive open 
nmap <F5> :FufFile **/<cr>   
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
nmap <silent><leader>tb :TagbarToggle<CR>
if has("win32")
	let g:tagbar_ctags_bin='c:\VimTools\ctags.exe'
else
	let g:tagbar_ctags_bin='ctags' 
endif
let g:tagbar_left=1
let g:tagbar_width=30
let g:tagbar_sort=0
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
let g:tagbar_systemenc='cp936'
"}}}
"{{{tilst
if (has("win32"))
	let Tlist_Ctags_Cmd='c:/VimTools/ctags.exe'
else
	let Tlist_Ctags_Cmd='/usr/bin/ctags'	"Specifies the path to the ctags utility.
endif
let Tlist_Auto_Highlight_Tag=1			
let Tlist_Auto_Open=0					"To automatically open the taglist window
let Tlist_Close_On_Select=0				"If you want to close the taglist window when a file or tag is selected,then set it
let Tlist_Exit_OnlyWindow=1				"If you want to exit Vim if only the taglist window is currently opened,then set it

"To automatically close the tags tree for inactive files, you can set the
"'Tlist_File_Fold_Auto_Close' variable to 1. When this variable is set to 1,
"the tags tree for the current buffer is automatically opened and for all the
"other buffers is closed.
let Tlist_File_Fold_Auto_Close=1	
let Tlist_GainFocus_On_ToggleOpen=1		" controls whether the cursor is moved to the taglist window or remains
"in the current window.
let Tlist_Max_Submenu_Items=25
let Tlist_Max_Tag_length=20
let Tlist_Process_File_Always=0		" generate the listof tags for new files even when the taglist window is closed 
let Tlist_Show_Menu=1				"When using GUI Vim,set this can show the menu
let Tlist_Show_One_File=1
let Tlist_Sort_Type='order'			
let Tlist_OnlyWindow=1
let Tlist_Use_Right_Window=1
let Tlist_Use_SingleClick=0			"single click open the tag
let Tlist_WinHeight=10
let Tlist_WinWidth=18
let Tlist_Use_Horiz_Window=0
let Tlist_Enable_Fold_Column =0 
let Tlist_Display_Prototype = 0
map <silent> <leader>tl :TlistToggle<CR>
"}}}
"{{{cscope
if filereadable("cscope.out")
	cs add cscope.out
	if has("cscope")
		" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
		set cscopetag
		set csprg=cscope
		" check cscope for definition of a symbol before checking ctags: set to 1
		" if you want the reverse search order.
		set csto=0
		""set cscopequickfix=s+,c+,d+,i+,t-,e-
		" add any cscope database in current directory
		" else add the database pointed to by environment variable 
		set cscopetagorder=0
	elseif $CSCOPE_DB != ""
		cs add $CSCOPE_DB
	endif
endif
	set cscopeverbose 
" show msg when any other cscope db added

"key mapping
nmap  <leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
nmap  <Leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
nmap  <Leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
nmap  <Leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
nmap  <Leader>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
nmap  <Leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
nmap  <Leader>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap  <Leader>d :cs find d <C-R>=expand("<cword>")<CR><CR>	

nmap <C-\>s :cs find s 
nmap <C-\>g :cs find g 
nmap <C-\>c :cs find c 
nmap <C-\>t :cs find t 
nmap <C-\>e :cs find e 
nmap <C-\>f :cs find f 
nmap <C-\>i :cs find i 
nmap <C-\>d :cs find d 


" The :scscope command does the same(cs command) and also splits the window (short: scs).
nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>

" Hitting CTRL-@ *twice* before the search type does a vertical
" split instead of a horizontal one
nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>	
nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>
""key map timeouts
"set notimeout 
"set timeoutlen=4000
"set ttimeout
"set ttimeoutlen=100
nmap <leader>u :call CreateCscopeTags()<cr>
nmap <leader>a :cs add cscope.out<cr>
nmap <leader>k :cs kill -1<cr>
function! CreateCscopeTags()
	if filereadable("cscope.files")
		call delete("cscope.files")
		call delete("cscope.out")
		call delete("tags")
		execute "echo \"Updating cscope.files...\r\"" 
	else
		execute "echo \"Creating cscope.files...\r\"" 
		if(g:iswindows==1)
			call system("echo > cscope.files")
			call system("set Path=c:\VimTools\;C:\MinGW\bin;")
			call system("unix_find %~dp0 -name \"*.[chsS]\" > ./cscope.files")
		else
			call system("touch cscope.files")
			call system("find $PWD -name \"*.[chsS]\" > ./cscope.files")
		endif
	endif
	call system("cscope -bkq -i cscope.files")
	call system("ctags -R")
	execute "echo \"finish!hit <leader>a to add database\r\"" 
endfunction
"}}}
"{{{srcexpl.vim
" // The switch of the Source Explorer                                         
nmap <F8> :SrcExplToggle<CR>
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
let g:SrcExpl_gobackKey = "<SPACE>"
"                                                                              
" // In order to Avoid conflicts, the Source Explorer should know what plugins 
" // are using buffers. And you need add their bufname into the list below     
" // according to the command ":buffers!"                                      
let g:SrcExpl_pluginList = [
			\ "__Tag_List__",
			\ "_NERD_tree_",
			\ "Source_Explorer"
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
" let g:SrcExpl_updateTagsCmd = "ctags --sort=foldcase -R ."
"                                                                              
" // Set "<F12>" key for updating the tags file artificially                   
"let g:SrcExpl_updateTagsKey = "<F12>"
"                                                                              
" Just_change_above_of_them_by_yourself:                                     
"                                                                              
"}}}
"{{{neocomplcache
" Use neocomplcache. 
let g:neocomplcache_enable_at_startup = 1

""set completeopt=menu,longest 

"" Disable AutoComplPop. 
let g:acp_enableAtStartup = 0 

" Use smartcase. 
"let g:neocomplcache_enable_smart_case = 0 

"" Use camel case completion. 
let g:neocomplcache_enable_camel_case_completion = 1 

"" Use underbar completion. 
let g:neocomplcache_enable_underbar_completion = 1 

"Set minimum syntax keyword length. 
let g:neocomplcache_min_syntax_length = 2 

"let g:neocomplcache_lock_buffer_name_pattern = '/*ku/*' 

"let g:neocomplcache_enable_auto_delimiter = 1 

"do not auto show complete menu
"let g:neocomplcache_disable_auto_complete = 1   

"let g:neocomplcache_enable_wildcard = 1 

"" Define dictionary. 

let g:neocomplcache_dictionary_filetype_lists = { 'default' : '','vimshell' : $HOME.'/_vimshell_hist', 'scheme' : $HOME.'/.gosh_completions',} 


""Define keyword. 

"if !exists('g:neocomplcache_keyword_patterns') 
"let g:neocomplcache_keyword_patterns = {} 
"endif 
"let g:neocomplcache_keyword_patterns['default'] = '/h/w*' 


"""let g:neocomplcache_enable_auto_select = 1 

"let g:neocomplcache_enable_caching_message=1 


""" Enable omni completion. 

"autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS 

"autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags 

"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS 

"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete 

"autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags 

"autocmd filetype cpp set omnifunc=omni#cpp#complete#main

""Enable heavy omni completion. 

"if !exists('g:neocomplcache_omni_patterns') 
"let g:neocomplcache_omni_patterns = {} 
"endif 

"let g:neocomplcache_omni_patterns.ruby = '[^. */t]/./w*/|/h/w*::' 

"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete 

"let g:neocomplcache_omni_patterns.php = '[^. /t]->/h/w*/|/h/w*::' 

"let g:neocomplcache_omni_patterns.c = '/%(/./|->/)/h/w*' 

"let g:neocomplcache_omni_patterns.cpp = '/h/w*/%(/./|->/)/h/w*/|/h/w*::' 

"For input-saving, this variable controls whether you can  choose a candidate with a alphabet or number displayed beside a candidate after '-'.  When you input 'ho-a',  neocomplcache will select candidate 'a'.
imap <expr> -  pumvisible() ? "\<Plug>(neocomplcache_start_unite_quick_match)" : '-'

" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <expr><silent> <CR> <SID>my_cr_function()
"function! s:my_cr_function()
"return pumvisible() ? neocomplcache#close_popup() . "\<CR>" : "\<CR>"
"endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
"}}}
"{{{unite.vim 

nnoremap    [unite]   <Nop>
nmap    <space> [unite]

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
map <2-LeftMouse>  *N
imap <F12> <ESC> :NERDTreeToggle<CR>
"}}}
"{{{BufExplorer
let g:bufExplorerDefaultHelp=1       " Do not show default help.
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
let g:bufExplorerSplitRight=0        " Split left.
let g:bufExplorerUseCurrentWindow=1  " Open in new window
let g:bufExplorerShowDirectories=1   " Show directories.
"}}}
"{{{conqueterm.vim
"ConqueTerm        <command>: open in current window<command> 
"ConqueTermSplit    <command>:horizontal split window<command> 
"ConqueTermVSplit <command>:vertical split window<command> 
"ConqueTermTab    <command>:open in tab<command>
let g:ConqueTerm_FastMode = 0        " enable fast mode 
let g:ConqueTerm_Color=0          " diable terminal colors 
let g:ConqueTerm_CloseOnEnd = 1      " close buffer when program exits 
let g:ConqueTerm_InsertOnEnter = 1
let g:ConqueTerm_StartMessages = 0
let g:ConqueTerm_PromptRegex = '^\w\+@[0-9A-Za-z_.-]\+:[0-9A-Za-z_./\~,:-]\+\$'
let g:ConqueTerm_Syntax = 'conque'
let g:ConqueTerm_CodePage=0
if (has("win32"))
	map <A-space> :ConqueTermSplit cmd.exe<cr> 
else
	map <A-space> :ConqueTermSplit bash<cr> 
endif
"}}}
"{{{a.vim
":A switches to the header file corresponding to the current file being  edited (or vise versa)
":AS splits and switches
":AV vertical splits and switches
":AT new tab and switches
":AN cycles through matches
":IH switches to file under cursor
nmap <A-h> :IH<cr>
":IHS splits and switches
":IHV vertical splits and switches
":IHT new tab and switches
nmap <A-t> :IHT<cr>
":IHN cycles through matches
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
"{{{delimitmate
au FileType verilog,c let b:delimitMate_matchpairs = "(:),[:],{:}"
let delimitMate_nesting_quotes = ['"','`']
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
let delimitMate_excluded_regions = "Comment,String,Statement"
"Conditional,Repeat,Label,Operator,PreCondit,Macro
"}}}
"{{{vundle
"
let s:justvundled = 0
if has('win32')
	cd $HOME
    call system('dir .\.vim\bundle\vundle')
else
    call system('ls ~/.vim/bundle/vundle')
endif
if v:shell_error
    if has('win32')
        call system('mkdir .\.vim\bundle\vundle')
        call system('git clone https://github.com/gmarik/vundle.git .\.vim\bundle\vundle')
    else
        call system('mkdir -p ~/.vim/bundle/vundle')
        call system('git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle')
    endif
    if !v:shell_error
        let s:justvundled = 1
    endif
endif

if has('win32')
    set rtp+=.\.vim\bundle\vundle
else
    set rtp+=~/.vim/bundle/vundle/
endif

" let Vundle manage Vundle
" required! 
call vundle#rc()
Bundle 'gmarik/vundle'
 
" My Bundles here:
"
" original repos on github
" Bundle 'tpope/vim-fugitive'
" Bundle 'Lokaltog/vim-easymotion'
" Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
" Bundle 'tpope/vim-rails.git'
" vim-scripts repos
Bundle 'a.vim'
Bundle 'Align'
Bundle 'bufexplorer.zip'
Bundle 'calendar.vim'
Bundle 'Colour-Sampler-Pack'
Bundle 'Conque-Shell'
Bundle 'tracyone/c.vim'
Bundle 'amiorin/ctrlp-z'
Bundle 'ctrlp.vim'
Bundle 'delimitMate.vim'
Bundle 'FuzzyFinder'
Bundle 'genutils'
Bundle 'neocomplcache'
Bundle 'The-NERD-Commenter'
Bundle 'scrooloose/nerdtree'
Bundle 'ShowMarks7'
Bundle 'SrcExpl'
Bundle 'surround.vim'
Bundle 'Tagbar'
Bundle 'taglist.vim'
Bundle 'unite.vim'
Bundle 'vimdoc'
Bundle 'L9'
Bundle 'ZenCoding.vim'
Bundle 'vimwiki'
Bundle 'matrix.vim--Yang'
Bundle 'FencView.vim'
Bundle 'Markdown'
Bundle 'LaTeX-Suite-aka-Vim-LaTeX'
Bundle 'DrawIt'
Bundle 'altercation/vim-colors-solarized'
Bundle 'mbbill/VimExplorer'
Bundle 'renamer.vim'
 
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
"let g:loaded_indentLine=0
"let g:indentLine_color_gui = '#A4E57E'
"let g:indentLine_enabled = 1
let g:fencview_autodetect=1
let g:NERDMenuMode=0
"let g:Powerline_symbols = 'fancy'

"}}}
"{{{gui setting
if(has("gui_running"))
	if(g:iswindows==1)
		set guifont=Monaco:h14:b:cANSI
		au GUIEnter * simalt~x "maximize window
	else
		set guifont=consolas\ 18
		au GUIEnter * call MaximizeWindow()
	endif
	colorscheme desert256
	" If using a dark background within the editing area and syntax highlighting
	" turn on this option as well
	set background=dark
	"list of flags that specify how the GUI works
	set guioptions-=b
	"set guioptions-=m "whether use menu
	set guioptions-=r "whether show the rigth scroll bar
	set guioptions-=l "whether show the left scroll bar
	"set guioptions-=T "whether show toolbar or not
	set guitablabel=%N\ %t  "do not show dir in tab
	behave xterm
else
	set background=light
endif
"}}}

