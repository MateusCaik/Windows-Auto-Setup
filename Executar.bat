@echo off
cd /d "%~dp0"

powershell -ExecutionPolicy Bypass -NoProfile -File "instalar.ps1"

pause
