@echo off
setlocal enabledelayedexpansion

REM ===== START DATE (June 2025) =====
set startDate=2025-06-01

REM ===== DAYS (till now) =====
for /l %%i in (0,1,300) do (

    REM Get current date
    for /f %%d in ('powershell -command "(Get-Date \"%startDate%\").AddDays(%%i).ToString(\"yyyy-MM-ddTHH:mm:ss\")"') do (
        set currentDate=%%d
    )

    REM Get day of week (0=Sun, 6=Sat)
    for /f %%w in ('powershell -command "(Get-Date \"%startDate%\").AddDays(%%i).DayOfWeek.value__"') do (
        set day=%%w
    )

    REM ===== RANDOM DISTRIBUTION =====
    set /a r=%random% %% 100

    if !r! LSS 40 (
        set commits=0
    ) else if !r! LSS 60 (
        set commits=1
    ) else if !r! LSS 75 (
        set commits=2
    ) else if !r! LSS 88 (
        set commits=3
    ) else if !r! LSS 96 (
        set commits=5
    ) else (
        set commits=8
    )

    REM Sundays mostly off
    if !day! EQU 0 set commits=0

    REM Extra random break (natural gaps)
    set /a break=%random% %% 5
    if !break! EQU 0 set commits=0

    REM ===== CREATE COMMITS =====
    for /l %%j in (1,1,!commits!) do (
        echo %%i %%j >> file.txt
        git add .
        git commit --date="!currentDate!" -m "realistic %%i %%j"
    )
)

echo DONE
pause