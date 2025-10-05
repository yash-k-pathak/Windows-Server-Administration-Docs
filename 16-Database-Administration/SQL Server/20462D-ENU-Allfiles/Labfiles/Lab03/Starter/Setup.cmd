@Echo Off
ECHO Preparing the lab environment...

REM - Get current directory
SET SUBDIR=%~dp0

REM - Run SQL Script to reset SQL Server configuration
ECHO Configuring SQL Server...
SQLCMD -E -i %SUBDIR%SetupFiles\Reset.sql > NUL

REM - Restart SQL Server Service
NET STOP SQLSERVERAGENT
NET STOP MSSQLSERVER
NET STOP SQLAGENT$SQL2
NET STOP MSSQL$SQL2
NET START MSSQLSERVER
NET START MSSQL$SQL2
NET START SQLSERVERAGENT
NET START SQLAGENT$SQL2

REM - Run SQL Script to prepare the database environment
ECHO Configuring databases...
SQLCMD -S MIA-SQL\SQL2 -E -i %SUBDIR%SetupFiles\Setup2.sql > NUL
SQLCMD -E -i %SUBDIR%SetupFiles\Setup.sql > NUL

REM Create folders for database files
ECHO Creating folders for database files
MD L:\Logs > NUL
MD M:\Data > NUL
MD N:\Data > NUL
DEL T:\tempdb.* /Q > NUL
DEL T:\templog.* /Q > NUL
XCOPY %SUBDIR%SetupFiles\AWData*.* %SUBDIR% /Q /Y




