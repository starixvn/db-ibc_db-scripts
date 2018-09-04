USE [Affiliate_12BET]
GO

/*
	Created: 20180904@Percy
	DB: DBAFF12BET.Affiliate_12BET
	Task: Step 1: Create temp table
*/


-- Last month
EXEC dbo.[Task_Aff_GroupSettingBackup] @Month = 8, @Year = 2018

-- Current month
DECLARE @MonthDate SMALLDATETIME = '2018-09-30'

DELETE dbo.AffGroupHistory WITH (ROWLOCK, UPDLOCK)
WHERE MonthDate = @MonthDate

DELETE dbo.DeductionSettingHistory WITH (ROWLOCK, UPDLOCK)
WHERE MonthDate = @MonthDate

DELETE dbo.CommGroupHistory WITH (ROWLOCK, UPDLOCK)
WHERE MonthDate = @MonthDate

DELETE dbo.GroupSettingHistory WITH (ROWLOCK, UPDLOCK)
WHERE MonthDate = @MonthDate

DELETE dbo.TierSettingHistory WITH (ROWLOCK, UPDLOCK)
WHERE MonthDate = @MonthDate

INSERT INTO dbo.CommGroupHistory (GroupID,MonthDate,GroupName,CreatedDate,Creator,IsDeleted,Description,QMTurnover)
SELECT GroupID,@MonthDate,GroupName,CreatedDate,Creator,IsDeleted,Description,QMTurnover
FROM dbo.CommGroup WITH (NOLOCK)

INSERT INTO dbo.DeductionSettingHistory (GroupID,MonthDate,DeductionID,DeductedPercentage,ProductId)
SELECT GroupID,@MonthDate,DeductionID,DeductedPercentage,ProductId
FROM dbo.DeductionSetting WITH (NOLOCK)

INSERT INTO dbo.GroupSettingHistory (GroupID,SportType,TierID,MonthDate,MinAmount,MaxAmount,MinQM,MaxQM,Commission)
SELECT GroupID,SportType,TierID,@MonthDate,MinAmount,MaxAmount,MinQM,MaxQM,Commission
FROM dbo.GroupSetting WITH (NOLOCK)

INSERT INTO dbo.TierSettingHistory (GroupID,TierID,MonthDate,MinAmount,MaxAmount,MinQM,MaxQM,Commission)
SELECT GroupID,TierID,@MonthDate,MinAmount,MaxAmount,MinQM,MaxQM,Commission
FROM dbo.TierSetting WITH (NOLOCK)

INSERT INTO dbo.AffGroupHistory (AffID,MonthDate,GroupID)
SELECT AffID,@MonthDate,GroupID
FROM AffInfo WITH (NOLOCK)