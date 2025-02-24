/*<info serverAlias="DBCUST-CustDB,DBACC-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: STEP2 -- CREATE INDEX
	DB: DBCUST-CustDB,DBACC-bodb02
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Description:
		- Acc_FinancePermission: DBCUST,DB061,DB062
		- Acc_GroupExtraPT_Product: DBCUST,DB061,DB062
		- Acc_GroupExtraPT2_Product: DBCUST,DB061,DB062
*/

-- ===========================
-- Acc_FinancePermission
-- ===========================

CREATE UNIQUE CLUSTERED INDEX CIX_Acc_FinancePermission ON [dbo].[Acc_FinancePermission] (GroupId, FinanceCode)
GO

-- ===========================
-- Acc_GroupExtraPT_Product
-- ===========================

CREATE UNIQUE CLUSTERED INDEX CIX_Acc_GroupExtraPT_Product ON [dbo].Acc_GroupExtraPT_Product (GroupId, ProductID, Sporttype, SubProduct, FromDate)
GO

-- ===========================
-- Acc_GroupExtraPT2_Product
-- ===========================

CREATE UNIQUE CLUSTERED INDEX CIX_Acc_GroupExtraPT2_Product ON [dbo].Acc_GroupExtraPT2_Product (GroupId, ProductID, Sporttype, SubProduct, FromDate)
GO