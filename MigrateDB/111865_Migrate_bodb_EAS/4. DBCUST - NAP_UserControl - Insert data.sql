USE NAP_UserControl
GO

--eaFunction
SET IDENTITY_INSERT [dbo].[eaFunction] ON

INSERT INTO [dbo].[eaFunction] (
	FuncID,
	FuncName,
	FuncDesc,
	FuncKey,
	ParentID,
	ParentName,
	CreatedDate,
	Creator,
	Modifier,
	ModifiedDate,
	DisplayOrder,
	isTest
)
SELECT FuncID,
	FuncName,
	FuncDesc,
	FuncKey,
	ParentID,
	ParentName,
	CreatedDate,
	Creator,
	Modifier,
	ModifiedDate,
	DisplayOrder,
	isTest
FROM DBEAS.bodb_EAS.dbo.eaFunction WITH(NOLOCK)

SET IDENTITY_INSERT [dbo].[eaFunction] OFF

--eaGroup
SET IDENTITY_INSERT [dbo].[eaGroup] ON

INSERT INTO [dbo].[eaGroup] (
	GroupID,
	GroupName,
	Description,
	CreatedDate,
	Creator,
	Currency,
	CurrencyCode,
	Site
)
SELECT GroupID,
	GroupName,
	Description,
	CreatedDate,
	Creator,
	Currency,
	CurrencyCode,
	Site
FROM DBEAS.bodb_EAS.dbo.eaGroup WITH(NOLOCK)

SET IDENTITY_INSERT [dbo].[eaGroup] OFF

--eaGroupConfiguration
INSERT INTO [dbo].[eaGroupConfiguration] (
	ProductId,
	GroupId,
	IsShow
)
SELECT ProductId,
	GroupId,
	IsShow
FROM DBEAS.bodb_EAS.dbo.eaGroupConfiguration WITH(NOLOCK)

--eaGroupPolicy
INSERT INTO [dbo].[eaGroupPolicy] (
	GroupID,
	FuncID,
	Policy
)
SELECT GroupID,
	FuncID,
	Policy
FROM DBEAS.bodb_EAS.dbo.eaGroupPolicy WITH(NOLOCK)

--eaMenu
SET IDENTITY_INSERT [dbo].[eaMenu] ON

INSERT INTO [dbo].[eaMenu] (
	MenuID,
	MenuName,
	MenuDesc,
	Url,
	FuncID,
	ParentID,
	ParentName,
	DisplayOrder,
	active,
	Creator,
	CreatedDate,
	Modifier,
	ModifiedDate
)
SELECT MenuID,
	MenuName,
	MenuDesc,
	Url,
	FuncID,
	ParentID,
	ParentName,
	DisplayOrder,
	active,
	Creator,
	CreatedDate,
	Modifier,
	ModifiedDate
FROM DBEAS.bodb_EAS.dbo.eaMenu WITH(NOLOCK)

SET IDENTITY_INSERT [dbo].[eaMenu] OFF

--eaOn_User
SET IDENTITY_INSERT [dbo].[eaOn_User] ON

INSERT INTO [dbo].[eaOn_User] (
	on_userid,
	custid,
	reload_time,
	IP,
	iskickedout,
	NetSessionID
)
SELECT on_userid,
	custid,
	reload_time,
	IP,
	iskickedout,
	NetSessionID
FROM DBEAS.bodb_EAS.dbo.eaOn_User WITH(NOLOCK)

SET IDENTITY_INSERT [dbo].[eaOn_User] OFF

--eaUserInfo
INSERT INTO [dbo].[eaUserInfo] (
	UserID,
	GroupID,
	enabled,
	creator,
	createddate
)
SELECT UserID,
	GroupID,
	enabled,
	creator,
	createddate
FROM DBEAS.bodb_EAS.dbo.eaUserInfo WITH(NOLOCK)

--eaUserPolicy
INSERT INTO [dbo].[eaUserPolicy] (
	UserID,
	FuncID,
	Policy
)
SELECT UserID,
	FuncID,
	Policy
FROM DBEAS.bodb_EAS.dbo.eaUserPolicy WITH(NOLOCK)