-- Create a table with a primary key
USE AdventureWorks;
CREATE TABLE dbo.PhoneLog
( PhoneLogID int IDENTITY(1,1) PRIMARY KEY,
  LogRecorded datetime2 NOT NULL,
  PhoneNumberCalled nvarchar(100) NOT NULL,
  CallDurationMs int NOT NULL
);
GO

-- Insert some data into the table
SET NOCOUNT ON;
DECLARE @Counter int = 0;
WHILE @Counter < 10000 BEGIN
  INSERT dbo.PhoneLog (LogRecorded, PhoneNumberCalled, CallDurationMs)
    VALUES(SYSDATETIME(),'999-9999',CAST(RAND() * 1000 AS int));
  SET @Counter += 1;
END;
GO

-- Check fragmentation
SELECT * 
FROM sys.dm_db_index_physical_stats(DB_ID(),
                                    OBJECT_ID('dbo.PhoneLog'),
                                    NULL,
                                    NULL,
                                    'DETAILED');
GO

-- Modify the data in the table 
SET NOCOUNT ON;
DECLARE @Counter int = 0;
WHILE @Counter < 10000 BEGIN
  UPDATE dbo.PhoneLog SET PhoneNumberCalled = REPLICATE('9',CAST(RAND() * 100 AS int))
    WHERE PhoneLogID = @Counter % 10000;
  IF @Counter % 100 = 0 PRINT @Counter;
  SET @Counter += 1;
END;
GO

-- Re-check fragmentation
SELECT * 
FROM sys.dm_db_index_physical_stats(DB_ID(),
                                    OBJECT_ID('dbo.PhoneLog'),
                                    NULL,
                                    NULL,
                                    'DETAILED');
GO

-- Rebuild the table and its indexes
ALTER INDEX ALL ON dbo.PhoneLog REBUILD;
GO

-- Check the fragmentation again
SELECT * 
FROM sys.dm_db_index_physical_stats(DB_ID(),
                                    OBJECT_ID('dbo.PhoneLog'),
                                    NULL,
                                    NULL,
                                    'DETAILED');
GO

