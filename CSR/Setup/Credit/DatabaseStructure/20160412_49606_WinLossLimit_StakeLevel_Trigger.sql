/*
	Creator:		20160412@Billy
	Description:	Script to create trigger for xx table
	Database:		DBTP/bodb_CustHistory & DB06/bodb02
*/

-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON DB06/bodb02			 --
---------------------------------------------------------------

USE bodb02
GO

CREATE TRIGGER dbo.CustStakeLevel_Agent_update ON dbo.CustStakeLevel_Agent
AFTER UPDATE
AS
/*
	Created by:	20160412@Billy
	Task:		Trigger for updating [CustStakeLevel_Agent] table 
	DB:			DB06/bodb02

	Revisions: 
	
*/
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	INSERT INTO bodb_CustHistory.dbo.CustStakeLevel_Agent_history 
		(	CustID, SportType, BetType, StakeLevelList)
	SELECT	CustID, SportType, BetType, StakeLevelList
	FROM	Deleted
END 
GO

CREATE TRIGGER dbo.CustStakeLevel_Member_update ON dbo.CustStakeLevel_Member
AFTER UPDATE
AS
/*
	Created by:	20160412@Billy
	Task:		Trigger for updating [CustStakeLevel_Member] table 
	DB:			DB06/bodb02

	Revisions: 
	
*/
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	INSERT INTO bodb_CustHistory.dbo.CustStakeLevel_Member_history
		(	CustID, SportType, BetType, StakeLevelList, LastUpdated)
	SELECT	CustID, SportType, BetType, StakeLevelList, LastUpdated
	FROM	Deleted
END 
GO

CREATE TRIGGER dbo.CustWinLossLimit_Agent_update ON dbo.CustWinLossLimit_Agent
AFTER UPDATE
AS
/*
	Created by:	20160412@Billy
	Task:		Trigger for updating [CustWinLossLimit_Agent] table 
	DB:			DB06/bodb02

	Revisions: 
	
*/
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	INSERT INTO bodb_CustHistory.dbo.CustWinLossLimit_Agent_history
		(	CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT	CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset
	FROM	Deleted
END 
GO

CREATE TRIGGER dbo.CustWinLossLimit_Member_update ON dbo.CustWinLossLimit_Member
AFTER UPDATE
AS
/*
	Created by:	20160412@Billy
	Task:		Trigger for updating [CustWinLossLimit_Member] table 
	DB:			DB06/bodb02

	Revisions: 
	
*/
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	INSERT INTO bodb_CustHistory.dbo.CustWinLossLimit_Member_history
		(	CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT	CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset
	FROM	Deleted
END 
GO



