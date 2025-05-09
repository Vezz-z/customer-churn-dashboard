@echo off
setlocal enabledelayedexpansion

title Customer Churn Analysis Virtual Environment Creator
cd /d "%~dp0"

echo Checking for Python installation . . .
python --version >nul 2>&1
if !ERRORLEVEL! neq 0 (
    echo ERROR: Python is not installed or not in PATH.
    echo Please install Python from https://www.python.org/downloads/ or add Python to path and try again.
    goto END
)

echo(
echo Python installation found . . .
echo(
echo Creating the virtual environment . . .

if exist "venv" (
    echo(
    echo A virtual environment already exists . . .
    echo(
    echo a - Delete the virtual environment.
    echo b - Install the required packages in the existing virtual environment.
    echo(
    set /p CONF="Choose your option: "
    if /i "!CONF!"=="a" (
        goto DEL_VENV
    ) else if /i "!CONF!"=="b" (
        goto PIP_INSTALL
    ) else if "!CONF!"=="" (
        echo No input received . . .
        goto END
    ) else (
        echo Invalid option selected.
        goto END
    )
    goto END
) else (
    python -m venv venv
    if !ERRORLEVEL! neq 0 (
        echo ERROR: Failed to create the virtual environment.
        goto END
    )
    goto PIP_INSTALL
)

:PIP_INSTALL
echo(
call venv\Scripts\activate
if !ERRORLEVEL! neq 0 (
    echo(
    echo ERROR: Failed to activate virtual environment. Make sure the virtual environment folder exists with prerequisite modules availabe. 
    echo Try deleting the venv and run this file again. 
    goto END
)
echo(
echo Installing the following packages that are required for the application to run: 
for /f "delims=" %%A in (requirements.txt) do echo # %%A 
echo(
set /p INSTALL_CONFIRM="Would you like to proceed? (y/n): "
echo(

if /i "!INSTALL_CONFIRM!"=="y" (
    echo Installing the packages . . .
    venv\Scripts\python.exe -m pip install --upgrade pip >nul 2>&1
    venv\Scripts\pip.exe install -r requirements.txt >nul 2>&1
    if !ERRORLEVEL! neq 0 (
        echo(
        echo ERROR: Failed to install packages.
        echo Please check your internet connection or pip configuration.
        goto DEL_VENV
    )
    echo(
    echo All packages installed successfully.
    goto END
) else (
    echo(
    echo WARNING: Required packages are missing. The application may not run correctly.
    goto DEL_VENV
)

:DEL_VENV
echo(
echo Deleting the virtual environment . . .  
rmdir /s /q venv
echo(
echo Virtual environment deleted.
goto END

:END
echo(
echo Exiting the process . . . 
echo(
pause
exit /b 1
