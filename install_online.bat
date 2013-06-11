@echo off
setlocal enabledelayedexpansion
set path=C:\Program Files\WinRAR;%path%
cls
echo ---------------------------------------------------------------
echo This is a installation wizard for install gvim on win32.
echo Make sure Your windows is not a streamline system or it will turn out
echo some error.
echo Make sure your network is available
echo ---------------------------------------------------------------
pause
mkdir install_vim
cd install_vim

REM ---------------------------------------------------------------
mkdir python
cd python
cls
echo Downloading pyclewn....
ping 0.0.0.0 -n 2 > nul
.\wget.exe http://jaist.dl.sourceforge.net/project/pyclewn/pyclewn-1.10/pyclewn-1.10.py3.win32-py3.2.exe
echo Downloading python-3.2 and Python for Windows extensions....
echo Dectct your operating system architecture...
ping 0.0.0.0 -n 2 > nul
if /i "%PROCESSOR_IDENTIFIER:~0,3%" == "X86" goto 1 
if /i "%PROCESSOR_IDENTIFIER:~0,3%" NEQ "X86" goto 2 
:1
echo Downloading x86 version...
ping 0.0.0.0 -n 2 > nul
.\wget.exe http://www.python.org/ftp/python/3.2.5/python-3.2.5.msi
.\wget.exe  "http://sourceforge.net/projects/pywin32/files/pywin32/Build 218/pywin32-218.win32-py3.2.exe/download"
goto 3
:2
echo Downloading x86_64 version...
ping 0.0.0.0 -n 2 > nul
.\wget.exe http://www.python.org/ftp/python/3.2.5/python-3.2.5.amd64.msi 
.\wget.exe "http://sourceforge.net/projects/pywin32/files/pywin32/Build%20218/pywin32-218.win-amd64-py3.2.exe/download"
:3
cd ..

REM ---------------------------------------------------------------
mkdir git
cd git
echo Downloading git for windows...
ping 0.0.0.0 -n 2 > nul
.\wget.exe http://msysgit.googlecode.com/files/Git-1.8.3-preview20130601.exe
cd ..

REM ---------------------------------------------------------------
mkdir Vim
cd Vim
echo Downloading gvim ....
ping 0.0.0.0 -n 2 > nul
.\wget.exe --no-check-certificate https://github.com/tracyone/vim73/archive/master.zip
WinRAR.exe X master.zip 
ren vim73-master vim73
del /s /f /q master.zip

REM ---------------------------------------------------------------
echo Downloading vim config .....
ping 0.0.0.0 -n 2 > nul
.\wget.exe --no-check-certificate https://github.com/tracyone/vim/archive/master.zip
WinRAR.exe X master.zip 
ren vim-master vim
move vim\_vimrc .
rd /S /Q vim 
del /F /S /Q master.zip
cd ..

REM ---------------------------------------------------------------
echo Downloading MinGw....
ping 0.0.0.0 -n 2 > nul
mkdir MinGw
cd MinGw
.\wget.exe https://sourceforge.net/projects/mingw/files/Installer/mingw-get-inst/mingw-get-inst-20120426/mingw-get-inst-20120426.exe/download
cd ..

REM ---------------------------------------------------------------
echo Downloading fonts...
ping 0.0.0.0 -n 2 > nul
.\wget.exe --no-check-certificate https://github.com/tracyone/program_font/archive/master.zip
WinRAR.exe X master.zip 
ren program_font-master program_font
del /F /S /Q master.zip
cls

goto menu1
:input_error
echo You enter the wrong number,inut again!
ping 0.0.0.0 -n 2 > nul
:menu1
cls
echo ---------------------------------------------------------------
echo Start installing..
echo Install gvim in c:\Program Files\Vim		(ENTER 1)
echo Install gvim in d:\Program Files\Vim		(ENTER 2)
echo Install gvim in e:\Program Files\Vim		(ENTER 3)
echo Exit the install				(ENTER 4)
echo ---------------------------------------------------------------
echo Enter Choice:
set /p ans1=
if not defined ans1 goto input_error
if %ans1%==1 (
set install_path=c:\Program Files\
goto start_install
)
if %ans1%==2 (
set install_path=d:\Program Files\
goto start_install
)
if %ans1%==3 (
set install_path=e:\Program Files\
goto start_install
)
if %ans1%==4 (
goto quit
) else (
goto input_error
)
:start_install
echo install gvim....
set temp="%install_path%"
if not exist %temp% goto MKDIR
if exist %temp% goto INSTALL
:MKDIR
echo Path %temp% is not exist ,i will create for you
mkdir "%temp%"
:INSTALL
mkdir "%install_path%Vim"
xcopy /E Vim  "%install_path%Vim"
cls
echo ---------------------------------------------------------------
echo Register vim...press d directly and it will do all thing for you
echo You can choose the option yourself of course,don not forget press d before quit
ping 0.0.0.0 -n 3 > nul
"%install_path%Vim\vim73\install.exe"
cls
echo Install VmTools...
ping 0.0.0.0 -n 2 > nul
mkdir "%install_path%Vim\VimTools"
xcopy /E VimTools  "%install_path%Vim\VimTools"
cls
echo Install some fonts....
echo make sure you have Administrator privileges
echo -----------------------------------------------------
ping 0.0.0.0 -n 2 > nul
xcopy /E program_font\*.ttf C:\WINDOWS\Fonts\
start /MIN explorer c:\WINDOWS\Fonts\
cls
echo Install MinGw A native Windows port of the GNU Compiler Collection (GCC)
echo Recommended that you install msys
echo -----------------------------------------------------
ping 0.0.0.0 -n 2 > nul
.\MinGw\mingw-get-inst-20120426.exe
cls
echo Setup Environment.....
echo -----------------------------------------------------
ping 0.0.0.0 -n 3 > nul
set GVIM_PATH=%install_path%Vim\vim73
set VMTOOLS_PATH=%install_path%Vim\VimTools\
copy python\mfc100u.dll c:\WINDOWS\system32\
wmic /help 2>nul
wmic environment where "name='Path' and username='<system>'" set VariableValue="%Path%;%GVIM_PATH%;%VMTOOLS_PATH%"
set Path=%Path%;%install_path%Vim\vim73
echo Restart explorer.......
ping 0.0.0.0 -n 3 > nul
taskkill /f /im explorer.exe
ping 0.0.0.0 -n 2 > nul
wmic process call create explorer.exe
cls
echo Python releate,it must be installed...
echo Install it with default setting.
echo -----------------------------------------------------
ping 0.0.0.0 -n 2 > nul
echo This is python3.2.5..
for /f %%i in ('dir python-3*.msi /s /b') do %%i
echo This is Extendtion of python...
for /f %%i in ('dir pywin32*.exe /s /b') do %%i
echo This is pyclewn,a plugin of vim which can use gdb debug in vim..
 .\python\pyclewn-1.10.py3.win32-py3.2.exe
 cls
echo Do some cleanup work....
ping 0.0.0.0 -n 3 > nul
rd /S /Q  "%install_path%Vim\vimfiles\autoload"
rd /S /Q  "%install_path%Vim\vimfiles\doc"
rd /S /Q  "%install_path%Vim\vimfiles\macros"
rd /S /Q  "%install_path%Vim\vimfiles\plugin"
rd /S /Q  "%install_path%Vim\vimfiles\syntax"
rd /S /Q  "%install_path%Vim\vimfiles\autoload"
rd /S /Q  "%install_path%Vim\vimfiles\colors"
rd /S /Q  "%install_path%Vim\vimfiles\compiler"
rd /S /Q  "%install_path%Vim\vimfiles\ftdetect"
rd /S /Q  "%install_path%Vim\vimfiles\ftplugin"
rd /S /Q  "%install_path%Vim\vimfiles\indent"
rd /S /Q  "%install_path%Vim\vimfiles\keymap"
del /f /s /q c:\WINDOWS\system32\dllcache\find.exe
del /f /s /q c:\WINDOWS\system32\dllcache\sort.exe
del /f /s /q c:\WINDOWS\system32\find.exe
del /f /s /q c:\WINDOWS\system32\sort.exe
cls
echo Install git for windows ....
ping 0.0.0.0 -n 3 > nul
for /f %%i in ('dir .\git\Git*.exe /s /b') do %%i
goto menu2
:menu2
cls
echo That's all. Enjoy vimming !
echo Made in China by tracyone.
pause
:quit
exit

