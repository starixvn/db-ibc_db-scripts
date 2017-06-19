--Run on Affiliate DB
use Affiliate_Bolanation
go
--Run for these columns: Creator, UpdatedBy, RemovedBy
/*
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE COLUMN_NAME LIKE '%creator%'
*/
declare @LicenseeID int

select @LicenseeID = SValue
from SystemSettings (nolock)
where SName = 'LicenseeID'

--genrate script to execute
select 'update a
set a.creator = u.UserID
from dbo.' + table_name + ' a ' + CHAR(13) +
	 ' inner join dbo.AdminUser b with (nolock) on a.Creator = b.custid ' + CHAR(13) +
	 ' inner join DBLIC.bodb_Licensee.dbo.Aff_User_CreatorTransfer ct with (nolock) on b.Username = ct.Aff_OldUsername and ct.LicenseeID = ' + cast(@LicenseeID as varchar(100)) +
	 ' inner join DBLIC.bodb_Licensee.dbo.Users u with (nolock) on u.Username = ct.Aff_NewAdminUsername
	   inner join DBLIC.bodb_Licensee.dbo.Aff_LicenseeUser lu with (nolock) on lu.UserID = u.UserID and lu.LicenseeID = ' + cast(@LicenseeID as varchar(100))
from INFORMATION_SCHEMA.COLUMNS 
where COLUMN_NAME LIKE '%creator%'