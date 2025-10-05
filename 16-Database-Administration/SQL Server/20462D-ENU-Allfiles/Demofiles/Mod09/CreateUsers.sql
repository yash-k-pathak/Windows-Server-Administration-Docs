USE AdventureWorks;
GO

-- Create users
CREATE USER Payroll_Application
FOR LOGIN Payroll_Application
WITH DEFAULT_SCHEMA = HumanResources;

CREATE USER HumanResources_Users
FOR LOGIN [ADVENTUREWORKS\HumanResources_Users]
WITH DEFAULT_SCHEMA = HumanResources;

CREATE USER AnthonyFrizzell
FOR LOGIN [ADVENTUREWORKS\AnthonyFrizzell];

