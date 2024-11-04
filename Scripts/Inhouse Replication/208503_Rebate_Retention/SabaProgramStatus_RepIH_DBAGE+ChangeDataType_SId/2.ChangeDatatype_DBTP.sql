/*<info serverAlias="IRS_DBTP-bodb02"></info>*/
/*
	Created: 20240911@Lewis
	DB: IRS_DBTP-bodb02
	Task: Rebate and Retention for Credit players [RedmineID: #208503]
*/
--=====================
-- [SabaProgramStatus]
--=====================
 
 -- DROP CONSTRAINT - (DBTP)
 ALTER TABLE [dbo].[SabaProgramStatus]
DROP CONSTRAINT [PK_SabaProgramStatus_SId_SiteDBGroupId];
GO
 -- ALTER DATATYPE - (DBTP)
 ALTER TABLE [dbo].[SabaProgramStatus]
ALTER COLUMN [SId] INT NOT NULL;
GO
 -- ADD CONSTRAINT - (DBTP)
ALTER TABLE [dbo].[SabaProgramStatus]
ADD CONSTRAINT [PK_SabaProgramStatus_SId_SiteDBGroupId] PRIMARY KEY CLUSTERED ([SId], [SiteDBGroupId])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) 
ON DATA;
GO