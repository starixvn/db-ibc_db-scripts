/*
	Created: 20190530@Helen
	Task: User-Defined Aggregate SQL Function for Parlay Calculation - [Redmine:114391]
	DB: DB054/bodb02
*/
USE bodb02
GO
CREATE ASSEMBLY PRODUCT FROM 'C:\PRODUCT.dll';  
GO  
CREATE AGGREGATE PRODUCT (@input DECIMAL(38,20)) RETURNS DECIMAL(38,20)
EXTERNAL NAME PRODUCT.Product; 
GO
 sp_configure 'clr enabled', 1;  
GO  
RECONFIGURE WITH OVERRIDE;  
GO  