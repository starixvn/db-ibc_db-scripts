/*
	Created: 20181231@Helen
	Task: https://nexdev.net/issues/107131
	DB: 
		#1 - DBCUST.CUSTDB
		#2 - Replicated Servers ON PUB CustDB_Customer_Info.bodb02: 
			DB042.BODB02
			DB043.BODB02
			DB044.BODB02
			DB05.BODB02
			DB052.BODB02
			DB053.BODB02
			DB054.BODB02
			DB05BK1.BODB02
			DB06.BODB02
			DBLICAPI.BODB02
			DBLICAPI02.BODB02
			DBTP.BODB02
*/

CREATE VIEW dbo.vw_CustAccount 
/*
	created: 20181231@Helen
	Task: Data Security - [Redmine: 107131]
	DB: DBCust/custdb and all replicated server/bodb02
*/
AS
SELECT custid, creditgrade, installmentdate, installmentamount, preagreeamount
	,'' AS accountremark, accountremarkdate, groupID, IsGroupHeadLine, checker, IsRptConsol
FROM dbo.custAccount WITH (NOLOCK) 

GO
DENY SELECT ON dbo.custAccount TO vnteam
GO

