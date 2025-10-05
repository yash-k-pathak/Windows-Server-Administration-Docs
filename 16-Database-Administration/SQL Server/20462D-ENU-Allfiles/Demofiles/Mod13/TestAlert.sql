USE TestAlertDB;
GO

SET NOCOUNT ON;
WHILE 1 = 1
BEGIN
   INSERT INTO testtable (col1)
   VALUES('Test data!');
END;
GO