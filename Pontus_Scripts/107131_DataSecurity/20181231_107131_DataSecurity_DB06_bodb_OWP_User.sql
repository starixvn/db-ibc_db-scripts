/*
	Created: 20181231@Helen
	Task: https://nexdev.net/issues/107131
	DB: DB06/bodb_OWP
		
*/

CREATE VIEW dbo.vw_User 
/*
	created: 20181231@Helen
	Task: Data Security - [Redmine: 107131]
	DB: DB06/bodb_OWP
*/
AS
SELECT UserId, '' AS FullName, ProfilePic, '' AS Nickname
	, EmployeeId, Skype, DepartmentId, SectionId
	, '' AS Extension, '' AS Phone, '' AS Email, '' AS LocationCode, CategoryId, Username, Pickup
	, '' AS [Address], Level
FROM dbo.[User] WITH (NOLOCK) 

GO
DENY SELECT ON dbo.[User] TO vnteam
GO
