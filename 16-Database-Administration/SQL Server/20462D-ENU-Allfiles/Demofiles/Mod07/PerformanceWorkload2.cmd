@ECHO OFF
ECHO Running database workload
SQLCMD -E -d AdventureWorks -q "WHILE 1 = 1 BEGIN BEGIN TRAN; UPDATE Production.Product SET ListPrice = ListPrice*1.1 WHERE ProductID %% 10 =  ROUND(RAND()*9, 0); ROLLBACK TRAN; END;" > NUL