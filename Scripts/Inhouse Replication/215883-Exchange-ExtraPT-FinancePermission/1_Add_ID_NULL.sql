/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: STEP1 -- ADD COLUMN ID
	DB: DBCUST-CustDB,DBACC-bodb02,DBTP-bodb02
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Description:
*/

-- ===========================
-- Acc_FinancePermission
-- ===========================

ALTER TABLE Acc_FinancePermission
ADD ID INT NULL

-- ===========================
-- Acc_GroupExtraPT_Product
-- ===========================

ALTER TABLE Acc_GroupExtraPT_Product
ADD ID INT NULL

-- ===========================
-- Acc_GroupExtraPT2_Product
-- ===========================

ALTER TABLE Acc_GroupExtraPT2_Product
ADD ID INT NULL

-- ===========================
-- Acc_GroupExtraPTSetting
-- ===========================

ALTER TABLE Acc_GroupExtraPTSetting
ADD ID INT NULL

-- ===========================
-- Acc_GroupExtraPT2Setting
-- ===========================

ALTER TABLE Acc_GroupExtraPT2Setting
ADD ID INT NULL


 
 