/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220613@Percy
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
(11,'16a0eca5-82c1-43a6-6502-08da32f2a619',52,392520,'tohiep90',51,3,'Bwing_392520','2022-05-27 2:12:54','2022-05-27 2:13:03',368421,368421,-368421,0,0,0,1,2,NULL,0,'2022-06-13 7:15:56',0,'2022-05-27'),
(11,'1c9b4a10-120c-4778-0eaf-08da32f2a5b0',52,809932,'Phatloc8668',51,3,'Bwing_809932','2022-05-26 2:11:12','2022-05-26 2:11:22',5000,5000,-5000,0,0,0,1,2,NULL,0,'2022-06-13 7:15:56',0,'2022-05-26'),
(11,'3fd1300e-ea8d-4b63-8e6c-08da32f2fc4f',52,636184,'Doankuan',51,3,'Bwing_636184','2022-05-27 2:12:56','2022-05-27 2:13:03',40000,40000,80000,0,0,0,1,1,NULL,0,'2022-06-13 7:15:56',0,'2022-05-27'),
(11,'57440938-1ad1-40df-0897-08da32f2a686',52,797181,'Dunglao',51,3,'Bwing_797181','2022-05-28 2:14:23','2022-05-28 2:14:29',2000000,2000000,-2000000,0,0,0,1,2,NULL,0,'2022-06-13 7:15:56',0,'2022-05-28'),
(11,'768f8410-1dc8-4499-4a0f-08da32f2fbe8',52,809932,'Phatloc8668',51,3,'Bwing_809932','2022-05-26 2:11:09','2022-05-26 2:11:22',5000,5000,-5000,0,0,0,1,2,NULL,0,'2022-06-13 7:15:56',0,'2022-05-26'),
(11,'77a4fde6-93c2-40a7-8e2a-08da32f2fc4f',52,636184,'Doankuan',51,3,'Bwing_636184','2022-05-27 2:12:54','2022-05-27 2:13:03',35000,35000,-35000,0,0,0,1,2,NULL,0,'2022-06-13 7:15:56',0,'2022-05-27'),
(11,'809aa98d-93b2-4021-17bc-08da32f2fd14',52,392520,'tohiep90',51,3,'Bwing_392520','2022-05-27 2:12:18','2022-05-27 2:12:31',368421,368421,-368421,0,0,0,1,2,NULL,0,'2022-06-13 7:15:56',0,'2022-05-27'),
(11,'b5b5f1c7-438f-43c6-0e47-08da32f2a5b0',52,809932,'Phatloc8668',51,3,'Bwing_809932','2022-05-26 2:11:10','2022-05-26 2:11:22',5000,5000,-5000,0,0,0,1,2,NULL,0,'2022-06-13 7:15:56',0,'2022-05-26'),
(11,'b94ccbb7-f0fc-444a-0fc0-08da32f2a5b0',52,809932,'Phatloc8668',51,3,'Bwing_809932','2022-05-26 2:11:14','2022-05-26 2:11:22',5000,5000,-5000,0,0,0,1,2,NULL,0,'2022-06-13 7:15:56',0,'2022-05-26')
GO

-- Resum data
EXEC dbo.Task_N88_SumWinloss @WinlostDate = '2022-05-26'
EXEC dbo.Task_N88_SumWinloss @WinlostDate = '2022-05-27'
EXEC dbo.Task_N88_SumWinloss @WinlostDate = '2022-05-28'
GO