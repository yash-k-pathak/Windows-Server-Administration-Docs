USE master;
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

-- Create SQL Server login
CREATE LOGIN Web_Application
WITH PASSWORD = 'Pa$$w0rd',
CHECK_POLICY = ON, CHECK_EXPIRATION = OFF,
DEFAULT_DATABASE = AdventureWorks;
GO