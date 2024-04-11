@REM This file is for PATH compatability
@REM feel free to delete this if you're not on windows
@echo off
echo Passed path: "%~f1"
echo Batch path : "%~dp0"
"%~dp0Pipe\SchlorngDE.exe" "%~f1" %~dp0