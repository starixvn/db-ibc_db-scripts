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

CREATE VIEW vwCustomer 
AS
SELECT custid, '' AS firstname, '' AS lastname,'' AS address, '' AS postal,'' AS  city, '' AS state, '' AS country, '' AS phone, '' AS mobilephone
		,'' AS  fax,'' AS  email, birthday, refcode1, refcode2, remark, creatdate, creator, username, currency, userpwd, lastlogged, pwdexpiry, roleid, mrecommend, recommend, ugroup, logincount, on_sessionid, site
		,'' AS  iplogin, important, srecommend, username2
FROM Customer WITH (NOLOCK) 

GO

DENY SELECT ON Customer TO vnteam

GO


