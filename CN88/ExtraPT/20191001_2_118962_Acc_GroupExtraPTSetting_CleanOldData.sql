/*
Create: 20191001@Sophia
Task: Clean data ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss') [redmine: #118962]
DB: DBUCST.CUSTDB
*/


---Clean data ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss')

--SELECT COUNT (*) FROM Acc_GroupExtraPT_Product WITH (NOLOCK) WHERE SubProduct IN ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss')
--SELECT COUNT (*) FROM Acc_GroupExtraPTSetting  WITH (NOLOCK) WHERE SubProduct IN ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss')


--- Acc_GroupExtraPT_Product
delete CustDB.dbo.Acc_GroupExtraPT_Product with (rowlock) where SubProduct in ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss')


-- Acc_GroupExtraPTSetting 
declare @totalSuper		table (SuperId int)
declare @runningSuper	table (SuperId int)

-- 9429 supers with 44368 rows (1 super ~ 4.7 rows)
insert into @totalSuper (SuperId)
select SuperId from CustDB.dbo.Acc_GroupExtraPTSetting with (nolock) where SubProduct in ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss')
group by SuperId

while 1=1
begin
	delete @runningSuper

	delete top (200) @totalSuper output deleted.SuperId into @runningSuper
	
	if @@rowcount = 0
		break;

	delete s with (rowlock)
	from CustDB.dbo.Acc_GroupExtraPTSetting s
		inner join @runningSuper r on s.SuperId = r.SuperId
	where ProductId = 1 and Sporttype = 0 and SubProduct in ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss')
	
	waitfor delay '00:00:00:100'
end
  