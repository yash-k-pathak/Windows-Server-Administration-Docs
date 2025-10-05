--View service information
SELECT * FROM sys.dm_server_services


--View registry information
SELECT * FROM sys.dm_server_registry


--  View volume stats
SELECT  d.name database_name,
		f.name logical_filename,
		s.volume_mount_point volume,
		s.total_bytes volume_size,
		s.available_bytes free_space,
		f.size current_file_size
FROM sys.sysdatabases d
JOIN sys.master_files f ON d.dbid = f.database_id
CROSS APPLY sys.dm_os_volume_stats(f.database_id, f.file_id) s


--Empty the cache
DBCC FREEPROCCACHE

--Get query stats
SELECT qt.[text] SQLText, qs.execution_count, qs.creation_time, qs.last_execution_time, qs.last_elapsed_time, qs.max_elapsed_time, qs.total_elapsed_time
FROM sys.dm_exec_query_stats qs 
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY qs.total_elapsed_time DESC


--Execute a query
SELECT c.AccountNumber, SUM(UnitPrice * OrderQty) AS OrderTotal 
FROM AdventureWorks.Sales.SalesOrderDetail AS SOD
JOIN AdventureWorks.Sales.SalesOrderHeader AS SOH ON SOD.SalesOrderID = SOH.SalesOrderID
JOIN AdventureWorks.Sales.Customer AS C ON SOH.CustomerID = C.CustomerID
GROUP BY C.AccountNumber
ORDER BY OrderTotal DESC
GO