/*<info serverAlias="DBCUST-CustDB,DBACC-bodb02,DBTP-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: STEP1 -- DROP CONSTRAINT + ADD COLUMN ID
	DB: DBCUST-CustDB,DBACC-bodb02,DBTP-bodb02
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Description:
		- Acc_FinancePermission: DBCUST,DB061,DB062,DBTP10C
		- Acc_GroupExtraPT_Product: DBCUST,DB061,DB062,DBTP10C
		- Acc_GroupExtraPT2_Product: DBCUST,DB061,DB062,DBTP10C
*/

-- ===========================
-- Acc_FinancePermission
-- ===========================

ALTER TABLE Acc_FinancePermission
DROP COLUMN ID

ALTER TABLE Acc_FinancePermission
DROP CONSTRAINT PK_Acc_FinancePermission

ALTER TABLE Acc_FinancePermission
ADD ID INT IDENTITY (1,1) NOT FOR REPLICATION NOT NULL CONSTRAINT PK_Acc_FinancePermission_ID PRIMARY KEY NONCLUSTERED (ID) 

-- ===========================
-- Acc_GroupExtraPT_Product
-- ===========================

ALTER TABLE Acc_GroupExtraPT_Product
DROP COLUMN ID

ALTER TABLE Acc_GroupExtraPT_Product
DROP CONSTRAINT PK_Acc_GroupExtraPT_Product

ALTER TABLE Acc_GroupExtraPT_Product
ADD ID INT IDENTITY (1,1) NOT FOR REPLICATION NOT NULL CONSTRAINT PK_Acc_GroupExtraPT_Product_ID PRIMARY KEY NONCLUSTERED (ID) 

-- ===========================
-- Acc_GroupExtraPT2_Product
-- ===========================

ALTER TABLE Acc_GroupExtraPT2_Product
DROP COLUMN ID

ALTER TABLE Acc_GroupExtraPT2_Product
DROP CONSTRAINT PK_Acc_GroupExtraPT2_Product

ALTER TABLE Acc_GroupExtraPT2_Product
ADD ID INT IDENTITY (1,1) NOT FOR REPLICATION NOT NULL CONSTRAINT PK_Acc_GroupExtraPT2_Product_ID PRIMARY KEY NONCLUSTERED (ID) 