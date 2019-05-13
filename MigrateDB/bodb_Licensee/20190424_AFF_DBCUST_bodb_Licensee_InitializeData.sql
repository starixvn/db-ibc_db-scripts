USE [bodb_licensee]
GO

/*
	Created: 20190424@Percy
	DB: DBCUST.bodb_Licensee
	Task: Migrate DB - Import data
*/

/* INSERT DATA dbo.Aff_FunctionInfo */
TRUNCATE TABLE dbo.Aff_FunctionInfo
GO

SET IDENTITY_INSERT dbo.Aff_FunctionInfo ON

INSERT INTO dbo.Aff_FunctionInfo
(
	FunctionID,FunctionName,FunctionNote,FunctionDesc,FunctionRender,CreateDate
	,ModifyDate,DisplayOrder,Creator,ParentID,Filenames
)
SELECT
	FunctionID,FunctionName,FunctionNote,FunctionDesc,FunctionRender,CreateDate
	,ModifyDate,DisplayOrder,Creator,ParentID,Filenames
FROM DBLIC.bodb_Licensee.dbo.Aff_FunctionInfo WITH (NOLOCK)

SET IDENTITY_INSERT dbo.Aff_FunctionInfo OFF

GO

/* INSERT DATA dbo.Aff_GroupInfo */
TRUNCATE TABLE dbo.Aff_GroupInfo
GO

SET IDENTITY_INSERT dbo.Aff_GroupInfo ON

INSERT INTO dbo.Aff_GroupInfo
(
	GroupID,LicenseeID,GroupName,GroupDesc,CreateDate,ModifyDate,DisplayOrder,Creator
)
SELECT
	GroupID,LicenseeID,GroupName,GroupDesc,CreateDate,ModifyDate,DisplayOrder,Creator
FROM DBLIC.bodb_Licensee.dbo.Aff_GroupInfo WITH (NOLOCK)

SET IDENTITY_INSERT dbo.Aff_GroupInfo OFF

GO

/* INSERT DATA dbo.Aff_GroupPolicy */
TRUNCATE TABLE dbo.Aff_GroupPolicy
GO

INSERT INTO dbo.Aff_GroupPolicy
(
	GroupID,FunctionID,Policy,CreateDate,ModifyDate,Creator
)
SELECT
	GroupID,FunctionID,Policy,CreateDate,ModifyDate,Creator
FROM DBLIC.bodb_Licensee.dbo.Aff_GroupPolicy WITH (NOLOCK)

GO

/* INSERT DATA dbo.Aff_LicenseeFunction */
TRUNCATE TABLE dbo.Aff_LicenseeFunction
GO

INSERT INTO dbo.Aff_LicenseeFunction
(
	LicenseeID,FunctionID,IsActive
)
SELECT
	LicenseeID,FunctionID,IsActive
FROM DBLIC.bodb_Licensee.dbo.Aff_LicenseeFunction WITH (NOLOCK)

GO

/* INSERT DATA dbo.Aff_LicenseeUser */
TRUNCATE TABLE dbo.Aff_LicenseeUser
GO

INSERT INTO dbo.Aff_LicenseeUser
(
	LicenseeID,UserID,GroupID,IsActive,ModifyDate,ModifyBy
)
SELECT
	LicenseeID,UserID,GroupID,IsActive,ModifyDate,ModifyBy
FROM DBLIC.bodb_Licensee.dbo.Aff_LicenseeUser WITH (NOLOCK)

GO

/* INSERT DATA dbo.Aff_On_User */
TRUNCATE TABLE dbo.Aff_On_User
GO

SET IDENTITY_INSERT dbo.Aff_On_User ON

INSERT INTO dbo.Aff_On_User
(
	CustID,Reload_Time,ServerID,On_UserID,IP,IsKickedOut,NetSessionID
)
SELECT
	CustID,Reload_Time,ServerID,On_UserID,IP,IsKickedOut,NetSessionID
FROM DBLIC.bodb_Licensee.dbo.Aff_On_User WITH (NOLOCK)

SET IDENTITY_INSERT dbo.Aff_On_User OFF

GO

/* INSERT DATA dbo.Aff_UserPolicy */
TRUNCATE TABLE dbo.Aff_UserPolicy
GO

INSERT INTO dbo.Aff_UserPolicy
(
	UserID,LicenseeID,FunctionID,Policy,CreateDate,ModifyDate,Creator
)
SELECT
	UserID,LicenseeID,FunctionID,Policy,CreateDate,ModifyDate,Creator
FROM DBLIC.bodb_Licensee.dbo.Aff_UserPolicy WITH (NOLOCK)

GO

/* INSERT DATA dbo.Aff_LicenseeInfo */
TRUNCATE TABLE dbo.Aff_LicenseeInfo
GO

INSERT INTO dbo.Aff_LicenseeInfo
(
	LicenseeID,LicenseeName,IsActive
)
SELECT
	LicenseeID,LicenseeName,IsActive
FROM DBLIC.bodb_Licensee.dbo.Aff_LicenseeInfo WITH (NOLOCK)

GO