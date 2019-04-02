USE [bodb02]
GO
CREATE PROCEDURE [dbo].[Acc_ExecRep_03]
	@TransIdList VARCHAR(MAX)
	,@tablename VARCHAR(128)= 'bettrans'
AS
/*
	Created: 20190326@Helen
	Task: Fix Data ticket status consistency among dbs in MNL
	DB: DBTRANS/bodb02
	
*/
BEGIN
	SET NOCOUNT ON
	
	IF @@SERVERNAME NOT IN ('DBTRANS','DB06','DB052','DB053','DBLICAPI') 
		RETURN
		
	DECLARE @TransIdXML XML
	
	SELECT @TransIdXML = @TransIdList
	
	CREATE TABLE #transid (TransID BIGINT PRIMARY KEY,statusID TINYINT,status NVARCHAR(10), checktime DATETIME, creator INT, ruben TINYINT, actual_stake MONEY,statuswinlost TINYINT, winlostdate SMALLDATETIME)
	
	INSERT INTO #transid (transid,statusID,status,checktime,creator,ruben,actual_stake, statuswinlost, winlostdate) 
	SELECT    
			t.c.value('@t','BIGINT') AS TransId,
			t.c.value('@sid','SMALLINT') AS StatusID,
			t.c.value('@s','NVARCHAR(10)') AS Status,
			t.c.value('@c','DATETIME') AS Checktime,
			t.c.value('@cr','INT') AS creator,
			t.c.value('@r','TINYINT') AS ruben,
			t.c.value('@a','MONEY') AS actual_stake,
			t.c.value('@sw','TINYINT') AS statuswinlost,
			t.c.value('@wld','MONEY') AS winlostdate
			
	FROM    @TransIdXML.nodes('/r') t(c)
	
	 -- FOR DEBUG
	 /*
	IF @tablename = 'bettrans'
	BEGIN
		
		SELECT t.StatusID
				,t.status
				,t.Checktime
				,t.creator 
				,t.ruben 
				,CASE WHEN t.statusID = 102 THEN t.actual_stake ELSE b.winlost END AS winlost
			
		FROM bettrans b (NOLOCK)
			INNER JOIN #transid t ON b.transid=t.TransId
	END
	ELSE IF @tablename = 'bettransm'
	BEGIN
		
		SELECT t.StatusID
				,t.status
				,t.Checktime
				,t.creator 
				,t.ruben 
				,t.statuswinlost
				,t.winlostdate
		FROM bettransm b (NOLOCK)
			INNER JOIN #transid t ON b.transid=t.TransId
	END	
	
	*/
	IF @tablename = 'bettrans'
	BEGIN
						
		UPDATE b
			SET statusID	= t.StatusID
				,status		= t.status
				,Checktime	= t.Checktime
				,creator	= t.creator 
				,ruben		= t.ruben 
				,winlost	= CASE WHEN t.statusID = 101 THEN t.actual_stake ELSE b.winlost END
		FROM bettrans b WITH(ROWLOCK)
			INNER JOIN #transid t ON b.transid=t.TransId
	END
	ELSE IF @tablename = 'bettransm'-- bettransm
	BEGIN
		UPDATE b
			SET statusID	= t.StatusID
				,status		= t.status
				,Checktime	= t.Checktime
				,statuswinlost = t.statuswinlost
				,winlostdate = t.winlostdate
		FROM bettransm b WITH(ROWLOCK)
			INNER JOIN #transid t ON b.transid=t.TransId
	END
	
	DROP TABLE #transid
END	



GO


