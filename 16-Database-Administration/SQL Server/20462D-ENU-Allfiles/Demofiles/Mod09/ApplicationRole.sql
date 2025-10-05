-- user security contenxt
SELECT 'Default user context' As Context, user_name() AS [DB Identity], SUSER_NAME() AS [System Identity]


-- Use application role
DECLARE @cookie varbinary(8000);
EXEC sp_setapprole 'pay_admin', 'Pa$$w0rd', @fCreateCookie = true, @cookie = @cookie OUTPUT;

SELECT 'Application role active' As Context, user_name() AS [DB Identity], SUSER_NAME() AS [System Identity]

EXEC sp_unsetapprole @cookie;

-- user security contenxt
SELECT 'Reverted to user context' As Context, user_name() AS [DB Identity], SUSER_NAME() AS [System Identity]