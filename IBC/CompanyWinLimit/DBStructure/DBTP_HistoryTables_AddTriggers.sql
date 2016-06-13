/*
	Created by: Helen
	Created Date: 20160613
	Description: Company Win Limit Structure - Phase 2 - CREATE Trigger on replicated table to insert data into History tables
	
	Database: DBTP/bodb02 (local dev: server232 -   local test: server234)
	
*/

USE bodb02
GO

CREATE TRIGGER [dbo].[WinLimit_CustSetting_update] ON [dbo].[WinLimit_CustSetting] AFTER UPDATE
AS
/*
	Created by: 20151029@Helen
	Task: Trigger for updating [WinLimit_CustSetting] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[WinLimit_CustSetting_History] (
		[CustID],
		[ProductID],
		[BettypeID],
		[LevelID],
		[MaxWinLimit]
	)
	SELECT
		[CustID],
		[ProductID],
		[BettypeID],
		[LevelID],
		[MaxWinLimit]
	
	FROM [DELETED]
END

GO
