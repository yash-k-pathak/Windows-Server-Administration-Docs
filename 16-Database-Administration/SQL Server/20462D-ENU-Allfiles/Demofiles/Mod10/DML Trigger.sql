-- Create a log table
USE AdventureWorks;
GO
CREATE TABLE HumanResources.AuditRateChanges
(LogEntryID INTEGER IDENTITY PRIMARY KEY,
 EventTime DATETIME DEFAULT GETDATE(),
 UserName SYSNAME DEFAULT SUSER_NAME(),
 EmployeeID INT,
 OldRate MONEY,
 NewRate MONEY);
 GO

-- Create a Trigger
CREATE TRIGGER HumanResources.EmployeePayHistory_Update
ON HumanResources.EmployeePayHistory
FOR UPDATE
AS
BEGIN
	IF UPDATE(Rate)
	BEGIN
		INSERT INTO HumanResources.AuditRateChanges (EmployeeID, OldRate, NewRate)
		SELECT i.BusinessEntityID, d.Rate,i.Rate
		FROM inserted i
		JOIN deleted d ON i.BusinessEntityID = d.BusinessEntityID;
	END;
END;
GO

--Update a Rate
UPDATE HumanResources.EmployeePayHistory
SET Rate = Rate * 1.1
WHERE BusinessEntityID = 1
AND RateChangeDate = (SELECT MAX(RateChangeDate) FROM HumanResources.EmployeePayHistory
						WHERE BusinessEntityID = 1);
GO

-- View the audit log
SELECT * FROM HumanResources.AuditRateChanges;



