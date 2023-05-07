@echo off
:: setlocal enabledelayedexpansion

set Host=127.0.0.1
set port=3306
set MYSQL_USER=root
set MYSQL_PASSWORD=password
set BACKUP_PATH=C:\mysql_backup
set MYSQL_BIN_PATH=C:\mysql\bin

set "bb=%MYSQL_BIN_PATH%\mysql"
set "date=%date:~0,4%%date:~5,2%%date:~8,2%"

if not exist "%BACKUP_PATH%/%date%/%Host%" md "%BACKUP_PATH%/%date%/%Host%"
set "aa=%BACKUP_PATH%/%date%/%Host%"

for /f "usebackq" %%d in (`%bb% -u%MYSQL_USER% -p%MYSQL_PASSWORD% -e "show databases;"`) do (
  if not "%%d"=="information_schema" (
    if not "%%d"=="performance_schema" (
      if not "%%d"=="mysql" (
        echo Backing up database %%d...
        "D:\xampp\mysql\bin\mysqldump" --user=%MYSQL_USER% --password=%MYSQL_PASSWORD% --host=%Host% --port=%port% --databases %%d > "%aa%\%%d.sql"
      )
    )
  )
)

powershell Compress-Archive -Path "%aa%/*.sql" -DestinationPath "%BACKUP_PATH%/%Host%.zip"
rmdir /s /q "%BACKUP_PATH%/%date%"

echo:
echo All databases backed up successfully!

REM ping 127.0.0.1 -n 4 > nul
exit
