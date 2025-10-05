-- Perform a full database backup
USE LogTest;
BACKUP DATABASE LogTest
  TO DISK = 'D:\Demofiles\Mod04\LogTest_Full.bak'
WITH INIT;
GO
	
-- View database file space
SELECT name AS Name, type,
       size * 8 /1024. as SizeinMB,  
       FILEPROPERTY(name,'SpaceUsed') * 8 /1024. as SpaceUsedInMB,
       CAST(FILEPROPERTY(name,'SpaceUsed') as decimal(10,4))
         / CAST(size as decimal(10,4)) * 100 as PercentSpaceUsed	
FROM sys.database_files;
GO

--  Insert  data
SET NOCOUNT ON;
INSERT INTO DemoTable (FirstLargeColumn,BigIntColumn)
  VALUES('This is some testdata',12345);
GO 5000

-- View log file space
SELECT name AS Name,
       size * 8 /1024. as SizeinMB,  
       FILEPROPERTY(name,'SpaceUsed') * 8 /1024. as SpaceUsedInMB,
       CAST(FILEPROPERTY(name,'SpaceUsed') as decimal(10,4))
         / CAST(size as decimal(10,4)) * 100 as PercentSpaceUsed	
FROM sys.database_files
WHERE type = 1;	
GO	

-- Issue a checkpoint 
CHECKPOINT;
GO

-- View log file space again
SELECT name AS Name,
       size * 8 /1024. as SizeinMB,  
       FILEPROPERTY(name,'SpaceUsed') * 8 /1024. as SpaceUsedInMB,
       CAST(FILEPROPERTY(name,'SpaceUsed') as decimal(10,4))
         / CAST(size as decimal(10,4)) * 100 as PercentSpaceUsed	
FROM sys.database_files
WHERE type = 1;	
GO	

-- Check log status
SELECT name, log_reuse_wait_desc FROM sys.databases
WHERE name = 'LogTest';
GO


-- Perform a log backup
BACKUP LOG LogTest
  TO DISK = 'D:\Demofiles\Mod04\LogTest_tr.bak'
WITH INIT;
GO

-- Verify log file truncation 
SELECT name AS Name,
       size * 8 /1024. as SizeinMB,  
       FILEPROPERTY(name,'SpaceUsed') * 8 /1024. as SpaceUsedInMB,
       CAST(FILEPROPERTY(name,'SpaceUsed') as decimal(10,4))
         / CAST(size as decimal(10,4)) * 100 as PercentSpaceUsed	
FROM sys.database_files
WHERE type = 1;	
GO	
