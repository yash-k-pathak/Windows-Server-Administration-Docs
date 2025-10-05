--Enable contained databases
sp_configure 'show advanced options', 1 ; 
GO
RECONFIGURE ; 
GO 
sp_configure 'contained database authentication', 1; 
GO
RECONFIGURE ; 
GO 
sp_configure 'show advanced options', 0 ; 
GO
RECONFIGURE ; 
GO

--Create a contained database
CREATE DATABASE [ContainedDB]
CONTAINMENT = PARTIAL;
GO

--Create contained users
USE [ContainedDB]
CREATE USER [SalesApp] WITH PASSWORD = 'Pa$$w0rd'
CREATE USER [ADVENTUREWORKS\RosieReeves]


