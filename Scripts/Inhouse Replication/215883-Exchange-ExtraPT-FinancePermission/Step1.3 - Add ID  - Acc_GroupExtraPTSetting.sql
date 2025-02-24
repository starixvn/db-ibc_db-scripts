/*<info serverAlias="DBCUST-CustDB,DBAGE-bodb02,DBBOF-bodb02,DBACC-bodb02,DBTP-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: STEP1 -- DROP CONSTRAINT + ADD COLUMN ID
	DB: DBCUST-CustDB,DBAGE-bodb02,DBBOF-bodb02,DBACC-bodb02,DBTP-bodb02
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Description:
		- Acc_GroupExtraPTSetting: 	DBCUST,DB052,DB053,DB054,DB055,DB061,DB062,DBTP10C
*/

-- ===========================
-- Acc_GroupExtraPTSetting
-- ===========================

ALTER TABLE Acc_GroupExtraPTSetting
DROP CONSTRAINT PK_Acc_GroupExtraPTSetting

ALTER TABLE Acc_GroupExtraPTSetting
ADD ID INT IDENTITY (1,1) NOT NULL CONSTRAINT PK_Acc_GroupExtraPTSetting_ID PRIMARY KEY NONCLUSTERED (ID) 
