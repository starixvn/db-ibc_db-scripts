
/*
	Create: 20190401@Sophia
	DB: DBTXN.bodb02

*/

DECLARE  @winlostdate  SMALLDATETIME, @recommend INT

CREATE TABLE #Winlostdate (ID INT, Winlostdate SMALLDATETIME)
CREATE TABLE #recommend (ID INT IDENTITY (1,1), CustID INT )

INSERT INTO #recommend 
SELECT  CustID
FROM CUSTDB.dbo.CustInfo WITH (NOLOCK) 
WHEre srecommend IN (Select CustID FROM CS_CustSuper)

INSERT INTO #Winlostdate (ID, Winlostdate)
EXEC  [Task_MoveBetsDayByScheduleSel] 

select * from #Winlostdate
select * from #recommend

DECLARE @r INT, @w INT 

SELECT @r = MAX(ID) FROM #recommend
SELECT @w = MAX(ID) FROM #Winlostdate

DECLARE @agent_cnt INT
SET @agent_cnt = (SELECT COUNT(*) FROM #recommend )
 
DECLARE @msg nvarchar(200) ='Currently at recommend: %d.'
DECLARE @msg_total nvarchar(200) = 'Total of recommend: %d.'
RAISERROR (@msg_total, 0, 1, @agent_cnt) WITH NOWAIT



WHILE @w >= 1
BEGIN 

	SELECT @winlostdate = Winlostdate from #Winlostdate WHERE ID = @w

	---Copy Event 
	EXEC DBPRO.bodb02.dbo.Task_DailySummary_DB02_Copy @winlostdate = @winlostdate


		--- Copy betrans to bettrans14

		WHILE @r >= 1
		BEGIN 
		
			SELECT @recommend = CustId from #recommend WHERE ID = @r
		
			EXEC dbo.ExecRep_08 @recommend =  @recommend, @winlostdate = @winlostdate, @parlay = 1			
			
			  
			RAISERROR (@msg, 0, 1, @agent_cnt) WITH NOWAIT 

			Select @r = @r - 1 
		END


	Select @w = @w - 1 
	SELECT @r = MAX(ID) FROM #recommend

END 

DROP TABLE #recommend
DROP TABLE #Winlostdate