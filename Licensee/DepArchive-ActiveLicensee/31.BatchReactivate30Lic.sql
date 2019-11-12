/*
	Task: Reactivate all dormant members of 30 licensees - https://nexdev.net/issues/109761
			e8Casino 
			DEWA 
			PanguGame
			Lucky88
			818Bet
			Unobet
			Swin
			Brown888
			M8bola
			IGPTech
			ECLBET
			396Club
			NBCbet
			BetStar
			Heaven
			Hengcai88
			Q8bola
			GPIGAME
			DBP
			Taipanbet
			HL8
			Zzun88
			Hecbet
			88Macao
			TGO
			iBet
			Mayayule
			Royal
			Dawoo
			IBO
	Creator: Dominic@20190305
	Run at: CustDB@DBCUST
*/
USE CustDB

CREATE TABLE #Agent(CustID INT)

CREATE TABLE #CustID(CustID INT, IsExecuted BIT)

INSERT INTO #Agent(CustID)
SELECT Recommend
FROM DBCUST.CustDB.dbo.[Dep_Customer_Archived_Config] WITH (NOLOCK)
WHERE Site IN ( 
	'e8Casino ','DEWA ','PanguGame','Lucky88','818Bet','Unobet','Swin','Brown888','M8bola'
	,'IGPTech','ECLBET','396Club','NBCbet','BetStar','Heaven','Hengcai88','Q8bola','GPIGAME'
	,'DBP','Taipanbet','HL8','Zzun88','Hecbet','88Macao','TGO','iBet','Mayayule','Royal','Dawoo','IBO'
)

--84607 rows
INSERT INTO #CustID(CustID,IsExecuted) 
SELECT CustID,0
FROM [dbo].[Dep_Customer_Archived] (NOLOCK)
WHERE Recommend IN (
	SELECT CustID 
	FROM #Agent
) AND Status = 'completed'

CREATE UNIQUE CLUSTERED INDEX IX_Cust ON #CustID(CustID)

DECLARE @CustID INT

WHILE EXISTS(SELECT 1 FROM #CustID WHERE IsExecuted=0)
BEGIN
	UPDATE TOP(1) t
	SET IsExecuted=1
		,@CustID=CustID
	FROM #CustID t
	WHERE IsExecuted=0

	IF NOT EXISTS(SELECT 1 FROM Customer (NOLOCK) WHERE CustID=@CustID)
	BEGIN
		EXEC [Dot_Dep_Customer_Archive_ReactiveCustomer] @CustID  = @CustID
		WAITFOR DELAY '00:00:00.030'
	END
	
END

DROP TABLE #CustID
 
