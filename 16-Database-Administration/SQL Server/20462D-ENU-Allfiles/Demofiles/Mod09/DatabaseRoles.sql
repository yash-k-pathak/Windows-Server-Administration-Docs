USE AdventureWorks;
GO

-- Create roles
CREATE ROLE hr_writer;

CREATE ROLE web_customer;

-- Add members
ALTER ROLE hr_writer
ADD MEMBER HumanResources_Users;

ALTER ROLE web_customer
ADD MEMBER Web_Application;