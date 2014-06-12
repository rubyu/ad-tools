@echo off

set t=%1
set e=%2
SHIFT & SHIFT

:loop
if not "%1"=="" (
    if defined a (
        set a=%a% %1
    ) else (
        set a=%1
    )
    shift
    goto :loop
)

%e% set-field %t% %a%