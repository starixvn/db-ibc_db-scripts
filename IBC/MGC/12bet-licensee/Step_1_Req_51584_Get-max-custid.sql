use custdb
go
/*
	https://redmine.nexcel.vn/issues/51584
	get maxcustid
	run on dbcust
*/

select MAX(custid) as maxcustid from custInfo witH(nolock)

go
