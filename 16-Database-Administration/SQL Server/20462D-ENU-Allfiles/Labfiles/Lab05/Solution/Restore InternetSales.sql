USE master;
BACKUP LOG InternetSales TO DISK = 'R:\Backups\IS-TailLog.bak'WITH NO_TRUNCATE;

GO

RESTORE DATABASE [InternetSales] FROM  DISK = N'R:\Backups\InternetSales.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [InternetSales] FROM  DISK = N'R:\Backups\InternetSales.bak' WITH  FILE = 3,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [InternetSales] FROM  DISK = N'R:\Backups\InternetSales.bak' WITH  FILE = 4,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [InternetSales] FROM  DISK = N'R:\Backups\IS-TailLog.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5

GO


