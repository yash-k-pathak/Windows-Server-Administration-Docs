
-- Grant  schema permissions
USE AdventureWorks;
GRANT SELECT ON SCHEMA::HumanResources TO hr_reader;
GRANT INSERT,UPDATE, EXECUTE ON SCHEMA::HumanResources TO hr_writer;


-- Grant individual object permissions
GRANT EXECUTE ON dbo.uspGetEmployeeManagers TO hr_reader;
GRANT INSERT ON Sales.SalesOrderHeader TO web_customer;
GRANT INSERT ON Sales.SalesOrderDetail TO web_customer;
GRANT SELECT ON Production.vProductAndDescription TO web_customer;


--Override inherited permissions
GRANT INSERT, UPDATE ON SCHEMA::Sales TO AnthonyFrizzell;
GRANT UPDATE ON HumanResources.EmployeePayHistory TO Payroll_Application
GRANT UPDATE ON HumanResources.Employee(SalariedFlag) TO Payroll_Application;
DENY SELECT ON HumanResources.EmployeePayHistory TO AnthonyFrizzell;

