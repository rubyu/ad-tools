@echo off

set c=%1
set t=%2
shift & shift

set source=0
set offset=0

:loop
if not "%1"=="" (
    if "%1"=="--source" (
        set source=%2
        shift
    )
    if "%1"=="--offset" (
        set offset=%2
        shift
    )
    if "%1"=="-d" (
        set d=%2
        shift
    )
    shift
    goto :loop
)

set /a "index = offset + 1"

if not defined d (
    echo "-d directory is required" >&2
    exit /b 1
)

java -jar dep\ad-edit-0.0.1.jar %c% %t% --format wav --exec ^
    java -Dfile.encoding=utf-8 -jar dep\ebquery-0.3.1.jar -f html -d %d% -m sd "${ field(%source%) }" ^| ^
    gawk "{ print $0 } END { print \"\n\n\n\n\n\n\n\n\n\n\" }" ^| ^
    sed -e "s@\\(</audio>\\)@\\1\\n@g" ^| ^
    sed -e "s@^@<?xml version=\"\"1.0\"\" ?><entry>@g" ^| ^
    sed -e "s@$@</entry>@g" ^| ^
    sed -n "%index%p" ^| ^
    xmllint --xpath "substring-after(//audio[position()=1]/@src, \"\"base64,\"\")" - ^| ^
    base64 -d
