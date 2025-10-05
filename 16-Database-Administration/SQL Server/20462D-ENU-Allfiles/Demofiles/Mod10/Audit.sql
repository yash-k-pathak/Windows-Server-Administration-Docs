

-- Create an audit
USE master;

CREATE SERVER AUDIT AW_Audit
TO FILE 
(	FILEPATH = 'D:\Demofiles\Mod10\Audits\'
	,MAXSIZE = 0 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
)
WITH
(	QUEUE_DELAY = 1000
	,ON_FAILURE = FAIL_OPERATION
)
GO

ALTER SERVER AUDIT AW_Audit
WITH (STATE = ON);
GO

--Create a server audit specification
CREATE SERVER AUDIT SPECIFICATION AW_ServerAuditSpec
FOR SERVER AUDIT AW_Audit
ADD (FAILED_LOGIN_GROUP),
ADD (SUCCESSFUL_LOGIN_GROUP)
WITH (STATE = ON);
GO

-- Create a database audit specification
USE AdventureWorks;
CREATE DATABASE AUDIT SPECIFICATION AW_DatabaseAuditSpec
FOR SERVER AUDIT AW_Audit
ADD (SELECT ON SCHEMA::HumanResources BY hr_reader),
ADD (INSERT ON SCHEMA::HumanResources BY hr_writer),
ADD (UPDATE ON SCHEMA::HumanResources BY pay_admin)
WITH (STATE = ON);
GO

-- View audited events
SELECT event_time, action_id, succeeded, statement, user_defined_information, server_principal_name, database_name, schema_name, object_name
FROM sys.fn_get_audit_file ('D:\Demofiles\Mod10\Audits\*',default,default)
WHERE server_principal_name NOT IN ('ADVENTUREWORKS\Student', 'ADVENTUREWORKS\ServiceAcct');

