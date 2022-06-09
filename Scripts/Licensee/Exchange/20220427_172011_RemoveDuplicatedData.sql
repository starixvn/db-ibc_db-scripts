/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20220427@Percy
	DB: DBLIC-bodb_3rdProduct
	Task: Exchange Product - Remove duplicate data due to API's issue
	https://nexdev.net/issues/172011
*/
use bodb_3rdProduct
go


declare @DuplicatedData table (userId varchar(16), eventID int, marketID varchar(50))
insert into @DuplicatedData (userId, eventID, marketID)
values
	('0000000023184216', 28852922, '1.146905665'),
	('0000000024832742', 28852922, '1.146905665'),
	('0000000025404687', 28852922, '1.146905664'),
	('0000000025991371', 28852922, '1.146905664'),
	('0000000025991371', 28852922, '1.146905665'),
	('0000000026514341', 28852922, '1.146905664'),
	('0000000026569322', 28852922, '1.146905664'),
	('0000000028249803', 28852922, '1.146905664'),
	('0000000028438768', 28852922, '1.146905664'),
	('0000000028927238', 28852922, '1.146905665'),
	('0000000029266415', 28852922, '1.146905664'),
	('0000000029655535', 28852922, '1.146905664'),
	('0000000029913970', 28852922, '1.146905664'),
	('0000000030955770', 28852922, '1.146905665'),
	('0000000031025885', 28852922, '1.146905664'),
	('0000000031114086', 28852922, '1.146905664'),
	('0000000031233604', 28852922, '1.146905665'),
	('0000000031596128', 28852922, '1.146905666'),
	('0000000031918774', 28852922, '1.146905664'),
	('0000000031945626', 28852922, '1.146905665'),
	('0000000031994604', 28852922, '1.146905664'),
	('0000000031994604', 28852922, '1.146905665'),
	('0000000032168731', 28852922, '1.146905664')

/*
	-- 23 rows with all values = 0
	select s.*
	from dbo.Sum_winloss_Exchange s with (nolock)
		inner join @DuplicatedData d on s.userId = d.userId and s.eventID = d.eventID and s.marketID = d.marketID
	where s.settledDate >= '2018-08-26' and s.settledDate < '2018-08-27'
*/

delete s with (rowlock)
from dbo.Sum_winloss_Exchange s
	inner join @DuplicatedData d on s.userId = d.userId and s.eventID = d.eventID and s.marketID = d.marketID
where s.settledDate >= '2018-08-26' and s.settledDate < '2018-08-27'

-- no need delete bet tickets (Bettrans_Exchange)
-- no need regen SUM data (rpt_BettingByProduct)