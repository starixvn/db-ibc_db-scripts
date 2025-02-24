/*<info serverAlias="DBCUST-CustDB,DBAGE-bodb02,DBBOF-bodb02,DBACC-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: STEP1 -- CREATE INDEX
	DB: DBCUST-CustDB,DBAGE-bodb02,DBBOF-bodb02,DBACC-bodb02
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Description:
		- Acc_GroupExtraPTSetting: 	DBCUST,DB052,DB053,DB054,DB055,DB061,DB062
*/

-- ===========================
-- Acc_GroupExtraPTSetting
-- ===========================

CREATE UNIQUE CLUSTERED INDEX IX_Acc_GroupExtraPTSetting ON [dbo].Acc_GroupExtraPTSetting (SuperId, ProductId, Sporttype, SubProduct, ToDate, GroupId)
GO
