@echo off
cd /d "%~dp0"

powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0instalar.ps1"

exit
