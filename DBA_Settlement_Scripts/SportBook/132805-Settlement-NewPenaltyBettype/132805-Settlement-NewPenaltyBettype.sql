
/*
	Created by: Kathy
	Date: 20200428
	Task: Insert new bettype [#132805]
	DB: DBTXN/bodb02
*/
declare @order int

select @order = OrdNo
from dbo.SettlementSpecialBettypeProfile with(NOLOCK)
where bettype = 391

-- the order of new bettype 376 is between bettype 393 and 391
update SettlementSpecialBettypeProfile with(rowlock, updlock)
	set OrdNo = OrdNo + 1
where bettype in (391, 387,386,390)

insert into SettlementSpecialBettypeProfile (pfID, SportType, BetType, BetID, ResourceID, SettleType, GroupType, OrdNo, RoundID, OddsType)
values (376, 1, 376, 0, 376, 'EAR', 'SP', @order, 0, 1)
