/*<info serverAlias="DBPRO-bodb02" executers="" viewers="vnteam" isFunction="0"></info>*/
USE [bodb02]
GO

ALTER  PROCEDURE [dbo].[Task_Set_SyncDataToResultDetail_ESport]

AS
	/*
		Created: 20181008@Vicky
		Task: Synchronize data for ESport
		DB: DBPRO.bodb02
		
		Revisions:
		
		Parameter's Explanation:
	*/ 
BEGIN
	SET NOCOUNT ON
	DECLARE @deltaTime SMALLINT = 20
	DECLARE @tblData TABLE (matchid INT, finalhomescore VARCHAR(50), finalawayscore VARCHAR(50), creator INT)
	-----------------------------------------------------------------------------------
	
	--get data from table match	
	INSERT INTO @tblData (matchid, finalhomescore, finalawayscore, creator)
	SELECT matchid, finalhomescore, finalawayscore, creator
	FROM dbo.[match] WITH (NOLOCK)
	WHERE sporttype = 43 
		AND DATEDIFF(second, changetime, GETDATE()) <= @deltaTime
		AND eventstatus <> N'completed' 
		

	
	DELETE d
	FROM @tblData d
		INNER JOIN dbo.ResultDetailES rd WITH (NOLOCK) ON rd.matchid = d.matchid
	WHERE rd.ResourceID = '00'
		AND rd.HomeValue = d.finalhomescore
		AND rd.AwayValue = d.finalawayscore
		
		
	IF NOT EXISTS (SELECT TOP 1 1 FROM @tblData)
		RETURN
		
		
	MERGE dbo.ResultDetailES WITH (HOLDLOCK) TARGET
    USING (
        SELECT  sr.matchid, sr.finalhomescore, sr.finalawayscore, sr.creator
        FROM    @tblData sr
        ) AS SOURCE ON  TARGET.ResourceId = '00' AND TARGET.MatchId = SOURCE.matchid
    WHEN MATCHED THEN
    
        UPDATE SET HomeValue     = SOURCE.finalhomescore
            ,AwayValue           = SOURCE.finalawayscore
            ,LastModifyDate      = GETDATE()

    WHEN NOT MATCHED BY TARGET THEN
        INSERT (MatchId, ResourceId, HomeValue, AwayValue, ResultStatusID, SettlementStatusID, CreateDate, LastModifyDate, CreateBy, LastModifyBy)               
        VALUES(SOURCE.matchid, '00', SOURCE.finalhomescore, SOURCE.finalawayscore, 0, 0, GETDATE(), GETDATE(), SOURCE.creator, SOURCE.creator);
	        
END 
GO

	
	
	

	
	
	