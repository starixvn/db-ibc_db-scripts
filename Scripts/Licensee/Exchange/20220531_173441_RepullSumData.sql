/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20220531@Percy
	DB: DBLIC-bodb_3rdProduct
	Task: Manually repull Exchange data on 5 Mar 2022 [RedmineID: #173441]
	https://nexdev.net/issues/173441
*/
use bodb_3rdProduct
go

-- 350 rows
insert into dbo.Sum_winloss_Exchange (userId,agentId,eventTypeName,eventName,eventID,marketName,marketID,startTime,settledDate,profitLoss,marketTotal,commission,agentCommission,stakeTotal,resettledDate,CustID,Currency,ExVirtualRate)
select c.userId,c.agentId,c.eventTypeName,c.eventName,c.eventID,c.marketName,c.marketID,c.startTime,c.settledDate,c.profitLoss,c.marketTotal,c.commission,c.agentCommission,c.stakeTotal,c.resettledDate,c.CustID,c.Currency,c.ExVirtualRate
from dbo.Sum_winloss_Exchange_CheckData c with (nolock)
	left join dbo.Sum_winloss_Exchange s with (nolock) on c.userId = s.userId and c.eventID = s.eventID and c.marketID = s.marketID
where s.userId is null
	and c.settledDate >= '2022-03-05'
	and c.settledDate < '2022-03-06'