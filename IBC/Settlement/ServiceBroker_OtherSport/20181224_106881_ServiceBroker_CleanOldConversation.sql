/*
	Created: 20181224@Helen
	Task: clean old conversation of othersports - https://nexdev.net/issues/106881
	DB: DBLICAPI02/DBTP/DB052/DB053/DB054/DB06/DBLICAPI/DB042
	
*/
USE bodb02
GO
CREATE TABLE #Temp (ID INT IDENTITY (1,1), handle UNIQUEIDENTIFIER)

DECLARE @start INT , @End INT, @handle UNIQUEIDENTIFIER 

INSERT INTO #Temp (handle)
SELECT e.conversation_handle
FROM sys.conversation_endpoints e WITH(NOLOCK)
	INNER JOIN sys.services s WITH(NOLOCK) on e.service_id = s.service_id
WHERE s.name = 'Service_Settlement_OtherSports' AND state = 'DI'
	AND NOT EXISTS (SELECT 1 FROM SB.DialogPool WITH (NOLOCK) 
					WHERE FromService = 'Service_Settlement_OtherSports' 
					AND Handle = e.conversation_handle)
SET @start = 1
SET @End = (SELECT MAX(ID) FROM #Temp)

WHILE @start <= @End
BEGIN
	SET @handle = (SELECT handle FROM #Temp WHERE ID = @start)
	
	IF @handle IS NOT NULL
		END CONVERSATION @handle
	
	SET @start = @start + 1
END
					
DROP TABLE #Temp

GO				