/*<info serverAlias="DBSIC-bodb02"></info>*/
/*
	Created: 20240911@Lewis
	DB: DBSIC-bodb02
	Task: Rebate and Retention for Credit players [RedmineID: #208503]
*/
USE [bodb02]
GO

--=====================
-- [SabaProgramStatus]
--=====================
 
 -- DROP CONSTRAINT - (SIC)
 ALTER TABLE [dbo].[SabaProgramStatus]
DROP CONSTRAINT [PK_SabaProgramStatus_SId_SiteDBGroupId];
GO
 -- ALTER DATATYPE - (SIC)
 ALTER TABLE [dbo].[SabaProgramStatus]
ALTER COLUMN [SId] INT NOT NULL;
GO
 -- ADD CONSTRAINT - (SIC)
ALTER TABLE [dbo].[SabaProgramStatus]
ADD CONSTRAINT [PK_SabaProgramStatus_SId_SiteDBGroupId] PRIMARY KEY CLUSTERED ([SId], [SiteDBGroupId])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) 
ON [Transfer_Index];
GO

--=====================
-- [SabaProgramStatus_Del_InHouse]
--=====================

-- ALTER DATATYPE - (SIC)
 ALTER TABLE [dbo].[SabaProgramStatus_Del_InHouse]
ALTER COLUMN [SId] INT NOT NULL;
GO