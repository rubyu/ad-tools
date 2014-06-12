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
    if "%1"=="-m" (
        set m=%2
        shift
    )
    if "%1"=="--ebmap" (
        set ebmap=%2
        shift
    )
    shift
    goto :loop
)

if not defined d (
    echo "-d directory is required" >&2
    exit /b 1
)

set command=java -jar dep\ad-edit-0.0.0.jar %c% %t% --format html

set command=%command% --exec java -Dfile.encoding=utf-8 -jar dep\ebquery-0.3.1.jar -f html -d %d%

if defined m (
    set command=%command% -m %m%
)

if defined ebmap (
    set command=%command% --ebmap %ebmap%
)

set command=%command% "${ field(%source%) }"

%command%