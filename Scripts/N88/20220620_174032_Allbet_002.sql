/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220620@Percy
	DB: DBN88-bodb_N88
	Task: Manually correct data due to datasouce fixed
*/
USE bodb_N88
GO

-- Insert raw data
INSERT INTO dbo.TpBetRecord (
	TpId,TransId,GameType,CustId,UserName,CurrencyId,SiteId,TpUserName,TransTime,SettledTime,Stake,ValidBet,WinlostAmount
	,Revenue,ProgressiveBet,ProgressiveWin,SettlementType,TicketStatus,OriginalState,TicketKey,CreateTime,BonusId,WinlostDate
)
VALUES
(12,'3906620012038372',6,10737,'GundamX',4,1,'nova88_10737nov','2022-05-19 17:13:32','2022-05-19 17:14:01',1004,1004,1004,0,0,0,1,1,NULL,0,'2022-06-20 06:42:58',0,'2022-05-19')
GO

-- Resum data
EXEC dbo.Task_N88_SumWinloss @WinlostDate = '2022-05-19'
GO