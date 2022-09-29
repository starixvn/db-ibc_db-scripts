/*<info serverAlias="DBPTCS-bodb_PlaytechCS"></info>*/
/*
	Created: 20220919@Sol
	DB: DBPTCS-bodb_PlaytechCS
	Task: Sync data from DB53 to DB052 - Run this only in DB052
*/

USE bodb_PlaytechCS

GO

---get data from DB052 into temp table
SELECT Id,SettledDate,UserId,EventId,MarketId,ProductId,CheckInTime,FinishedTime,Status
	INTO #his_db053
FROM DB053.bodb_PlaytechCS.dbo.Product3rd_ResettledBetHistory AS his
WHERE his.ProductID = 31
	AND his.settleddate >= '2022-03-01 13:25:01.000'
	AND his.settleddate <= '2022-07-31 11:28:26'

--- sync data from db053 to db052 from mar to july
UPDATE his_db052 WITH (ROWLOCK, UPDLOCK)
	SET his_db052.Status = his_db053.Status,
		his_db052.FinishedTime = his_db053.FinishedTime
FROM Product3rd_ResettledBetHistory AS his_db052
	INNER JOIN #his_db053 AS his_db053
		ON his_db052.Id = his_db053.Id
			AND his_db052.SettledDate = his_db053.SettledDate
			AND his_db052.UserId = his_db053.UserId
			AND his_db052.EventId = his_db053.EventId
			AND his_db052.MarketId = his_db053.MarketId
WHERE his_db052.ProductID = 31
	AND his_db052.settleddate >= '2022-03-01 13:25:01.000'
	AND his_db052.settleddate <= '2022-07-31 11:28:26'
	AND his_db052.Status = 'waiting'

GO 

--- update data in Aug
DECLARE @currTime DATETIME = GETDATE()
UPDATE Product3rd_ResettledBetHistory WITH (ROWLOCK, UPDLOCK)
	SET Status = 'Completed',
		FinishedTime = @currTime
WHERE ProductID = 31
	AND settleddate >= '2022-08-01'
	AND settleddate < '2022-09-01'
	AND Status = 'waiting'
	
GO