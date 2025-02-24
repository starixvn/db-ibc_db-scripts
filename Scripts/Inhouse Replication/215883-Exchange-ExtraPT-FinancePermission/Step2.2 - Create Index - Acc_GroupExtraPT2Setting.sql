/*<info serverAlias="DBCUST-CustDB,DBSIC-CustDB,DBSID-CustDB,DBTXN-CustDB,DBAGE-bodb02,DBBOF-bodb02,DBACC-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: STEP2 -- CREATE INDEX
	DB: DBCUST-CustDB,DBSIC-CustDB,DBSID-CustDB,DBTXN-CustDB,DBAGE-bodb02,DBBOF-bodb02,DBACC-bodb02
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Description:
		- Acc_GroupExtraPT2Setting: DBCUST,DBGRP01L,DBTRANS,DBGRP02L,DBGRP03L,DB052,DB053,DB054,DB055,DB061,DB062
*/

-- ===========================
-- Acc_GroupExtraPT2Setting
-- ===========================

CREATE UNIQUE CLUSTERED INDEX IX_Acc_GroupExtraPT2Setting ON [dbo].Acc_GroupExtraPT2Setting (SuperId, GroupId, ProductId, Sporttype, SubProduct, FromDate)
GO
