@echo off

set c=%1
set t=%2
shift & shift

set source=0

:loop
if not "%1"=="" (
    if "%1"=="--source" (
        set source=%2
        shift
    )
    if "%1"=="-d" (
        set d=%2
        shift
    )
    shift
    goto :loop
)

if not defined d (
    echo "-d directory is required" >&2
    exit /b 1
)

java -jar ad-edit-0.0.0.jar %c% %t% --format wav --exec ^
    java -Dfile.encoding=utf-8 -jar ebquery-0.3.1.jar -f html -d %d% -m sd "${ field(%source%) }" ^| ^
    gnupack_basic-11.00\app\cygwin\cygwin\bin\gawk "{ print $0 } END { print \"\n\" }" ^| ^
    gnupack_basic-11.00\app\cygwin\cygwin\bin\sed -e "s@\\(</audio>\\)@\\1\\n@g" ^| ^
    gnupack_basic-11.00\app\cygwin\cygwin\bin\sed -e "$s@$@\n\n\n\n\n\n\n\n\n@" ^| ^
    gnupack_basic-11.00\app\cygwin\cygwin\bin\sed -e "s@^@<?xml version=\"\"1.0\"\" ?><entry>@g" ^| ^
    gnupack_basic-11.00\app\cygwin\cygwin\bin\sed -e "s@$@</entry>@g" ^| ^
    gnupack_basic-11.00\app\cygwin\cygwin\bin\sed -n "1p" ^| ^
    gnupack_basic-11.00\app\cygwin\cygwin\bin\xmllint --nowarning --xpath "substring-after(//audio[position()=1]/@src, \"\"base64,\"\")" - ^| ^
    gnupack_basic-11.00\app\cygwin\cygwin\bin\base64 -d
    