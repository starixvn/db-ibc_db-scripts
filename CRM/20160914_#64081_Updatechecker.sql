
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
CREATE TABLE #TempHeadline (CUSTID INT)
INSERT INTO #TempHeadline(CUSTID)
SELECT a.Custid FROM crmCustomer a WITH(NOLOCK)
INNER JOIN bodb02.dbo.CustAccount cus WITH(NOLOCK) ON a.custid=cus.Custid AND cus.IsGroupHeadLine=1

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
SELECT hedinfo.CustID
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
 LEFT JOIN bodb02.dbo.Customer ch WITH(NOLOCK)   ON hed.checker=ch.custid
 WHERE hedinfo.custid NOT IN (SELECT CustID FROM #TempHeadline a WITH(NOLOCK))
 
 -- Update default values for ignored column
 Update crmCustomer WITH(ROWLOCK,UPDLOCK) SET Ignored=0
