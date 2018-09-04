/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration - [Redmine:99462]
	SERVER: DBCUST/NAP_UserControl
	
	
	AccCustomer_1 : 505
	Acc_Menu: 437
	Acc_MemberPolicy_1: 143404
	Acc_GroupPolicy_1: 8322
	Acc_GroupInfo_1: 37
	Acc_FunctionInfo: 266

*/

/*
Mapping
AccCustomer_1 
Acc_Menu
Acc_MemberPolicy_1
Acc_GroupPolicy_1
Acc_GroupInfo_1
Acc_FunctionInfo

*/

USE NAP_UserControl
GO

TRUNCATE TABLE AccCustomer
GO
TRUNCATE TABLE Acc_Menu
GO
TRUNCATE TABLE Acc_MemberPolicy
GO
TRUNCATE TABLE Acc_GroupPolicy
GO
TRUNCATE TABLE Acc_GroupInfo
GO
TRUNCATE TABLE Acc_FunctionInfo
GO

INSERT INTO AccCustomer (custid, PageAccess, createdate, creator, GroupID)
SELECT custid, PageAccess, createdate, creator, GroupID FROM DBPOLICY.BODB02.dbo.AccCustomer_1 WITH (NOLOCK)
GO

SET IDENTITY_INSERT Acc_Menu ON
INSERT INTO Acc_Menu (MenuId, Menu, ParentId, FuncName, Url, [Target], IsHide, [ORDER], [System])
SELECT MenuId, Menu, ParentId, FuncName, Url, [Target], IsHide, [ORDER], [System] FROM DBPOLICY.BODB02.dbo.Acc_Menu WITH (NOLOCK)
SET IDENTITY_INSERT Acc_Menu OFF

GO

INSERT INTO Acc_MemberPolicy (CustID, FuncID, Policy, CreateDate, ModifyDate, Creator)
SELECT CustID, FuncID, Policy, CreateDate, ModifyDate, Creator FROM DBPOLICY.BODB02.dbo.Acc_MemberPolicy_1 WITH (NOLOCK)

GO
INSERT INTO Acc_GroupPolicy (GroupID, FuncID, Policy, CreateDate, ModifyDate, Creator)
SELECT GroupID, FuncID, Policy, CreateDate, ModifyDate, Creator FROM DBPOLICY.BODB02.dbo.Acc_GroupPolicy_1 WITH (NOLOCK)

GO
SET IDENTITY_INSERT Acc_GroupInfo ON
INSERT INTO Acc_GroupInfo (GroupID, GroupName, GroupDesc, CreateDate, ModifyDate, DisplayOrder, Creator, [System])
SELECT GroupID, GroupName, GroupDesc, CreateDate, ModifyDate, DisplayOrder, Creator, [System] FROM DBPOLICY.BODB02.dbo.Acc_GroupInfo_1 WITH (NOLOCK)
SET IDENTITY_INSERT Acc_GroupInfo OFF

GO
SET IDENTITY_INSERT Acc_FunctionInfo ON
INSERT INTO Acc_FunctionInfo (FuncID, FuncName, FuncNote, FuncDesc, FuncRender, CreateDate, ModifyDate, DisplayOrder, Creator, ParentID, Filenames, [System])
SELECT FuncID, FuncName, FuncNote, FuncDesc, FuncRender, CreateDate, ModifyDate, DisplayOrder, Creator, ParentID, Filenames, [System] 
FROM DBPOLICY.BODB02.dbo.Acc_FunctionInfo WITH (NOLOCK)
SET IDENTITY_INSERT Acc_FunctionInfo OFF
GO




