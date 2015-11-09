/*
	CREATEd by: Helen
	CREATEd Date: 20151007
	Description: DCS - #5 - CREATE Trigger on replicated table to insert data into DCS History tables
	
	Database: DBTP/bodb02 (local dev: server232 -   local test: server234)
	
*/

USE bodb02
GO

CREATE TRIGGER [dbo].[CustPTSetting3rd_Member_update] ON [dbo].[CustPTSetting3rd_Member] AFTER UPDATE
AS
/*
	Created by: 20151029@Helen
	Task: Trigger for updating [CustPTSetting3rd_Member] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[CustPTSetting3rd_Member_History] (
		[CustID],
		[SportType],
		[BetType],
		[IsLive] ,
		[SuperPT],
		[MasterPT],
		[AgentPT],
		[IsAutoMasterPT],
		[AutoMasterPT],
		[IsAutoSuperPT],
		[AutoSuperPT]
	)
	SELECT
		[CustID],
		[SportType],
		[BetType],
		[IsLive] ,
		[SuperPT],
		[MasterPT],
		[AgentPT],
		[IsAutoMasterPT],
		[AutoMasterPT],
		[IsAutoSuperPT],
		[AutoSuperPT]
	
	FROM [DELETED]
END

GO


CREATE TRIGGER [dbo].[CustPTSetting3rd_Agent_update] ON [dbo].[CustPTSetting3rd_Agent] AFTER UPDATE
AS
/*
	Created by: 20151029@Helen
	Task: Trigger for updating [CustPTSetting3rd_Agent] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[CustPTSetting3rd_Agent_History] (
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[IsLive] ,
		[SuperPT] ,
		[MasterPT] ,
		[AgentPT] ,
		[IsAutoMasterPT] ,
		[AutoMasterPT] ,
		[IsAutoSuperPT] ,
		[AutoSuperPT] ,
		[MinPT] ,
		[MaxPT] 
	)
	SELECT
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[IsLive] ,
		[SuperPT] ,
		[MasterPT] ,
		[AgentPT] ,
		[IsAutoMasterPT] ,
		[AutoMasterPT] ,
		[IsAutoSuperPT] ,
		[AutoSuperPT] ,
		[MinPT] ,
		[MaxPT] 
	
	FROM [DELETED]
END

GO

CREATE TRIGGER [dbo].[CustPTGroupSetting3rd_Member_update] ON [dbo].[CustPTGroupSetting3rd_Member] AFTER UPDATE
AS
/*
	Created by: 20151029@Helen
	Task: Trigger for updating [CustPTGroupSetting3rd_Member] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[CustPTGroupSetting3rd_Member_History] (
		[AgentID] ,
		[SportType] ,
		[BetType] ,
		[IsLive] ,
		[SuperPT] ,
		[MasterPT] ,
		[AgentPT] ,
		[IsAutoMasterPT] ,
		[AutoMasterPT] ,
		[IsAutoSuperPT] ,
		[AutoSuperPT]
	)
	SELECT
		[AgentID] ,
		[SportType] ,
		[BetType] ,
		[IsLive] ,
		[SuperPT] ,
		[MasterPT] ,
		[AgentPT] ,
		[IsAutoMasterPT] ,
		[AutoMasterPT] ,
		[IsAutoSuperPT] ,
		[AutoSuperPT]
	
	FROM [DELETED]
END

GO

CREATE TRIGGER [dbo].[CustSettingMode3rd_update] ON [dbo].[CustSettingMode3rd] AFTER UPDATE
AS
/*
	Created by: 20151029@Helen
	Task: Trigger for updating [CustSettingMode3rd] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[CustSettingMode3rd_History] (
		[CustID] ,
		[IsGrouped] 
	)
	SELECT
		[CustID] ,
		[IsGrouped]
	FROM [DELETED]
END

GO


CREATE TRIGGER [dbo].[CustBetSetting3rd_Member_update] ON [dbo].[CustBetSetting3rd_Member] AFTER UPDATE
AS
/*
	Created by: 20151029@Helen
	Task: Trigger for updating [CustBetSetting3rd_Member] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[CustBetSetting3rd_Member_History] (
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[MinBet],
		[MaxBet],
		[MaxPerMatch]
	)
	SELECT
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[MinBet],
		[MaxBet],
		[MaxPerMatch]
	FROM [DELETED]
END

GO


CREATE TRIGGER [dbo].[CustBetSetting3rd_Agent_update] ON [dbo].[CustBetSetting3rd_Agent] AFTER UPDATE
AS
/*
	Created by: 20151029@Helen
	Task: Trigger for updating [CustBetSetting3rd_Agent] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[CustBetSetting3rd_Agent_History] (
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[MinBet] ,
		[MaxBet] ,
		[MaxPerMatch]
	)
	SELECT
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[MinBet] ,
		[MaxBet] ,
		[MaxPerMatch]
	FROM [DELETED]
END

GO

CREATE TRIGGER [dbo].[CustDiscount3rd_Member_update] ON [dbo].[CustDiscount3rd_Member] AFTER UPDATE
AS
/*
	Created by: 20151029@Helen
	Task: Trigger for updating [CustDiscount3rd_Member] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[CustDiscount3rd_Member_History] (
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[PlayerDiscount] ,
		[AgentDiscount] ,
		[MasterDiscount] ,
		[SuperDiscount] 
	)
	SELECT
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[PlayerDiscount] ,
		[AgentDiscount] ,
		[MasterDiscount] ,
		[SuperDiscount] 
	FROM [DELETED]
END

GO
--------------------- on going
CREATE TRIGGER [dbo].[CustDiscount3rd_Agent_update] ON [dbo].[CustDiscount3rd_Agent] AFTER UPDATE
AS
/*
	Created by: 20151029@Helen
	Task: Trigger for updating [CustDiscount3rd_Agent] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[CustDiscount3rd_Agent_History] (
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[Discount] 
	)
	SELECT
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[Discount] 
	FROM [DELETED]
END

GO

CREATE TRIGGER [dbo].[CustProductStatus_update] ON [dbo].[CustProductStatus] AFTER UPDATE
AS
/*
	Created by: 20151029@Helen
	Task: Trigger for updating [CustProductStatus] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[CustProductStatus_History] (
		[CustID] ,
		[bitmapHasSynced] ,
		[bitmapIsHidden] ,
		[bitmapIsDisabled] 
	)
	SELECT
		[CustID] ,
		[bitmapHasSynced] ,
		[bitmapIsHidden] ,
		[bitmapIsDisabled] 
	FROM [DELETED]
END
GO

CREATE TRIGGER [dbo].[AgentCommRate_update] ON [dbo].[AgentCommRate] AFTER UPDATE
AS
/*
	Created by: 20151029@Helen
	Task: Trigger for updating [AgentCommRate] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[AgentCommRate_History] (
		[CustId],
		[Sporttype],
		[Bettype],
		[CommRate])
	SELECT
		[CustId],
		[Sporttype],
		[Bettype],
		[CommRate]
	FROM [DELETED]
END

GO


CREATE TRIGGER [dbo].[CustCommRate_update] ON [dbo].[CustCommRate] AFTER UPDATE
AS
/*
	Created by: 20151029@Helen
	Task: Trigger for updating [CustCommRate] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[CustCommRate_History] (
		[CustId],
		[Sporttype] ,
		[Bettype],
		[sdiscount],
		[adiscount],
		[discount],
		[playerdiscount] 
	)
	SELECT
		[CustId],
		[Sporttype] ,
		[Bettype],
		[sdiscount],
		[adiscount],
		[discount],
		[playerdiscount] 
	FROM [DELETED]
END

