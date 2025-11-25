/*<info serverAlias="DBEXT-bodb02,DBBAH-bodb02"></info>*/
/*
	Created: 20251010@Tacy	
	Task: Drop unused SPs [RedmineId : 241348]
	DB: DBEXT-bodb02,DBBAH-bodb02
*/

/*
	* DBEXT-bodb02:
					DEL_Lrf_AmendmentTicketListingSel
					DEL_Lrf_BetList_Licensee_Others
					DEL_Lrf_BetList_Licensee_Sportsbook

	* DBBAH-bodb02:
					DEL_Lrf_BetList_SelWinlossHR
					DEL_Lrf_BetList_SelWinlossLiveCasino
*/
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE bodb02
GO

DECLARE @_sp VARCHAR(100), @SQL NVARCHAR(1000)

CREATE TABLE #tmpPROCEDURE (SP_Name VARCHAR(100))

IF @@SERVERNAME IN ('DB052','DB053','SITDB052') --> DBEXT
BEGIN
	INSERT INTO #tmpPROCEDURE (SP_Name)
	SELECT [name] FROM sys.objects 
	WHERE [type] = 'P' AND 
	-- Original
		(  [name] = 'DEL_Lrf_AmendmentTicketListingSel'
		OR [name] = 'DEL_Lrf_BetList_Licensee_Others'
		OR [name] = 'DEL_Lrf_BetList_Licensee_Sportsbook'

		OR [name] = 'DEL_Lrf_AmendmentTicketListingSel_xpre'
		OR [name] = 'DEL_Lrf_BetList_Licensee_Others_xpre'
		OR [name] = 'DEL_Lrf_BetList_Licensee_Sportsbook_xpre'

		OR [name] = 'DEL_Lrf_AmendmentTicketListingSel_xtest'
		OR [name] = 'DEL_Lrf_BetList_Licensee_Others_xtest'
		OR [name] = 'DEL_Lrf_BetList_Licensee_Sportsbook_xtest'

		OR [name] LIKE 'DEL_Lrf_AmendmentTicketListingSel_UAT%'
		OR [name] LIKE 'DEL_Lrf_BetList_Licensee_Others_UAT%'
		OR [name] LIKE 'DEL_Lrf_BetList_Licensee_Sportsbook_UAT%'
	)
END
ELSE --> DBBAH
BEGIN
	INSERT INTO #tmpPROCEDURE (SP_Name)
	SELECT [name] FROM sys.objects 
	WHERE [type] = 'P' AND 
	-- Original
		(  [name] = 'DEL_Lrf_BetList_SelWinlossHR'
		OR [name] = 'DEL_Lrf_BetList_SelWinlossLiveCasino'

		OR [name] = 'DEL_Lrf_BetList_SelWinlossHR_xpre'
		OR [name] = 'DEL_Lrf_BetList_SelWinlossLiveCasino_xpre'

		OR [name] = 'DEL_Lrf_BetList_SelWinlossHR_xtest'
		OR [name] = 'DEL_Lrf_BetList_SelWinlossLiveCasino_xtest'

		OR [name] LIKE 'DEL_Lrf_BetList_SelWinlossHR_UAT%'
		OR [name] LIKE 'DEL_Lrf_BetList_SelWinlossLiveCasino_UAT%'
	)
END

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @cnt INT

SELECT @cnt=COUNT(1) FROM #tmpPROCEDURE

DECLARE @msg_total nvarchar(200) = @@SERVERNAME + ' - The total of the proc will be deleted: %d.'

PRINT ('===============================================================')
RAISERROR (@msg_total, 0, 1, @cnt) WITH NOWAIT
PRINT ('===============================================================')

WHILE EXISTS (SELECT TOP 1 1 FROM #tmpPROCEDURE)
BEGIN
	SELECT TOP 1 @_sp=SP_Name
	FROM #tmpPROCEDURE

	DELETE FROM #tmpPROCEDURE WHERE SP_Name=@_sp

	PRINT @_sp

	SET @SQL = 'DROP PROCEDURE IF EXISTS ' + @_sp 

	EXEC (@SQL)

	SET @SQL = NULL
END

DROP TABLE #tmpPROCEDURE
GO