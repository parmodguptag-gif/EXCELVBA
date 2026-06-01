@echo off
setlocal enabledelayedexpansion

:menu
cls
echo ===========================================
echo FILE BACKUP UTILITY
echo ===========================================
echo 1. Move Excel Files (.xlsx, .xls, .xlsm)
echo 2. Move PDF Files (.pdf)
echo 3. Move Word Files (.docx, .doc)
echo 4. Move Other Files (All other types)
echo 5. Exit
echo ===========================================
echo.
set /p choice="Enter your choice (1, 2, 3, 4, or 5): "

:: Remove quotes if accidentally typed by user
set "choice=%choice:"=%"

if "%choice%"=="1" (
    set "ext_list=xlsx xls xlsm"
    set "target_dir=Excel_Backup"
    goto process
)
if "%choice%"=="2" (
    set "ext_list=pdf"
    set "target_dir=PDF_Backup"
    goto process
)
if "%choice%"=="3" (
    set "ext_list=docx doc"
    set "target_dir=Word_Backup"
    goto process
)
if "%choice%"=="4" (
    set "target_dir=Other_Backup"
    goto process_other
)
if "%choice%"=="5" (
    goto exit_script
)

echo.
echo Invalid choice! Please enter 1, 2, 3, 4, or 5.
pause
goto menu

:process
set "found_files=0"
:: Verify if actual files exist (ignoring directories)
for %%e in (%ext_list%) do (
    for %%f in (*."%%e") do (
        if exist "%%f" (
            :: Check if it is a file and not a directory
            dir /a-d "%%f" >nul 2>&1
            if !errorlevel!==0 set "found_files=1"
        )
    )
)

if "%found_files%"=="0" (
    echo.
    echo [ERROR] No matching files found for your selection in this folder.
    pause
    goto menu
)

if not exist "%target_dir%" mkdir "%target_dir%"

echo.
for %%e in (%ext_list%) do (
    for %%f in (*."%%e") do (
        if exist "%%f" (
            dir /a-d "%%f" >nul 2>&1
            if !errorlevel!==0 (
                echo Moving file: "%%f"
                move "%%f" "%target_dir%\" >nul
            )
        )
    )
)
goto end_success

:process_other
set "found_other=0"
for %%f in (*) do (
    if exist "%%~f" (
        dir /a-d "%%f" >nul 2>&1
        if !errorlevel!==0 (
            if /i not "%%~f"=="%~nx0" (
                set "is_doc=0"
                for %%x in (.xlsx .xls .xlsm .pdf .docx .doc) do (
                    if /i "%%~xf"=="%%x" set "is_doc=1"
                )
                if "!is_doc!"=="0" set "found_other=1"
            )
        )
    )
)

if "%found_other%"=="0" (
    echo.
    echo [ERROR] No other file types found to move.
    pause
    goto menu
)

if not exist "%target_dir%" mkdir "%target_dir%"

echo.
for %%f in (*) do (
    if exist "%%~f" (
        dir /a-d "%%f" >nul 2>&1
        if !errorlevel!==0 (
            if /i not "%%~f"=="%~nx0" (
                set "is_doc=0"
                for %%x in (.xlsx .xls .xlsm .pdf .docx .doc) do (
                    if /i "%%~xf"=="%%x" set "is_doc=1"
                )
                if "!is_doc!"=="0" (
                    echo Moving file: "%%f"
                    move "%%f" "%target_dir%\" >nul
                )
            )
        )
    )
)
goto end_success

:end_success
echo.
echo [SUCCESS] Operation completed successfully.
pause
goto menu

:exit_script
exit
