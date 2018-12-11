/*
	Created: Vicky
	Task: check and correct data for table ResultDetailES
	DB: DBPRO/bodb02
	Date: 20180912
*/
USE [bodb02]
GO

	SET NOCOUNT ON
	DECLARE @tblData TABLE (matchid INT, finalhomescore VARCHAR(50), finalawayscore VARCHAR(50), creator INT, eventstatus NVARCHAR(50), betstatus  NVARCHAR(50))
	-----------------------------------------------------------------------------------
	
	--get data from table match	
	INSERT INTO @tblData (matchid, finalhomescore, finalawayscore, creator, eventstatus, betstatus)
	SELECT m.matchid, finalhomescore, finalawayscore, creator, eventstatus, betstatus
	FROM dbo.[match] m WITH (NOLOCK)
		INNER JOIN dbo.ResultDetailES rs WITH (NOLOCK) ON rs.matchid = m.matchid AND rs.ResourceID  = '00'
	WHERE sporttype = 43 
		AND (   ISNULL(rs.HomeValue,-1) <> ISNULL(m.finalhomescore,-1)
			 OR ISNULL(rs.AwayValue,-1) <> ISNULL(m.finalawayscore,-1)
			 OR rs.ResultStatusID <> CASE WHEN m.eventstatus = 'completed' THEN 5
									      WHEN m.eventstatus = 'running' AND ResultStatusID IN (0,1,3) THEN ResultStatusID
									      ELSE 0 END
			 OR rs.SettlementStatusID <> CASE WHEN m.eventstatus = 'completed' AND m.betstatus LIKE 'Refund%' THEN 1
			 		       					  WHEN m.eventstatus = 'completed' THEN 4
			 		       					  ELSE 0 END
					
			)
		
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM @tblData)
		RETURN
		

	
	MERGE dbo.ResultDetailES WITH (HOLDLOCK) TARGET
	USING @tblData AS SOURCE ON  TARGET.ResourceId = '00' AND TARGET.MatchId = SOURCE.matchid
	WHEN MATCHED THEN
	
		UPDATE SET HomeValue	= SOURCE.finalhomescore
			,AwayValue			= SOURCE.finalawayscore
			,ResultStatusID 	= CASE WHEN SOURCE.eventstatus = 'completed' THEN 5
									   WHEN SOURCE.eventstatus = 'running' AND ResultStatusID IN (0,1,3) THEN ResultStatusID
									   ELSE 0 END
			,SettlementStatusID = CASE WHEN SOURCE.eventstatus = 'completed' AND SOURCE.betstatus LIKE 'Refund%' THEN 1
								       WHEN SOURCE.eventstatus = 'completed' THEN 4
								       ELSE 0 END
			,LastModifyDate		= GETDATE()
	
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (MatchId, ResourceId, HomeValue, AwayValue, ResultStatusID, SettlementStatusID, CreateDate, LastModifyDate, CreateBy, LastModifyBy)
		VALUES(SOURCE.matchid, '00', SOURCE.finalhomescore, SOURCE.finalawayscore
				,CASE WHEN SOURCE.eventstatus = 'completed' THEN 5 ELSE 0 END
				,CASE WHEN SOURCE.eventstatus = 'completed' AND SOURCE.betstatus LIKE 'Refund%' THEN 1
				      WHEN SOURCE.eventstatus = 'completed' THEN 4
				      ELSE 0 END
				, GETDATE(), GETDATE(), SOURCE.creator, SOURCE.creator);
	
