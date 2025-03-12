/*<info serverAlias="IRS_DBWH-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: truncate table
	DB: IRS_DBWH-bodb02
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Description:
		- Acc_GroupExtraPT2Setting: IRS_DBWH-bodb02
*/
-- ===========================
-- Acc_GroupExtraPT2Setting
-- ===========================

TRUNCATE TABLE Acc_GroupExtraPT2Setting

-- ===========================
-- Drop constraint PK --> Add new column ID identity(1,1) PK nonclustered (all server + all db)	
-- ===========================
ALTER TABLE Acc_GroupExtraPT2Setting
DROP COLUMN ID

ALTER TABLE Acc_GroupExtraPT2Setting
DROP CONSTRAINT PK_Acc_GroupExtraPT2Setting

ALTER TABLE Acc_GroupExtraPT2Setting
ADD ID INT IDENTITY (1,1) NOT FOR REPLICATION NOT NULL CONSTRAINT PK_Acc_GroupExtraPT2Setting_ID PRIMARY KEY NONCLUSTERED (ID)

-- ===========================
-- Create index (Clustered , Unique)
-- ===========================

CREATE UNIQUE CLUSTERED INDEX IX_Acc_GroupExtraPT2Setting ON [dbo].Acc_GroupExtraPT2Setting (SuperId, GroupId, ProductId, Sporttype, SubProduct, FromDate)
GO


-- ===========================
-- Acc_GroupExtraPTSetting
-- ===========================

TRUNCATE TABLE Acc_GroupExtraPTSetting

-- ===========================
-- Drop constraint PK --> Add new column ID identity(1,1) PK nonclustered (all server + all db)	
-- ===========================
ALTER TABLE Acc_GroupExtraPTSetting
DROP COLUMN ID

ALTER TABLE Acc_GroupExtraPTSetting
DROP CONSTRAINT PK_Acc_GroupExtraPTSetting

ALTER TABLE Acc_GroupExtraPTSetting
ADD ID INT IDENTITY (1,1) NOT FOR REPLICATION NOT NULL CONSTRAINT PK_Acc_GroupExtraPTSetting_ID PRIMARY KEY NONCLUSTERED (ID) 

-- ===========================
-- Create index (Clustered , Unique)
-- ===========================

CREATE UNIQUE CLUSTERED INDEX IX_Acc_GroupExtraPTSetting ON [dbo].Acc_GroupExtraPTSetting (SuperId, ProductId, Sporttype, SubProduct, ToDate, GroupId)
GO
