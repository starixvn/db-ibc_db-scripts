/*
	Task: Insert VRCustSetting - Redmine: 114830
		Step 1: Prepare LevelID
		Step 2: Insert setting at sport level
		Step 3: Insert setting at bettype group level
	Creator: Dominic@20190718
	Run at: CustDB@DBCUST 
*/
USE CustDB
GO
	--Step 1: Prepare LevelID
		DECLARE @SportLevel INT = 1

		--bettype group level ID
		SELECT LevelID,VRBetTypeGroupID
		INTO #LevelID_BettypeGroup
		FROM VRSettingHierarchy (NOLOCK) WHERE VRBetTypeGroupID IN (
							1	--Handicap
							,2	--Odd/Even
							,3	--Over/Under
							,4	--Moneyline
					)
		AND BetType = -1
		AND SportType = 43

	--Step 2: Insert setting at sport level
		INSERT INTO [dbo].[VRCustSetting]
			   ([CustID]
			   ,[LevelID]
			   ,[ValueIDLIVE]
			   ,[ValueIDNonLIVE])
		SELECT t.CustID, @SportLevel
				, t.VRValue_121, t.VRValue_121
		FROM EsportVR_Temp t
		WHERE t.HasSameVR = 1

	--Step 3: Insert setting at bettype group level
		INSERT INTO [dbo].[VRCustSetting]
			   ([CustID]
			   ,[LevelID]
			   ,[ValueIDNonLIVE]
			   ,[ValueIDLIVE])
		SELECT	t.CustID
				, h.LevelID --Bettype Group Level
				, CASE WHEN h.VRBetTypeGroupID = 1 THEN t.VRValue_121
						WHEN h.VRBetTypeGroupID = 2 THEN t.VRValue_123
						WHEN h.VRBetTypeGroupID = 3 THEN t.VRValue_125
						WHEN h.VRBetTypeGroupID = 4 THEN t.VRValue_127
					END
				, CASE WHEN h.VRBetTypeGroupID = 1 THEN t.VRValue_122
						WHEN h.VRBetTypeGroupID = 2 THEN t.VRValue_124
						WHEN h.VRBetTypeGroupID = 3 THEN t.VRValue_126
						WHEN h.VRBetTypeGroupID = 4 THEN t.VRValue_128
					END
		FROM EsportVR_Temp t
		CROSS JOIN #LevelID_BettypeGroup h
		WHERE t.HasSameVR = 0