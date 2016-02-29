/*
	Created: 20160229@Billy
	Task: Arrange DB Structure for Targeted Margin Management [Redmine: #53086]
	DB: DBTGRS\bodb_TGRS
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBTGRS\bodb_TGRS	--
----------------------------------------------------------

-- Save current settings --
SELECT	tm.BetType, tm.Rate
INTO	#TargetedMargin
FROM	dbo.TargetedMargin AS tm WITH (NOLOCK)
GO

-- Add new column ShiftId --
ALTER TABLE	dbo.TargetedMargin 
			ADD	WorkShift	TINYINT		NULL

ALTER TABLE	dbo.TargetedMargin_History
			ADD	WorkShift	TINYINT		NULL
GO

-- Update and initial new data --
UPDATE	tm
SET		tm.WorkShift = 1
FROM	dbo.TargetedMargin AS tm

UPDATE	tmh
SET		tmh.WorkShift = 1
FROM	dbo.TargetedMargin_History AS tmh

INSERT INTO	TargetedMargin
	(	BetType, Rate, WorkShift)
SELECT	tm.BetType, tm.Rate, s.WorkShift
FROM		#TargetedMargin AS tm
CROSS APPLY	(
	SELECT 2
	UNION ALL
	SELECT 3
) s(WorkShift)
GO
