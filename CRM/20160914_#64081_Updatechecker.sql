
/*
	Created: Winnie
	Date: 2016-09-15
	Task: Include 'Ignored Accounts' script update RedmineID: #64081
	DB: DBCRM/bodb_CRM
*/ 

-- update checker for headline existed in CRM
USE bodb_CRM
GO
update a WITH(ROWLOCK,UPDLOCK)
SET a.Checker=ch.username 
FROM crmCustomer a 
INNER JOIN bodb02.dbo.CustAccount cus WITH(NOLOCK) ON a.custid=cus.Custid AND cus.IsGroupHeadLine=1
INNER JOIN bodb02.dbo.customer ch WITH(NOLOCK) ON cus.checker=ch.custid 

----Insert headline who not existed in CRM
CREATE TABLE #TempHeadline (
[CustID] [int] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[TitleID] [int] NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[PhoneCountryCode] [nvarchar](20) NULL,
	[PhoneAreaCode] [nvarchar](20) NULL,
	[Phone2] [nvarchar](50) NULL,
	[Phone2CountryCode] [nvarchar](20) NULL,
	[Phone2AreaCode] [nvarchar](20) NULL,
	[Phone3] [nvarchar](50) NULL,
	[Phone3CountryCode] [nvarchar](20) NULL,
	[Phone3AreaCode] [nvarchar](20) NULL,
	[MobilePhone] [nvarchar](50) NULL,
	[MobilePhoneCountryCode] [nvarchar](20) NULL,
	[MobilePhoneAreaCode] [nvarchar](20) NULL,
	[Passport] [nvarchar](50) NULL,
	[Line1] [nvarchar](50) NULL,
	[Line2] [nvarchar](50) NULL,
	[Line3] [nvarchar](50) NULL,
	[City] [nvarchar](100) NULL,
	[PostCode] [nvarchar](50) NULL,
	[State] [nvarchar](50) NULL,
	[BankLine1] [nvarchar](200) NULL,
	[BankLine2] [nvarchar](200) NULL,
	[BankLine3] [nvarchar](200) NULL,
	[BankCity] [nvarchar](50) NULL,
	[BankCode] [nvarchar](50) NULL,
	[BankState] [nvarchar](50) NULL,
	[Fax] [nvarchar](50) NULL,
	[FaxCountryCode] [nvarchar](20) NULL,
	[FaxAreaCode] [nvarchar](20) NULL,
	[Email] [nvarchar](254) NULL,
	[Birthday] [smalldatetime] NULL,
	[RefCode1] [nvarchar](50) NULL,
	[RefCode2] [nvarchar](50) NULL,
	[Pic1] [nvarchar](100) NULL,
	[Pic2] [nvarchar](100) NULL,
	[Pic3] [nvarchar](100) NULL,
	[Pic4] [nvarchar](100) NULL,
	[LanguageID] [int] NULL,
	[Question] [nvarchar](300) NULL,
	[Answer] [nvarchar](300) NULL,
	[CountryID] [int] NULL,
	[IsVIP] [bit] NULL,
	[RelatedCustID] [int] NULL,
	[SiteID] [int] NULL,
	[Wire_BankName] [nvarchar](100) NULL,
	[Wire_BankAddress] [nvarchar](200) NULL,
	[Wire_SwiftCode] [nvarchar](50) NULL,
	[Wire_AccountName] [nvarchar](100) NULL,
	[Wire_AccountNo] [varchar](50) NULL,
	[Remark] [nvarchar](3000) NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreatorID] [int] NOT NULL,
	[Remark2] [nvarchar](3000) NULL,
	[AccountHolderName] [nvarchar](100) NULL,
	[Skype] [nvarchar](100) NULL,
	[MSN] [nvarchar](100) NULL,
	[tstamp] [timestamp] NOT NULL,
	[BankCountryID] [int] NULL,
	[IsVerifyEmail] [bit] NULL,
	[IsVerifyPassport] [bit] NULL,
	[IsVerifyBirthday] [bit] NULL,
	[IsVerifySecretCode] [bit] NULL,
	[IsVerifyBetCredit] [bit] NULL,
	[IsVerifyGivenCredit] [bit] NULL,
	[Pic1Name] [nvarchar](200) NULL,
	[Pic2Name] [nvarchar](200) NULL,
	[Pic3Name] [nvarchar](200) NULL,
	[Pic4Name] [nvarchar](200) NULL,
	[WhatsApp] [nvarchar](100) NULL,
	[Line] [nvarchar](100) NULL,
	[WeChat] [nvarchar](100) NULL,
	[Yahoo] [nvarchar](100) NULL,
	[BBM] [nvarchar](100) NULL,
	[LicenseeType] [int] NULL,
	[QQ] [nvarchar](100) NULL,
	[Ignored] [bit] NULL,
	[Checker] [nvarchar](50) NULL)

INSERT INTO #TempHeadline(
			[CustID]
           ,[UserName]
           ,[TitleID]
           ,[FirstName]
           ,[LastName]
           ,[Phone]
           ,[PhoneCountryCode]
           ,[PhoneAreaCode]
           ,[Phone2]
           ,[Phone2CountryCode]
           ,[Phone2AreaCode]
           ,[Phone3]
           ,[Phone3CountryCode]
           ,[Phone3AreaCode]
           ,[MobilePhone]
           ,[MobilePhoneCountryCode]
           ,[MobilePhoneAreaCode]
           ,[Passport]
           ,[Line1]
           ,[Line2]
           ,[Line3]
           ,[City]
           ,[PostCode]
           ,[State]
           ,[BankLine1]
           ,[BankLine2]
           ,[BankLine3]
           ,[BankCity]
           ,[BankCode]
           ,[BankState]
           ,[Fax]
           ,[FaxCountryCode]
           ,[FaxAreaCode]
           ,[Email]
           ,[Birthday]
           ,[RefCode1]
           ,[RefCode2]
           ,[Pic1]
           ,[Pic2]
           ,[Pic3]
           ,[Pic4]
           ,[LanguageID]
           ,[Question]
           ,[Answer]
           ,[CountryID]
           ,[IsVIP]
           ,[RelatedCustID]
           ,[SiteID]
           ,[Wire_BankName]
           ,[Wire_BankAddress]
           ,[Wire_SwiftCode]
           ,[Wire_AccountName]
           ,[Wire_AccountNo]
           ,[Remark]
           ,[CreateDate]
           ,[CreatorID]
           ,[Remark2]
           ,[AccountHolderName]
           ,[Skype]
           ,[MSN]
           ,[BankCountryID]
           ,[IsVerifyEmail]
           ,[IsVerifyPassport]
           ,[IsVerifyBirthday]
           ,[IsVerifySecretCode]
           ,[IsVerifyBetCredit]
           ,[IsVerifyGivenCredit]
           ,[Pic1Name]
           ,[Pic2Name]
           ,[Pic3Name]
           ,[Pic4Name]
           ,[WhatsApp]
           ,[Line]
           ,[WeChat]
           ,[Yahoo]
           ,[BBM]
           ,[LicenseeType]
           ,[QQ]
           ,[Ignored]
           ,[Checker])
           SELECT 
			hedinfo.CustID
           ,hedinfo.[UserName]
           ,''
           ,hedinfo.[FirstName]
           ,hedinfo.[LastName]
           ,hedinfo.[Phone]
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,hedinfo.[MobilePhone]
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,hedinfo.[City]
           ,NULL
           ,hedinfo.[State]
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,hedinfo.[Fax]
           ,NULL
           ,NULL
           ,hedinfo.[Email]
           ,hedinfo.[Birthday]
           ,hedinfo.[RefCode1]
           ,hedinfo.[RefCode2]
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,hedinfo.[Remark]
           ,GETDATE()
           ,hedinfo.creator
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,0
           ,ch.username
FROM bodb02.dbo.CustAccount hed INNER JOIN 
 bodb02.dbo.Customer hedinfo WITH(NOLOCK)  ON hed.IsGroupHeadLine=1 AND hed.custid=hedinfo.custid
 INNER JOIN bodb02.dbo.Customer ch WITH(NOLOCK)   ON hed.checker=ch.custid

INSERT INTO [bodb_CRM].[dbo].[crmCustomer]
           ([CustID]
           ,[UserName]
           ,[TitleID]
           ,[FirstName]
           ,[LastName]
           ,[Phone]
           ,[PhoneCountryCode]
           ,[PhoneAreaCode]
           ,[Phone2]
           ,[Phone2CountryCode]
           ,[Phone2AreaCode]
           ,[Phone3]
           ,[Phone3CountryCode]
           ,[Phone3AreaCode]
           ,[MobilePhone]
           ,[MobilePhoneCountryCode]
           ,[MobilePhoneAreaCode]
           ,[Passport]
           ,[Line1]
           ,[Line2]
           ,[Line3]
           ,[City]
           ,[PostCode]
           ,[State]
           ,[BankLine1]
           ,[BankLine2]
           ,[BankLine3]
           ,[BankCity]
           ,[BankCode]
           ,[BankState]
           ,[Fax]
           ,[FaxCountryCode]
           ,[FaxAreaCode]
           ,[Email]
           ,[Birthday]
           ,[RefCode1]
           ,[RefCode2]
           ,[Pic1]
           ,[Pic2]
           ,[Pic3]
           ,[Pic4]
           ,[LanguageID]
           ,[Question]
           ,[Answer]
           ,[CountryID]
           ,[IsVIP]
           ,[RelatedCustID]
           ,[SiteID]
           ,[Wire_BankName]
           ,[Wire_BankAddress]
           ,[Wire_SwiftCode]
           ,[Wire_AccountName]
           ,[Wire_AccountNo]
           ,[Remark]
           ,[CreateDate]
           ,[CreatorID]
           ,[Remark2]
           ,[AccountHolderName]
           ,[Skype]
           ,[MSN]
           ,[BankCountryID]
           ,[IsVerifyEmail]
           ,[IsVerifyPassport]
           ,[IsVerifyBirthday]
           ,[IsVerifySecretCode]
           ,[IsVerifyBetCredit]
           ,[IsVerifyGivenCredit]
           ,[Pic1Name]
           ,[Pic2Name]
           ,[Pic3Name]
           ,[Pic4Name]
           ,[WhatsApp]
           ,[Line]
           ,[WeChat]
           ,[Yahoo]
           ,[BBM]
           ,[LicenseeType]
           ,[QQ]
           ,[Ignored]
           ,[Checker])
SELECT [CustID]
           ,[UserName]
           ,[TitleID]
           ,[FirstName]
           ,[LastName]
           ,[Phone]
           ,[PhoneCountryCode]
           ,[PhoneAreaCode]
           ,[Phone2]
           ,[Phone2CountryCode]
           ,[Phone2AreaCode]
           ,[Phone3]
           ,[Phone3CountryCode]
           ,[Phone3AreaCode]
           ,[MobilePhone]
           ,[MobilePhoneCountryCode]
           ,[MobilePhoneAreaCode]
           ,[Passport]
           ,[Line1]
           ,[Line2]
           ,[Line3]
           ,[City]
           ,[PostCode]
           ,[State]
           ,[BankLine1]
           ,[BankLine2]
           ,[BankLine3]
           ,[BankCity]
           ,[BankCode]
           ,[BankState]
           ,[Fax]
           ,[FaxCountryCode]
           ,[FaxAreaCode]
           ,[Email]
           ,[Birthday]
           ,[RefCode1]
           ,[RefCode2]
           ,[Pic1]
           ,[Pic2]
           ,[Pic3]
           ,[Pic4]
           ,[LanguageID]
           ,[Question]
           ,[Answer]
           ,[CountryID]
           ,[IsVIP]
           ,[RelatedCustID]
           ,[SiteID]
           ,[Wire_BankName]
           ,[Wire_BankAddress]
           ,[Wire_SwiftCode]
           ,[Wire_AccountName]
           ,[Wire_AccountNo]
           ,[Remark]
           ,[CreateDate]
           ,[CreatorID]
           ,[Remark2]
           ,[AccountHolderName]
           ,[Skype]
           ,[MSN]
           ,[BankCountryID]
           ,[IsVerifyEmail]
           ,[IsVerifyPassport]
           ,[IsVerifyBirthday]
           ,[IsVerifySecretCode]
           ,[IsVerifyBetCredit]
           ,[IsVerifyGivenCredit]
           ,[Pic1Name]
           ,[Pic2Name]
           ,[Pic3Name]
           ,[Pic4Name]
           ,[WhatsApp]
           ,[Line]
           ,[WeChat]
           ,[Yahoo]
           ,[BBM]
           ,[LicenseeType]
           ,[QQ]
           ,[Ignored]
           ,[Checker]
FROM #TempHeadline hedinfo
WHERE hedinfo.custid NOT IN (SELECT CustID FROM crmCustomer a WITH(NOLOCK))
 
DROP TABLE 	#TempHeadline
 -- Update default values for ignored column
 
 
 Update crmCustomer WITH(ROWLOCK,UPDLOCK) SET Ignored=0
