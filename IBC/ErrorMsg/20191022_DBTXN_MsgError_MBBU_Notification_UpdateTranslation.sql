use bodb02
go

/*
	Created: 20191022@Percy
	DB: DBTXN.bodb02
	Task: Update MsgError for CT and CS
*/

update dbo.MsgError with (rowlock)
set
	MsgNameCT = N'數據處理進行中，從[mm/dd/yyyy]至[mm/dd/yyyy]之間的餘額資料和數據可能會受影響。預計完成時間為[hh:mm:ss] [mm/dd/yyyy]（GMT+8）。造成任何不便，敬請見諒。'
	,MsgNameCS = N'数据处理进行中，从[mm/dd/yyyy]至[mm/dd/yyyy]之间的余额资料和数据可能会受影响。估计完成时间为[hh:mm:ss] [mm/dd/yyyy]（GMT+8）。造成任何不便，敬请见谅。'
where MsgID = 90011


update dbo.MsgError with (rowlock)
set
	MsgNameCT = N'數據處理進行中，在[mm/dd/yyyy]之間的餘額資料和數據可能會受影響。估計完成時間為[hh:mm:ss] [mm/dd/yyyy]（GMT+8）。造成任何不便，敬請見諒。'
	,MsgNameCS = N'数据处理进行中，在[mm/dd/yyyy]之间的余额资料和数据可能会受影响。估计完成时间为[hh:mm:ss] [mm/dd/yyyy]（GMT+8）。造成任何不便，敬请见谅。'
where MsgID = 90012