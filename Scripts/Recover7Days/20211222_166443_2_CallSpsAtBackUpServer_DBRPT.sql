/*<info serverAlias="DBACC-bodb02"></info>*/

/*
Create: 20221220@Sophia
Task: Call SPs Regen Data at back up servers [Redmine: #166443] 
DB: DBACC-bodb02

*/ 
 
----@stepNo = 4
---DB06 --DBRPT
 USE bodb_report 
 GO
	    
 
 DECLARE   
	 @AffectedList	VARCHAR(MAX) = '<root><r c="33655935" w="2021-12-15T00:00:00"/><r c="53634893" w="2021-12-15T00:00:00"/><r c="56475760" w="2021-12-14T00:00:00"/><r c="56475760" w="2021-12-15T00:00:00"/><r c="58703902" w="2021-12-15T00:00:00"/></root>'
	, @errmsg		VARCHAR(1000) = ''   
	,@BetTypes		VARCHAR(1000) = ''   
	,@GenerateData  BIT= 0
	,@result	BIT = 0
  
	DECLARE @inputList TABLE (custid INT, winlostdate DATETIME, isDone BIT)
	-- parse @affectedList to get list of winlostdate or custid
	-- in case of group execution combine the affected list & remove duplicate value
	-- loop for each custid/winlostdate
	DECLARE @XmlData XML,
			@winlostdate DATETIME,
			@custID INT,
			@custIDs VARCHAR(MAX) = ''

	IF @AffectedList IS NOT NULL --- most of case run instantly tasks
	BEGIN 
		SET @XmlData  = @AffectedList

		INSERT INTO @inputList(custid,winlostdate,isDone)
		SELECT	t.c.value('@c', 'INT')			AS CustId,
				t.c.value('@w', 'SMALLDATETIME')	AS WinlostDate,
				0 AS isDone
		FROM @XmlData.nodes('root/r') AS t(c)
		OPTION (OPTIMIZE FOR (@XmlData = NULL))
	END
	 
	 
	BEGIN
		WHILE EXISTS (SELECT 1 FROM @inputList WHERE isDone = 0)
		BEGIN
			--- run by winlostdate & list of custid
			SELECT TOP(1) @winlostdate=winlostdate, 
						  @custIDs=STUFF( ( SELECT ',' + CAST(custid AS VARCHAR(20))
											FROM @inputList s 
											WHERE s.winlostdate = t.winlostdate
											FOR XML PATH ('')),1,1,'')
			FROM @inputList t 
			WHERE isDone = 0
			GROUP BY winlostdate 
			
			
			---begin Loop 				
			EXEC bodb_report.dbo.Task_rptStatement_14
				@WinlostDate = @WinlostDate,
				@CustIds = @CustIds
	
		 
		 	BEGIN TRY			
			EXEC bodb02.dbo.Task_rptWinLost_UpdateTable @winlostdate = @WinlostDate
			END TRY
			BEGIN CATCH
				SET @errmsg = 'step 6.01' + '--' + ERROR_MESSAGE()			
				RAISERROR(@errmsg,16,1)
			END CATCH 
		
			---End loop


			UPDATE @inputList
			SET isDone = 1
			WHERE winlostdate = @winlostdate 
		END  
 END
 