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

/* 9 Tables
Mapping
AccCustomer_1 
Acc_Menu
Acc_MemberPolicy_1
Acc_GroupPolicy_1
Acc_GroupInfo_1
Acc_FunctionInfo

Acc_ExchangeRate
Acc_ExchangeRate_History
Acc_ExchangeRate_InvalidTransfer

*/
USE bodb02
GO
-- Table 1: AccCustomer_1
MERGE dbo.AccCustomer_1 TARGET
USING (
	SELECT   custid, PageAccess, createdate, creator, GroupID 
	FROM	DBCUST.NAP_UserControl.dbo.AccCustomer t1 WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.custid = SOURCE.custid
WHEN	MATCHED THEN
	UPDATE SET 
		PageAccess = SOURCE.PageAccess
		,createdate = SOURCE.createdate
		,creator = SOURCE.creator
		,GroupID = SOURCE.GroupID
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (custid, PageAccess, createdate, creator, GroupID)
	VALUES(SOURCE.custid, SOURCE.PageAccess, SOURCE.createdate, SOURCE.creator, SOURCE.GroupID)	

WHEN NOT MATCHED BY SOURCE THEN DELETE ;

GO	
-- Table 2: Acc_Menu	
SET IDENTITY_INSERT Acc_Menu ON
MERGE dbo.Acc_Menu TARGET
USING (
	SELECT   MenuId, Menu, ParentId, FuncName, Url, [Target], IsHide, [ORDER], [System]
	FROM	DBCUST.NAP_UserControl.dbo.Acc_Menu t1 WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.MenuId = SOURCE.MenuId
WHEN	MATCHED THEN
	UPDATE SET 
		Menu		=  SOURCE.Menu
		,ParentId	=  SOURCE.ParentId
		,FuncName	=  SOURCE.FuncName
		,Url		=  SOURCE.Url
		,[Target]	=  SOURCE.[Target]
		,IsHide		=  SOURCE.IsHide
		,[ORDER]	=  SOURCE.[ORDER]
		,[System]	=  SOURCE.[System]
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (MenuId, Menu, ParentId, FuncName, Url, [Target], IsHide, [ORDER], [System])
	VALUES(SOURCE.MenuId, SOURCE.Menu, SOURCE.ParentId, SOURCE.FuncName, SOURCE.Url, SOURCE.[Target], SOURCE.IsHide, SOURCE.[ORDER], SOURCE.[System])	
WHEN NOT MATCHED BY SOURCE THEN DELETE ;
	
SET IDENTITY_INSERT Acc_Menu OFF

GO

-- Table 3: Acc_MemberPolicy_1
MERGE dbo.Acc_MemberPolicy_1 TARGET
USING (
	SELECT   CustID, FuncID, Policy, CreateDate, ModifyDate, Creator
	FROM	DBCUST.NAP_UserControl.dbo.Acc_MemberPolicy t1 WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.custid = SOURCE.custid AND TARGET.FuncID = SOURCE.FuncID
WHEN	MATCHED THEN
	UPDATE SET 
		Policy			=  SOURCE.Policy
		, CreateDate	=  SOURCE.CreateDate
		, ModifyDate	=  SOURCE.ModifyDate
		, Creator		=  SOURCE.Creator
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (CustID, FuncID, Policy, CreateDate, ModifyDate, Creator)
	VALUES(SOURCE.CustID, SOURCE.FuncID, SOURCE.Policy, SOURCE.CreateDate, SOURCE.ModifyDate, SOURCE.Creator)	
WHEN NOT MATCHED BY SOURCE THEN DELETE ;
GO
-- Table 4: Acc_GroupPolicy_1	
MERGE dbo.Acc_GroupPolicy_1 TARGET
USING (
	SELECT GroupID, FuncID, Policy, CreateDate, ModifyDate, Creator 
	FROM DBCUST.NAP_UserControl.dbo.Acc_GroupPolicy WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.groupID = SOURCE.groupID AND TARGET.FuncID = SOURCE.FuncID
WHEN	MATCHED THEN
	UPDATE SET 
		Policy			=  SOURCE.Policy
		, CreateDate	=  SOURCE.CreateDate
		, ModifyDate	=  SOURCE.ModifyDate
		, Creator		=  SOURCE.Creator
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT ( GroupID, FuncID, Policy, CreateDate, ModifyDate, Creator)
	VALUES( SOURCE.GroupID, SOURCE.FuncID, SOURCE.Policy, SOURCE.CreateDate, SOURCE.ModifyDate, SOURCE.Creator)	
WHEN NOT MATCHED BY SOURCE THEN DELETE ;
	
GO

-- Table 5: Acc_GroupInfo_1
SET IDENTITY_INSERT Acc_GroupInfo_1 ON
MERGE dbo.Acc_GroupInfo_1 TARGET
USING (
	SELECT GroupID, GroupName, GroupDesc, CreateDate, ModifyDate, DisplayOrder, Creator, [System] 
	FROM DBCUST.NAP_UserControl.dbo.Acc_GroupInfo WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.groupID = SOURCE.groupID
WHEN	MATCHED THEN
	UPDATE SET 
		 GroupName		= SOURCE.GroupName
		, GroupDesc		= SOURCE.GroupDesc
		, CreateDate	= SOURCE.CreateDate
		, ModifyDate	= SOURCE.ModifyDate
		, DisplayOrder	= SOURCE.DisplayOrder
		, Creator		= SOURCE.Creator
		, [System]		= SOURCE.[System]
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (GroupID, GroupName, GroupDesc, CreateDate, ModifyDate, DisplayOrder, Creator, [System])
	VALUES(SOURCE.GroupID, SOURCE.GroupName, SOURCE.GroupDesc, SOURCE.CreateDate, SOURCE.ModifyDate, SOURCE.DisplayOrder, SOURCE.Creator, SOURCE.[System])	

WHEN NOT MATCHED BY SOURCE THEN DELETE ;
	
SET IDENTITY_INSERT Acc_GroupInfo_1 OFF

GO
-- Table 6: Acc_FunctionInfo
SET IDENTITY_INSERT Acc_FunctionInfo ON
MERGE dbo.Acc_FunctionInfo TARGET
USING (
	SELECT FuncID, FuncName, FuncNote, FuncDesc, FuncRender, CreateDate, ModifyDate, DisplayOrder, Creator, ParentID, Filenames, [System] 
	FROM DBCUST.NAP_UserControl.dbo.Acc_FunctionInfo WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.FuncID = SOURCE.FuncID
WHEN	MATCHED THEN
	UPDATE SET 
		FuncName		= SOURCE.FuncName
		, FuncNote		= SOURCE.FuncNote
		, FuncDesc		= SOURCE.FuncDesc
		, FuncRender	= SOURCE.FuncRender
		, CreateDate	= SOURCE.CreateDate	
		, ModifyDate	= SOURCE.ModifyDate
		, DisplayOrder	= SOURCE.DisplayOrder
		, Creator		= SOURCE.Creator
		, ParentID		= SOURCE.ParentID
		, Filenames		= SOURCE.Filenames
		, [System]		= SOURCE.[System]
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (FuncID, FuncName, FuncNote, FuncDesc, FuncRender, CreateDate, ModifyDate, DisplayOrder, Creator, ParentID, Filenames, [System] )
	VALUES(SOURCE.FuncID, SOURCE.FuncName, SOURCE.FuncNote, SOURCE.FuncDesc, SOURCE.FuncRender, SOURCE.CreateDate, SOURCE.ModifyDate
		, SOURCE.DisplayOrder, SOURCE.Creator, SOURCE.ParentID, SOURCE.Filenames, SOURCE.[System] )	

WHEN NOT MATCHED BY SOURCE THEN DELETE ;

SET IDENTITY_INSERT Acc_FunctionInfo OFF
GO
-- Table 7: Acc_ExchangeRate
MERGE dbo.Acc_ExchangeRate TARGET
USING (
	SELECT FromExchangeID, ToExchangeID, MinActualRate, MaxActualRate, Creator, LastUpdate 
	FROM DBTRANS.bodb02.dbo.Acc_ExchangeRate WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.FromExchangeID = SOURCE.FromExchangeID AND TARGET.ToExchangeID = SOURCE.ToExchangeID
WHEN	MATCHED THEN
	UPDATE SET 
		MinActualRate		= SOURCE.MinActualRate
		, MaxActualRate		= SOURCE.MaxActualRate
		, Creator			= SOURCE.Creator
		, LastUpdate		= SOURCE.LastUpdate 
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (FromExchangeID, ToExchangeID, MinActualRate, MaxActualRate, Creator, LastUpdate )
	VALUES(SOURCE.FromExchangeID, SOURCE.ToExchangeID, SOURCE.MinActualRate, SOURCE.MaxActualRate, SOURCE.Creator, SOURCE.LastUpdate )	
WHEN NOT MATCHED BY SOURCE THEN DELETE ;	

GO
-- Table 8: Acc_ExchangeRate_History
SET IDENTITY_INSERT Acc_ExchangeRate_History ON
MERGE dbo.Acc_ExchangeRate_History TARGET
USING (
	SELECT RowID, ActionDate, ActionType, UserID, FromExchangeID, ToExchangeID, MinActualRate, MaxActualRate
	FROM DBTRANS.bodb02.dbo.Acc_ExchangeRate_History WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.RowID = SOURCE.RowID
WHEN	MATCHED THEN
	UPDATE SET 
		ActionDate			=SOURCE.ActionDate
		, ActionType		=SOURCE.ActionType
		, UserID			=SOURCE.UserID
		, FromExchangeID	=SOURCE.FromExchangeID
		, ToExchangeID		=SOURCE.ToExchangeID
		, MinActualRate		=SOURCE.MinActualRate
		, MaxActualRate		=SOURCE.MaxActualRate
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (RowID, ActionDate, ActionType, UserID, FromExchangeID, ToExchangeID, MinActualRate, MaxActualRate)
	VALUES(SOURCE.RowID, SOURCE.ActionDate, SOURCE.ActionType, SOURCE.UserID, SOURCE.FromExchangeID, SOURCE.ToExchangeID, SOURCE.MinActualRate, SOURCE.MaxActualRate)	
WHEN NOT MATCHED BY SOURCE THEN DELETE ;	
SET IDENTITY_INSERT Acc_ExchangeRate_History OFF

GO
-- Table cuoi: Acc_ExchangeRate_InvalidTransfer

SET IDENTITY_INSERT Acc_ExchangeRate_InvalidTransfer ON
MERGE dbo.Acc_ExchangeRate_InvalidTransfer TARGET
USING (
	SELECT ID, TransDate, UserID, FromCust, ToCust, FromExchangeID, ToExchangeID, Rate, MinExRate, MaxExRate, ExRate, Amount, RefNo, IsDeleted
	FROM DBTRANS.bodb02.dbo.Acc_ExchangeRate_InvalidTransfer WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.ID = SOURCE.ID
WHEN	MATCHED THEN
	UPDATE SET 
		TransDate			=SOURCE.TransDate
		, UserID			=SOURCE.UserID
		, FromCust			=SOURCE.FromCust
		, ToCust			=SOURCE.ToCust
		, FromExchangeID	=SOURCE.FromExchangeID
		, ToExchangeID		=SOURCE.ToExchangeID
		, Rate				=SOURCE.Rate
		, MinExRate			=SOURCE.MinExRate	
		, MaxExRate			=SOURCE.MaxExRate
		, ExRate			=SOURCE.ExRate
		, Amount			=SOURCE.Amount
		, RefNo				=SOURCE.RefNo
		, IsDeleted			=SOURCE.IsDeleted
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (ID, TransDate, UserID, FromCust, ToCust, FromExchangeID, ToExchangeID, Rate, MinExRate, MaxExRate, ExRate, Amount, RefNo, IsDeleted)
	VALUES(SOURCE.ID, SOURCE.TransDate, SOURCE.UserID, SOURCE.FromCust, SOURCE.ToCust
			, SOURCE.FromExchangeID, SOURCE.ToExchangeID, SOURCE.Rate, SOURCE.MinExRate, SOURCE.MaxExRate, SOURCE.ExRate, SOURCE.Amount, SOURCE.RefNo, SOURCE.IsDeleted)	

WHEN NOT MATCHED BY SOURCE THEN DELETE ;			

SET IDENTITY_INSERT Acc_ExchangeRate_InvalidTransfer OFF

/*
CHECKING DATA


SELECT COUNT(1) FROM AccCustomer_1 WITH (NOLOCK) 
SELECT COUNT(1) FROM DBCUST.NAP_UserControl.dbo.AccCustomer with (nolock)

SELECT COUNT(1) FROM Acc_Menu WITH (NOLOCK)
SELECT COUNT(1) FROM DBCUST.NAP_UserControl.dbo.Acc_Menu with (nolock)

SELECT COUNT(1) FROM Acc_MemberPolicy_1 WITH (NOLOCK)
SELECT COUNT(1) FROM DBCUST.NAP_UserControl.dbo.Acc_MemberPolicy with (nolock)

SELECT COUNT(1) FROM Acc_GroupPolicy_1 WITH (NOLOCK)
SELECT COUNT(1) FROM DBCUST.NAP_UserControl.dbo.Acc_GroupPolicy with (nolock)

SELECT COUNT(1) FROM Acc_GroupInfo_1 WITH (NOLOCK)
SELECT COUNT(1) FROM DBCUST.NAP_UserControl.dbo.Acc_GroupInfo with (nolock)

SELECT COUNT(1) FROM Acc_FunctionInfo WITH (NOLOCK)
SELECT COUNT(1) FROM DBCUST.NAP_UserControl.dbo.Acc_FunctionInfo with (nolock)

SELECT COUNT(1) FROM Acc_ExchangeRate WITH (NOLOCK)
SELECT COUNT(1) FROM DBTRANS.bodb02.dbo.Acc_ExchangeRate WITH (NOLOCK)

SELECT COUNT(1) FROM Acc_ExchangeRate_History WITH (NOLOCK)
SELECT COUNT(1) FROM DBTRANS.bodb02.dbo.Acc_ExchangeRate_History WITH (NOLOCK)

SELECT COUNT(1) FROM Acc_ExchangeRate_InvalidTransfer WITH (NOLOCK)
SELECT COUNT(1) FROM DBTRANS.bodb02.dbo.Acc_ExchangeRate_InvalidTransfer WITH (NOLOCK)

*/



