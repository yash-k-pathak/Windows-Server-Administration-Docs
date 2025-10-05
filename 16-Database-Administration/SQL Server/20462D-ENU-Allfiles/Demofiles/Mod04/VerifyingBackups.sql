-- View backup history
SELECT 
	bs.media_set_id,
	bs.backup_finish_date,
	bs.type,
	bs.backup_size,
	bs.compressed_backup_size,
	mf.physical_device_name
FROM msdb.dbo.backupset AS bs
INNER JOIN msdb.dbo.backupmediafamily AS mf
ON bs.media_set_id = mf.media_set_id	
WHERE database_name = 'AdventureWorks'
ORDER BY backup_finish_date DESC;
GO

--  Use RESTORE HEADERONLY
RESTORE HEADERONLY 
FROM DISK = 'D:\Demofiles\Mod04\AW.bak';
GO

--  Use RESTORE FILELISTONLY
RESTORE FILELISTONLY 
FROM DISK = 'D:\Demofiles\Mod04\AW.bak';
GO

--  Use RESTORE VERIFYONLY
RESTORE VERIFYONLY 
FROM DISK = 'D:\Demofiles\Mod04\AW.bak';
GO