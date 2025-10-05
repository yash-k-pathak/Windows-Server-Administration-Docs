@Echo Off
ECHO Preparing the lab environment...

REM - Get current directory
SET SUBDIR=%~dp0

REM - Restart SQL Server Service to force closure of any open connections
NET STOP SQLSERVERAGENT
NET STOP MSSQLSERVER
NET START MSSQLSERVER
NET START SQLSERVERAGENT


REM - Run SQL Script to prepare the database environment
ECHO Preparing Databases...
SQLCMD -E -i %SUBDIR%SetupFiles\Setup.sql > NUL

DEL %SUBDIR%*.sql /Q
DEL %SUBDIR%*.trc /Q
DEL %SUBDIR%*.xdl /Q

COPY %SUBDIR%SetupFiles\Query.sql %SUBDIR%Query.sql /Y
COPY %SUBDIR%SetupFiles\StopTrace.sql %SUBDIR%StopTrace.sql /Y 
COPY %SUBDIR%SetupFiles\AWCounters.blg %SUBDIR%AWCounters.blg /Y
COPY %SUBDIR%SetupFiles\AWTrace.trc %SUBDIR%AWTrace.trc /Y
COPY %SUBDIR%SetupFiles\Deadlock.cmd %SUBDIR%Deadlock.cmd /Y







