
-- Create database master key
USE master;
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd';
GO

-- Create certificate from backup
CREATE CERTIFICATE TDE_Server_Cert
FROM FILE = 'D:\Labfiles\Lab10\Starter\TDE_Server_Cert.cer'
WITH PRIVATE KEY (
	DECRYPTION BY PASSWORD = 'CertPa$$w0rd',
	FILE = 'D:\Labfiles\Lab10\Starter\TDE_Server_Cert.key');
GO

-- Attach database
CREATE DATABASE HumanResources ON 
( FILENAME = N'M:\Data\HumanResources.mdf' ),
( FILENAME = N'L:\Logs\HumanResources.ldf' )
 FOR ATTACH
GO

-- Test database
SELECT * FROM HumanResources.Employees.Employee;