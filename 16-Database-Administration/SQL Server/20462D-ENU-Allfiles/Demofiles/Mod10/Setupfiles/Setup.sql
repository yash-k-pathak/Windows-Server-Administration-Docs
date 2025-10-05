USE master
GO

-- Drop ConfidentialDB
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'ConfidentialDB')
BEGIN
	DROP DATABASE ConfidentialDB
END
GO

WHILE (SELECT COUNT(*) FROM sys.databases WHERE is_encrypted = 1) > 0
BEGIN
	DECLARE @n SYSNAME, @sql NVARCHAR(200);
	SELECT @n = (SELECT MAX(name) FROM sys.databases WHERE is_encrypted = 1);
	SET @sql = 'DROP DATABASE ' + @n;
	EXECUTE sp_executesql  @sql;
END
GO

-- drop encryption keys
WHILE (SELECT COUNT(*) FROM sys.symmetric_keys WHERE name NOT LIKE '#%') > 0
BEGIN
	DECLARE @n SYSNAME, @sql NVARCHAR(200);
	SELECT @n = (SELECT MAX(name) FROM sys.symmetric_keys WHERE name NOT LIKE '#%');
	SET @sql = 'DROP SYMMETRIC KEY ' + @n;
	EXECUTE sp_executesql  @sql;
END
GO

WHILE (SELECT COUNT(*) FROM sys.asymmetric_keys WHERE name NOT LIKE '#%') > 0
BEGIN
	DECLARE @n SYSNAME, @sql NVARCHAR(200);
	SELECT @n = (SELECT MAX(name) FROM sys.asymmetric_keys WHERE name NOT LIKE '#%');
	SET @sql = 'DROP ASYMMETRIC KEY ' + @n;
	EXECUTE sp_executesql  @sql;
END
GO

WHILE (SELECT COUNT(*) FROM sys.certificates WHERE name NOT LIKE '#%') > 0
BEGIN
	DECLARE @n SYSNAME, @sql NVARCHAR(200);
	SELECT @n = (SELECT MAX(name) FROM sys.certificates WHERE name NOT LIKE '#%');
	SET @sql = 'DROP CERTIFICATE ' + @n;
	EXECUTE sp_executesql  @sql;
END
GO

DROP MASTER KEY;

CREATE DATABASE ConfidentialDB;
GO

CREATE TABLE ConfidentialDB.dbo.SecretKeys
(id INTEGER IDENTITY PRIMARY KEY,
 [description] NVARCHAR(200),
 value UNIQUEIDENTIFIER DEFAULT NEWID());
 GO

 INSERT INTO ConfidentialDB.dbo.SecretKeys ([description])
 VALUES ('A secret key');
 GO 200


ALTER SERVER AUDIT SPECIFICATION [AW_ServerAuditSpec]
WITH (STATE = OFF);
GO

DROP SERVER AUDIT SPECIFICATION [AW_ServerAuditSpec];
GO

ALTER SERVER AUDIT [AW_Audit]
WITH (STATE = OFF);
GO

DROP SERVER AUDIT [AW_Audit];
GO

-- Drop and restore AdventureWorks database
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorks')
BEGIN
	DROP DATABASE AdventureWorks
END
GO

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'Payroll_Application')
BEGIN
DROP LOGIN [Payroll_Application]
END
GO

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'Web_Application')
BEGIN
DROP LOGIN [Web_Application]
END
GO

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'ADVENTUREWORKS\AnthonyFrizzell')
BEGIN
DROP LOGIN [ADVENTUREWORKS\AnthonyFrizzell]
END
GO

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'ADVENTUREWORKS\Database_Managers')
BEGIN
DROP LOGIN [ADVENTUREWORKS\Database_Managers]
END
GO

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'ADVENTUREWORKS\HumanResources_Users')
BEGIN
DROP LOGIN [ADVENTUREWORKS\HumanResources_Users]
END
GO

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'AW_securitymanager')
BEGIN
DROP SERVER ROLE [AW_securitymanager]
END
GO


RESTORE DATABASE [AdventureWorks] FROM  DISK = N'$(SUBDIR)SetupFiles\AdventureWorks.bak' WITH  REPLACE,
MOVE N'AdventureWorks' TO N'$(SUBDIR)SetupFiles\AdventureWorks.mdf', 
MOVE N'AdventureWorks_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks_log.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks TO [AdventureWorks\Student];
GO

EXEC  msdb.dbo.sp_delete_database_backuphistory @database_name = 'AdventureWorks';
GO

--Create a login for a Windows user
CREATE LOGIN [ADVENTUREWORKS\AnthonyFrizzell]
FROM WINDOWS 
WITH DEFAULT_DATABASE = AdventureWorks;
GO

-- Create login for Windows group
CREATE LOGIN [ADVENTUREWORKS\Database_Managers]
FROM WINDOWS 
WITH DEFAULT_DATABASE = AdventureWorks;
GO

CREATE LOGIN [ADVENTUREWORKS\HumanResources_Users]
FROM WINDOWS 
WITH DEFAULT_DATABASE = AdventureWorks;
GO

-- Create SQL Server login
CREATE LOGIN Payroll_Application
WITH PASSWORD = 'Pa$$w0rd',
CHECK_POLICY = ON, CHECK_EXPIRATION = OFF,
DEFAULT_DATABASE = AdventureWorks;
GO

-- Create SQL Server login
CREATE LOGIN Web_Application
WITH PASSWORD = 'Pa$$w0rd',
CHECK_POLICY = ON, CHECK_EXPIRATION = OFF,
DEFAULT_DATABASE = AdventureWorks;
GO

ALTER SERVER ROLE serveradmin
ADD MEMBER [ADVENTUREWORKS\Database_Managers];
GO

-- Create a user-defined server role
CREATE SERVER ROLE AW_securitymanager;
GO

-- Add a login to the role
ALTER SERVER ROLE AW_securitymanager
ADD MEMBER [ADVENTUREWORKS\AnthonyFrizzell];
GO


-- Grant permission to alter login
GRANT ALTER ANY LOGIN TO AW_securitymanager;

USE AdventureWorks;
GO

-- Create users
CREATE USER Web_Application
FOR LOGIN Web_Application
WITH DEFAULT_SCHEMA = Sales;

CREATE USER Payroll_Application
FOR LOGIN Payroll_Application
WITH DEFAULT_SCHEMA = HumanResources;

CREATE USER HumanResources_Users
FOR LOGIN [ADVENTUREWORKS\HumanResources_Users]
WITH DEFAULT_SCHEMA = HumanResources;

CREATE USER AnthonyFrizzell
FOR LOGIN [ADVENTUREWORKS\AnthonyFrizzell];

ALTER ROLE db_datareader
ADD MEMBER AnthonyFrizzell;

-- Create roles
CREATE ROLE hr_reader;

CREATE ROLE hr_writer;

CREATE ROLE web_customer;

-- Add members
ALTER ROLE hr_reader
ADD MEMBER HumanResources_Users;

ALTER ROLE hr_reader
ADD MEMBER Payroll_Application;

ALTER ROLE hr_writer
ADD MEMBER HumanResources_Users;

ALTER ROLE web_customer
ADD MEMBER Web_Application;

CREATE APPLICATION ROLE pay_admin
WITH PASSWORD = 'Pa$$w0rd';


-- Grant  schema permissions
USE AdventureWorks;
GRANT SELECT ON SCHEMA::HumanResources TO hr_reader;
GRANT INSERT, UPDATE ON SCHEMA::HumanResources TO hr_writer;


-- Grant individual object permissions
GRANT EXECUTE ON dbo.uspGetEmployeeManagers TO hr_reader;
GRANT INSERT ON Sales.SalesOrderHeader TO web_customer;
GRANT INSERT ON Sales.SalesOrderDetail TO web_customer;
GRANT SELECT ON Production.vProductAndDescription TO web_customer;


--Override inherited permissions
GRANT INSERT, UPDATE ON SCHEMA::Sales TO AnthonyFrizzell;
GRANT SELECT, INSERT,UPDATE,DELETE ON HumanResources.EmployeePayHistory TO Payroll_Application
GRANT SELECT, INSERT,UPDATE,DELETE ON HumanResources.EmployeePayHistory TO pay_admin
DENY SELECT ON HumanResources.EmployeePayHistory TO AnthonyFrizzell;

