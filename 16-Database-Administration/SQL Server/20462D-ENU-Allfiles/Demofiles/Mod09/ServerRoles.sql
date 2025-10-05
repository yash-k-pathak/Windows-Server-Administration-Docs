USE master;
GO

-- Create a user-defined server role
CREATE SERVER ROLE AW_securitymanager;
GO

-- Add a login to the role
ALTER SERVER ROLE AW_securitymanager
ADD MEMBER [ADVENTUREWORKS\AnthonyFrizzell];
GO
