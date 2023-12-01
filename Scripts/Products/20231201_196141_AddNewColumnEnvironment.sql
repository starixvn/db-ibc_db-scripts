/*<info serverAlias="DBPRO-bodb02"></info>*/
/*
	Created: 20231201@Lewis
	Task: Add new column Environment for dbo.Product [#RedmineId: 196141]
	DB: DBPRO-bodb02

	Description:
		Environment: 0 - PRO
					 1 - UAT
*/
USE bodb02
GO

ALTER TABLE [dbo].[Products]
ADD Environment TINYINT CONSTRAINT DF_Products_Environment DEFAULT (1) NOT NULL
GO

UPDATE p WITH (ROWLOCK, UPDLOCK) 
SET p.Environment = 0
FROM [dbo].[Products] p 
WHERE ProductID NOT IN (79,80)
GO
