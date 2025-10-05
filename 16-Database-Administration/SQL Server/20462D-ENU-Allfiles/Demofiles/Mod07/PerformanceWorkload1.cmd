@ECHO OFF
ECHO Running database workload
SQLCMD -E -d AdventureWorks -q "DBCC FREEPROCCACHE; WHILE 1 = 1 SELECT s.Name, p.Name, p.ListPrice FROM Production.Product p WITH (TABLOCKX) JOIN Production.ProductSubcategory s ON p.ProductSubcategoryID = s.ProductSubcategoryID WHERE (p.ProductID %% 10) =  ROUND(RAND()*9, 0);" > NUL