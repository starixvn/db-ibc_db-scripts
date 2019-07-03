USE [bodb_Licensee]
GO

/*
	Created: 20190510@Percy
	DB: DBCUST.bodb_Licensee
	Task: Move tables - Initialize data
*/

/****** Object:  Table [dbo].[LA_AnalysisFile]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT LA_AnalysisFile ON
INSERT INTO [dbo].[LA_AnalysisFile]([FileId],[PartyIds],[ProductCodes],[Filename],[FromDate],[ToDate],[Status],[IsSkinView])
SELECT [FileId],[PartyIds],[ProductCodes],[Filename],[FromDate],[ToDate],[Status],[IsSkinView] FROM DB215.bodb_Licensee.dbo.[LA_AnalysisFile] WITH (NOLOCK)
SET IDENTITY_INSERT LA_AnalysisFile OFF

/****** Object:  Table [dbo].[LA_BankInfo]    Script Date: 5/17/2019 12:52:39 AM ******/
INSERT INTO [dbo].[LA_BankInfo]([PartyId],[BankId],[AccountNumber],[BankName],[BankAddress],[IBAN],[BeneficiaryName],[SwiftCode],[CorrespondentBank],[CorrespondentAccountNumber],[CorrespondentAddress],[CorrespondentSwiftCode])
SELECT [PartyId],[BankId],[AccountNumber],[BankName],[BankAddress],[IBAN],[BeneficiaryName],[SwiftCode],[CorrespondentBank],[CorrespondentAccountNumber],[CorrespondentAddress],[CorrespondentSwiftCode] FROM DB215.bodb_Licensee.dbo.[LA_BankInfo] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_BillerInfo]    Script Date: 5/17/2019 12:52:39 AM ******/
INSERT INTO [dbo].[LA_BillerInfo]([PartyId],[BillerName],[BillerFullName],[StatusId],[CompanyName],[Address1],[Address2],[LogoPath],[Description],[Logo],[LogoHeight],[LogoWidth])
SELECT [PartyId],[BillerName],[BillerFullName],[StatusId],[CompanyName],[Address1],[Address2],[LogoPath],[Description],[Logo],[LogoHeight],[LogoWidth] FROM DB215.bodb_Licensee.dbo.[LA_BillerInfo] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_CombinedGroup]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [LA_CombinedGroup] ON
INSERT INTO [dbo].[LA_CombinedGroup]([GroupId],[GroupName],[PathCode])
SELECT [GroupId],[GroupName],[PathCode] FROM DB215.bodb_Licensee.dbo.[LA_CombinedGroup] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_CombinedGroup] OFF

/****** Object:  Table [dbo].[LA_CombinedGroupAssignment]    Script Date: 5/17/2019 12:52:39 AM ******/
INSERT INTO [dbo].[LA_CombinedGroupAssignment]([GroupId],[PartyId],[GroupType])
SELECT [GroupId],[PartyId],[GroupType] FROM DB215.bodb_Licensee.dbo.[LA_CombinedGroupAssignment] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_HostingFeesTypes]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [LA_HostingFeesTypes] ON
INSERT INTO [dbo].[LA_HostingFeesTypes]([HostingFeesTypeId],[HostingFeesTypeName])
SELECT [HostingFeesTypeId],[HostingFeesTypeName] FROM DB215.bodb_Licensee.dbo.[LA_HostingFeesTypes] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_HostingFeesTypes] OFF

/****** Object:  Table [dbo].[LA_InvoiceDetail]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [LA_InvoiceDetail] ON
INSERT INTO [dbo].[LA_InvoiceDetail]([InvoiceDetailId],[InvoiceHeaderId],[Description],[Reference],[ProductId],[AmountType],[InvoiceAmount])
SELECT [InvoiceDetailId],[InvoiceHeaderId],[Description],[Reference],[ProductId],[AmountType],[InvoiceAmount] FROM DB215.bodb_Licensee.dbo.[LA_InvoiceDetail] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_InvoiceDetail] OFF

/****** Object:  Table [dbo].[LA_InvoiceFile]    Script Date: 5/17/2019 12:52:39 AM ******/
INSERT INTO [dbo].[LA_InvoiceFile]([InvoiceHeaderId],[FileData])
SELECT [InvoiceHeaderId],[FileData] FROM DB215.bodb_Licensee.dbo.[LA_InvoiceFile] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_InvoiceType]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [LA_InvoiceType] ON
INSERT INTO [dbo].[LA_InvoiceType]([InvTypeId],[InvTypeName],[IsVisible])
SELECT [InvTypeId],[InvTypeName],[IsVisible] FROM DB215.bodb_Licensee.dbo.[LA_InvoiceType] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_InvoiceType] OFF

/****** Object:  Table [dbo].[LA_InvoiceTypeMapping]    Script Date: 5/17/2019 12:52:39 AM ******/
INSERT INTO [dbo].[LA_InvoiceTypeMapping]([InvTypeId],[InvItemTypeId])
SELECT [InvTypeId],[InvItemTypeId] FROM DB215.bodb_Licensee.dbo.[LA_InvoiceTypeMapping] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_OnUser]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [LA_OnUser] ON
INSERT INTO [dbo].[LA_OnUser]([Custid],[Reload_time],[On_userid],[IP],[iskickedout],[NetSessionID])
SELECT [Custid],[Reload_time],[On_userid],[IP],[iskickedout],[NetSessionID] FROM DB215.bodb_Licensee.dbo.[LA_OnUser] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_OnUser] OFF

/****** Object:  Table [dbo].[LA_SettingGroupAssignment]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [LA_SettingGroupAssignment] ON
INSERT INTO [dbo].[LA_SettingGroupAssignment]([SettingGroupAssignmentId],[SettingGroupHeaderId],[PartyId],[FromDate],[ToDate],[Status])
SELECT [SettingGroupAssignmentId],[SettingGroupHeaderId],[PartyId],[FromDate],[ToDate],[Status] FROM DB215.bodb_Licensee.dbo.[LA_SettingGroupAssignment] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_SettingGroupAssignment] OFF

/****** Object:  Table [dbo].[LA_SettingGroupDetail]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [LA_SettingGroupDetail] ON
INSERT INTO [dbo].[LA_SettingGroupDetail]([SettingGroupDetailId],[SettingGroupHeaderId],[CurrencyId],[TargetAmount],[Period],[Rate],[FromDate],[ToDate],[RestartDate],[Status])
SELECT [SettingGroupDetailId],[SettingGroupHeaderId],[CurrencyId],[TargetAmount],[Period],[Rate],[FromDate],[ToDate],[RestartDate],[Status] FROM DB215.bodb_Licensee.dbo.[LA_SettingGroupDetail] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_SettingGroupDetail] OFF

/****** Object:  Table [dbo].[LA_SettingGroupHeader]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [LA_SettingGroupHeader] ON
INSERT INTO [dbo].[LA_SettingGroupHeader]([SettingGroupHeaderId],[GroupName],[SettingGroupType],[Note])
SELECT [SettingGroupHeaderId],[GroupName],[SettingGroupType],[Note] FROM DB215.bodb_Licensee.dbo.[LA_SettingGroupHeader] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_SettingGroupHeader] OFF

/****** Object:  Table [dbo].[LA_SystemSettings]    Script Date: 5/17/2019 12:52:39 AM ******/
INSERT INTO [dbo].[LA_SystemSettings]([Key],[Value])
SELECT [Key],[Value] FROM DB215.bodb_Licensee.dbo.[LA_SystemSettings] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_User]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [LA_User] ON
INSERT INTO [dbo].[LA_User]([UserID],[GroupID],[Username],[UserPwd],[DisplayName],[UserSalt],[StatusID],[Creator],[CreatedDate],[ModifiedDate])
SELECT [UserID],[GroupID],[Username],[UserPwd],[DisplayName],[UserSalt],[StatusID],[Creator],[CreatedDate],[ModifiedDate] FROM DB215.bodb_Licensee.dbo.[LA_User] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_User] OFF

/****** Object:  Table [dbo].[OAS_OnUser]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [OAS_OnUser] ON
INSERT INTO [dbo].[OAS_OnUser]([custid],[reload_time],[on_userid],[IP],[iskickedout],[NetSessionID])
SELECT [custid],[reload_time],[on_userid],[IP],[iskickedout],[NetSessionID] FROM DB215.bodb_Licensee.dbo.[OAS_OnUser] WITH (NOLOCK)
SET IDENTITY_INSERT [OAS_OnUser] OFF

/****** Object:  Table [dbo].[OAS_Users]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [OAS_Users] ON
INSERT INTO [dbo].[OAS_Users]([UserID],[Username],[UserPwd],[DisplayName],[Role],[UserSalt],[IsActive],[Creator],[CreatedDate],[ModifiedDate],[IsTest])
SELECT [UserID],[Username],[UserPwd],[DisplayName],[Role],[UserSalt],[IsActive],[Creator],[CreatedDate],[ModifiedDate],[IsTest] FROM DB215.bodb_Licensee.dbo.[OAS_Users] WITH (NOLOCK)
SET IDENTITY_INSERT [OAS_Users] OFF

/****** Object:  Table [dbo].[LA_InvoiceItemType]    Script Date: 5/17/2019 12:52:39 AM ******/
INSERT INTO [dbo].[LA_InvoiceItemType]([SignDB],[GroupDB],[SignSOA],[GroupSOA],[InvItemTypeName],[InvItemTypeId])
SELECT [SignDB],[GroupDB],[SignSOA],[GroupSOA],[InvItemTypeName],[InvItemTypeId] FROM DB215.bodb_Licensee.dbo.[LA_InvoiceItemType] WITH (NOLOCK)