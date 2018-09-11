/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration - [Redmine:99462]
	SERVER: DB05/bodb02
	
	
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

USE bodb02
GO
TRUNCATE TABLE AccCustomer_1
GO
TRUNCATE TABLE Acc_Menu
GO
TRUNCATE TABLE Acc_MemberPolicy_1
GO
TRUNCATE TABLE Acc_GroupPolicy_1
GO
TRUNCATE TABLE Acc_GroupInfo_1
GO
TRUNCATE TABLE Acc_FunctionInfo
GO
TRUNCATE TABLE Acc_ExchangeRate
GO
TRUNCATE TABLE Acc_ExchangeRate_History
GO
TRUNCATE TABLE Acc_ExchangeRate_InvalidTransfer

GO

INSERT INTO AccCustomer_1 (custid, PageAccess, createdate, creator, GroupID)
SELECT custid, PageAccess, createdate, creator, GroupID 
FROM DBCUST.NAP_UserControl.dbo.AccCustomer WITH (NOLOCK)
GO

SET IDENTITY_INSERT Acc_Menu ON
INSERT INTO Acc_Menu (MenuId, Menu, ParentId, FuncName, Url, [Target], IsHide, [ORDER], [System])
SELECT MenuId, Menu, ParentId, FuncName, Url, [Target], IsHide, [ORDER], [System] 
FROM DBCUST.NAP_UserControl.dbo.Acc_Menu WITH (NOLOCK)
SET IDENTITY_INSERT Acc_Menu OFF

GO

INSERT INTO Acc_MemberPolicy_1 (CustID, FuncID, Policy, CreateDate, ModifyDate, Creator)
SELECT CustID, FuncID, Policy, CreateDate, ModifyDate, Creator 
FROM DBCUST.NAP_UserControl.dbo.Acc_MemberPolicy WITH (NOLOCK)

GO
INSERT INTO Acc_GroupPolicy_1 (GroupID, FuncID, Policy, CreateDate, ModifyDate, Creator)
SELECT GroupID, FuncID, Policy, CreateDate, ModifyDate, Creator 
FROM DBCUST.NAP_UserControl.dbo.Acc_GroupPolicy WITH (NOLOCK)

GO
SET IDENTITY_INSERT Acc_GroupInfo_1 ON
INSERT INTO Acc_GroupInfo_1 (GroupID, GroupName, GroupDesc, CreateDate, ModifyDate, DisplayOrder, Creator, [System])
SELECT GroupID, GroupName, GroupDesc, CreateDate, ModifyDate, DisplayOrder, Creator, [System] 
FROM DBCUST.NAP_UserControl.dbo.Acc_GroupInfo WITH (NOLOCK)
SET IDENTITY_INSERT Acc_GroupInfo_1 OFF

GO
SET IDENTITY_INSERT Acc_FunctionInfo ON
INSERT INTO Acc_FunctionInfo (FuncID, FuncName, FuncNote, FuncDesc, FuncRender, CreateDate, ModifyDate, DisplayOrder, Creator, ParentID, Filenames, [System])
SELECT FuncID, FuncName, FuncNote, FuncDesc, FuncRender, CreateDate, ModifyDate, DisplayOrder, Creator, ParentID, Filenames, [System] 
FROM DBCUST.NAP_UserControl.dbo.Acc_FunctionInfo WITH (NOLOCK)
SET IDENTITY_INSERT Acc_FunctionInfo OFF
GO

INSERT INTO Acc_ExchangeRate (FromExchangeID, ToExchangeID, MinActualRate, MaxActualRate, Creator, LastUpdate)
SELECT FromExchangeID, ToExchangeID, MinActualRate, MaxActualRate, Creator, LastUpdate 
FROM DBCUST.NAP_UserControl.dbo.Acc_ExchangeRate WITH (NOLOCK)

GO
SET IDENTITY_INSERT Acc_ExchangeRate_History ON

INSERT INTO Acc_ExchangeRate_History (RowID, ActionDate, ActionType, UserID, FromExchangeID, ToExchangeID, MinActualRate, MaxActualRate)
SELECT RowID, ActionDate, ActionType, UserID, FromExchangeID, ToExchangeID, MinActualRate, MaxActualRate
FROM DBCUST.NAP_UserControl.dbo.Acc_ExchangeRate_History WITH (NOLOCK)

SET IDENTITY_INSERT Acc_ExchangeRate_History OFF
GO

SET IDENTITY_INSERT Acc_ExchangeRate_InvalidTransfer ON

INSERT INTO Acc_ExchangeRate_InvalidTransfer (ID, TransDate, UserID, FromCust, ToCust, FromExchangeID, ToExchangeID, Rate, MinExRate, MaxExRate, ExRate, Amount, RefNo, IsDeleted)
SELECT ID, TransDate, UserID, FromCust, ToCust, FromExchangeID, ToExchangeID, Rate, MinExRate, MaxExRate, ExRate, Amount, RefNo, IsDeleted
FROM DBCUST.NAP_UserControl.dbo.Acc_ExchangeRate_InvalidTransfer WITH (NOLOCK)

SET IDENTITY_INSERT Acc_ExchangeRate_InvalidTransfer OFF



