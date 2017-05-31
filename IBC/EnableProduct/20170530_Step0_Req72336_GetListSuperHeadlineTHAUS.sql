
/*
	Created: Winnie	
	Task:  Get list headline THAUS into the excel file
	DB: DBCUST/CustDB
	Date: 20170403
*/ 
DECLARE @maxcustid INT
SET @maxcustid=xxx

select cu.custid,c.username from custaccount cu with  (nolock)
inner join custinfo c with (nolock) on cu.custid=c.custid
where cu.custid<=@maxcustid AND groupid=515 and c.roleid=4
