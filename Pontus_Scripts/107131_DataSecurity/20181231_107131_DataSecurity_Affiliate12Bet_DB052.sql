/*
	Created: 20181231@Helen
	Task: https://nexdev.net/issues/107131
	DB: DB052/Affiliate_12BET
		
	EmailHistory
	AffInfo
	MemberInfo


*/

CREATE VIEW dbo.vwEmailHistory 
/*
	created: 20181231@Helen
	Task: Data Security - [Redmine: 107131]
	DB: DB052/Affiliate_12BET
*/
AS
SELECT MID, Content, Sender, Creator, AffId, AffName
	, '' AS Email, [Subject], CreatedDate, IP, Browser, SessionID
FROM dbo.EmailHistory WITH (NOLOCK) 
GO

CREATE VIEW dbo.vwAffInfo 
/*
	created: 20181231@Helen
	Task: Data Security - [Redmine: 107131]
	DB: DB052/Affiliate_12BET
*/
AS
SELECT AffID, UserName, UserName2
		, '' AS FirstName, '' AS LastName, GroupID, [Status], ApprovedDate, IsClosed, Currency, RegisteredDate
		, '' AS Email, [Password], AffType, IsPageEnabled, [Level], IsLocked, CasinoJoinedDate, ForceChangePass, EUAffID
FROM dbo.AffInfo WITH (NOLOCK) 
GO
CREATE VIEW dbo.vwMemberInfo 
/*
	created: 20181231@Helen
	Task: Data Security - [Redmine: 107131]
	DB: DB052/Affiliate_12BET
*/
AS
SELECT IBCCustID, AffID, UserName, IBCUserName, CreatedDate, RegisteredDate, IsRemoved, DepositCustID
	, '' AS FirstName, '' AS LastName, Currency, '' AS Email, Recommend, ClickId, EUAffID, AffAffectedDate
FROM dbo.MemberInfo WITH (NOLOCK) 

GO

DENY SELECT ON dbo.EmailHistory TO vnteam
GO
DENY SELECT ON dbo.AffInfo TO vnteam
GO
DENY SELECT ON dbo.MemberInfo TO vnteam
GO