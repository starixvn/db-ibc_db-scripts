/*<info serverAlias="DBPTCS-bodb_PlaytechCS"></info>*/
/*
	Created: 20240612@Evan
	DB: DBPTCS-bodb_PlaytechCS
	Task: Sync data from DB052 to DB053 - Run this only in DB053
*/

USE bodb_PlaytechCS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION

	TRUNCATE TABLE Product3rd_ResettledBetHistory;
	SET IDENTITY_INSERT Product3rd_ResettledBetHistory ON

	INSERT INTO Product3rd_ResettledBetHistory (Id , SettledDate , UserId , EventId , MarketId , ProductId , CheckInTime , FinishedTime , Status)
	SELECT Id , SettledDate , UserId , EventId , MarketId , ProductId , CheckInTime , FinishedTime , Status
	FROM OPENQUERY(DB052, '
	SELECT Id , SettledDate , UserId , EventId , MarketId , ProductId , CheckInTime , FinishedTime , Status
	FROM bodb_PlaytechCS.dbo.Product3rd_ResettledBetHistory WITH (NOLOCK)
	') AS t

	SET IDENTITY_INSERT Product3rd_ResettledBetHistory OFF

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE();
	ROLLBACK TRANSACTION
END CATCH;

GO