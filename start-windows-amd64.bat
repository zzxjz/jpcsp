@echo off
rem CD to the path of the command line, this is required when running as an administrator
cd /D "%~dp0"

set PATH=%PATH%;lib\;lib\windows-amd64\

if NOT EXIST "%SystemRoot%\SysWOW64" goto JAVA32

if "%ProgramFiles%" == "%ProgramFiles(x86)%" goto JAVA32SHELL

set JAVA_CMD=java.exe
where /q java.exe
if ERRORLEVEL 0 goto RUN

rem Checking if the "reg" command is available
reg /? >NUL 2>NUL
if ERRORLEVEL 1 goto RUN

set key=HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment
set JAVA_VERSION=
set JAVA_HOME=
for /f "tokens=3* skip=2" %%a in ('reg query "%key%" /v CurrentVersion') do set JAVA_VERSION=%%a
for /f "tokens=2* skip=2" %%a in ('reg query "%key%\%JAVA_VERSION%" /v JavaHome') do set JAVA_HOME=%%b

set JAVA_CMD=%JAVA_HOME%\bin\java.exe
if not exist "%JAVA_CMD%" set JAVA_CMD=%ProgramFiles(x86)%\Java\jre7\bin\java.exe
if not exist "%JAVA_CMD%" goto JAVAMISSING

:RUN
echo Running Jpcsp 64bit...
"%JAVA_CMD%" -Xmx2048m -Xss2m -XX:ReservedCodeCacheSize=64m -Djava.library.path=lib/windows-amd64;lib/jinput-2.0.9-natives-all -Dorg.lwjgl.system.allocator=system -classpath "bin/jpcsp.jar;lib/lwjgl-3.2.3/lwjgl.jar;lib/lwjgl-3.2.3/lwjgl-openal.jar;lib/lwjgl-3.2.3/lwjgl-opengl.jar;lib/lwjgl-3.2.3/lwjgl-jawt.jar;lib/lwjgl-3.2.3/lwjgl-natives-windows.jar;lib/lwjgl-3.2.3/lwjgl-openal-natives-windows.jar;lib/lwjgl-3.2.3/lwjgl-opengl-natives-windows.jar;lib/lwjgl-3.2.3/lwjgl-glfw.jar;lib/lwjgl-3.2.3/lwjgl-glfw-natives-windows.jar" jpcsp.MainGUI %*
if ERRORLEVEL 1 goto PAUSE
goto END

:JAVA32
echo Unable to run a 64bit build on a 32bit platform. Install a 64bit version of Windows first.
goto PAUSE

:JAVA32SHELL
echo Unable to properly run a 64bit application from a 32bit context on a 64bit platform.
goto PAUSE

:JAVAMISSING
echo The required version of Java has not been installed.
echo Go to
echo     http://www.oracle.com/technetwork/java/javase/downloads/index.html
echo to install the "Windows x64" Java JRE.

:PAUSE
pause

:END
