USE [master]
RESTORE DATABASE [HumanResources] FROM  DISK = N'R:\Backups\HumanResources.bak' WITH  FILE = 2,  NOUNLOAD,  STATS = 5

GO


