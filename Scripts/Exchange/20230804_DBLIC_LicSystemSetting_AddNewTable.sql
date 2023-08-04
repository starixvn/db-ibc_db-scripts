/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
USE [bodb_3rdProduct]
GO

/*
	Created: 20230408@Evan
	DB: DBLIC.bodb_3rdProduct
	Task: New table for 3rd Products (run on SIT env)
*/

CREATE TABLE [dbo].[LicSystemSetting]
(
	ID			SMALLINT NOT NULL IDENTITY(1,1)
	,ProductId	SMALLINT NULL
	,SName		VARCHAR(100) NULL
	,SValue		VARCHAR(300) NULL
	,CONSTRAINT [PK_LicSystemSetting] PRIMARY KEY CLUSTERED
	(
		ID ASC
	) ON [3rdProduct_Data]
) ON [3rdProduct_Data]
GO

INSERT INTO dbo.LicSystemSetting (ProductId, SName, SValue)
SELECT 31, 'IsImported', '0' UNION ALL
SELECT 31, 'FromImportedDate', '2023-07-01' UNION ALL
SELECT 31, 'ToImportedDate', '2023-07-31'
GO