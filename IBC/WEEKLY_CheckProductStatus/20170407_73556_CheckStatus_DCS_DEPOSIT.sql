/*
Created: 20170328@Helen
Task: Monthly check Status setting for credit/deposit customers - [Redmine:73556]
DB: DBCHECK.CheckResultDB
Revisions:
For products using table custinfo to manage status	
*/

USE CheckResultDB
GO
EXEC DBA_CheckStatus_Deposit_DCS

GO
