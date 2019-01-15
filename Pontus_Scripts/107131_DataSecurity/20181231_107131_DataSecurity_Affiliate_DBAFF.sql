/*
	Created: 20181231@Helen
	Task: https://nexdev.net/issues/107131
	DB: DBAFF/Affiliate_Athena000,DBAFF/Affiliate_Spondemo,DBAFF/Affiliate_itcbet,DBAFF/Affiliate_MacauBet
		
	EmailHistory
	AffInfo
	MemberInfo


*/
CREATE VIEW dbo.vw_EmailHistory 
/*
	created: 20181231@Helen
	Task: Data Security - [Redmine: 107131]
	DB: DBAFF/Affiliate_Athena000,DBAFF/Affiliate_Spondemo,DBAFF/Affiliate_itcbet,DBAFF/Affiliate_MacauBet
*/
AS
SELECT MID, Content, Sender, Creator, AffId, AffName
	, '' AS Email, [Subject], CreatedDate, IP, Browser, SessionID
FROM dbo.EmailHistory WITH (NOLOCK) 
GO

CREATE VIEW dbo.vw_AffInfo 
/*
	created: 20181231@Helen
	Task: Data Security - [Redmine: 107131]
	DB: DBAFF/Affiliate_Athena000,DBAFF/Affiliate_Spondemo,DBAFF/Affiliate_itcbet,DBAFF/Affiliate_MacauBet
*/
AS
SELECT AffID, UserName, UserName2, '' AS FirstName, '' AS LastName, GroupID, [Status], ApprovedDate, IsClosed, Currency, RegisteredDate
	, '' AS Email
	, [Password], AffType, IsPageEnabled, [Level], IsLocked, TestLevel, BF, TotalMembers
FROM dbo.AffInfo WITH (NOLOCK) 
GO

CREATE VIEW dbo.vw_MemberInfo 
/*
	created: 20181231@Helen
	Task: Data Security - [Redmine: 107131]
	DB: DBAFF/Affiliate_Athena000,DBAFF/Affiliate_Spondemo,DBAFF/Affiliate_itcbet,DBAFF/Affiliate_MacauBet
*/
AS
SELECT UserName, AffID, CreatedDate, RegisteredDate, DepositCustID, Currency
	, '' AS FirstName, '' AS LastName, '' AS Email, IsRemoved, IBCCustID, IBCUserName, Recommend, Btag, ClickID, CountryID
	, '' AS Phone, '' AS [Address], AffAffectedDate
FROM dbo.MemberInfo WITH (NOLOCK) 
GO

DENY SELECT ON dbo.EmailHistory TO vnteam
GO
DENY SELECT ON dbo.AffInfo TO vnteam
GO
DENY SELECT ON dbo.MemberInfo TO vnteam
GO

