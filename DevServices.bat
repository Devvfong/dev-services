@echo off
setlocal
cd /d "%~dp0"
title DevServices Launcher

:: Set console to UTF-8 for box-drawing characters
chcp 65001 >nul 2>&1

:: Check for admin rights and run with execution policy bypass
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0DevServices.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo DevServices terminated or encountered an error.
    pause
)
