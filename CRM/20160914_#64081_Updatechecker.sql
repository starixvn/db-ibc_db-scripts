
/*
	Created: Winnie
	Date: 2016-09-15
	Task: Include 'Ignored Accounts' script update RedmineID: #64081
	DB: DBCRM/bodb_CRM
*/ 

USE bodb_CRM
GO
update a
SET a.Checker=chinfo.username 
FROM crmCustomer a 
INNER JOIN DBAGE.bodb02.dbo.CustAccount cus WITH(NOLOCK) ON a.custid=cus.Custid
INNER JOIN DBAGE.bodb02.dbo.customer ch WITH(NOLOCK) ON cus.checker=ch.custid 
INNER JOIN DBAGE.bodb02.dbo.customer chinfo WITH(NOLOCK) ON ch.custid=chinfo.custid 
