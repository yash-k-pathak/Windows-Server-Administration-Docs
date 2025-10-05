@Echo Off
ECHO Preparing the lab environment...

REM - Get current directory
SET SUBDIR=%~dp0
ECHO Deleting files (ignore errors if they don't exist!)...
DEL %SUBDIR%*.bak /Q
DEL %SUBDIR%*.cer /Q
DEL %SUBDIR%*.key /Q

REM - Restart SQL Server Service to force closure of any open connections
NET STOP SQLSERVERAGENT
NET STOP MSSQLSERVER
NET STOP SQLAGENT$SQL2
NET STOP MSSQL$SQL2
NET START MSSQLSERVER
NET START MSSQL$SQL2
NET START SQLAGENT$SQL2

REM - Run SQL Script to prepare the database environment
ECHO Preparing Databases...
SQLCMD -E -i %SUBDIR%SetupFiles\Setup.sql > NUL
SQLCMD -S .\SQL2 -E -i %SUBDIR%SetupFiles\Setup2.sql > NUL

REM Sabotage AdventurWorks
ECHO Sabotaging AdventureWorks database...
NET STOP MSSQLSERVER
DEL %SUBDIR%SetupFiles\AdventureWorks.mdf /Q
NET START MSSQLSERVER
NET START SQLSERVERAGENT





