/*<info serverAlias="DBCRM-bodb_CRM"></info>*/

USE bodb_CRM
GO

/*
	Created: 20200826@Malcolm
	DB: DBCRM.bodb_CRM
	Task:  Update data of the HeadlineID column
	Revisions:
		- 20200826@Malcolm:  Update data of the HeadlineID column [RedmineID: #137144]
*/

UPDATE m
SET m.HeadlineID = ISNULL(h.CustID,0)
FROM dbo.crmPicManagement m WITH(ROWLOCK)	
	LEFT JOIN bodb02.dbo.CustAccount ac WITH(NOLOCK) ON m.CustID = ac.custid
	LEFT JOIN bodb02.dbo.CustGroupHeadline h WITH(NOLOCK) ON ac.groupID = h.groupid
	

