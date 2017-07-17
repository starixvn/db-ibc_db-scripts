/*
	Created: 20170616@Johnson
	Task : Sync Gold Deluxe setting for THAUS headline
	DB:  DBCUST/CustDB
*/

USE CustDB
GO

SELECT ca.custid 
INTO #super
FROM custAccount ca with (Nolock)
	INNER JOIN custInfo ci with (Nolock) on ci.custid = ca.custid
WHERE groupID = 515 AND roleid = 4

SELECT DISTINCT s.custid, 0 AS IsFinished
INTO #UnSyncSuper
FROM custInfo ci WITH (NOLOCK) 
	INNER JOIN #super s ON ci.srecommend = s.custid
WHERE ci.HideGoldDeluxe = 1

DECLARE	@CustID INT,	
    @v255discount_1701 SMALLMONEY 
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #UnSyncSuper
	SET isfinished = 1
		,@CustID = custid			
	WHERE isfinished = 0

	IF @@ROWCOUNT = 0 BREAK
	
	--Correct pt setting for un-sync masters/agents 
	--correct comm for masters/agents on un-sync members
	--correct winlimit for masters/agents/members un-sync
	--correct stake level for masters/agents/members un-sync
	EXEC Acc_CustSetting3rd_19 @custid = @custid
	
	--correct pt on member level
	--u = (i3 or i1)?(u3 or u1)
    --s1 = min(s4-m1-a1, u)
    EXEC dbo.Acc_CustSetting3rd_07 
		@srecommend = @custid 
		,@roleid = 4
		,@mode = 'GoldDeluxe'
		,@sporttype = 255
		,@bettype = 1701
    
	--corrrect s1/m1/a1 by min/auto rules
	EXEC [Acc_CustSetting3rd_04] 
		@srecommend = @custid
		,@roleid = 4
		,@mode = 'GoldDeluxe'
		,@sporttype = 255
		,@bettype = 1701
	
	--get current comm setting of super 
	SELECT @v255discount_1701 = sdiscount
	FROM CustSettingGame WITH(NOLOCK)
	WHERE custid = @custid 
		AND sporttype = 255
		AND bettype = 1701
		
	--correct comm setting on member level
	EXEC Acc_CustSetting3rd_06
			@CustId				= @custid,
			@RoleId				= 4,
			@Discount			= @v255discount_1701,
			@mode				= 'GoldDeluxe',
			@Sporttype			= 255,
			@Bettype			= 1701
	
	WAITFOR DELAY '00:00:0.280'
END
GO



	
	
	