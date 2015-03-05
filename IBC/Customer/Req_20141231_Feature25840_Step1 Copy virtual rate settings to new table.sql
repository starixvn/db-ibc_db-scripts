/*
	Created: Johnson
	Date: 2014-12-31
	Task: Virtual Rate - Separate setting into sport types and bet types
	DB: DBTXN/CustDB
	
	Steps:
		RUN BEFORE UM: copy virtual rate settings to new structure

*/  

 -- BEGIN STEP 1: DEPLOY THIS SP @DBTRANS.CustDB ------
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@target		VARCHAR(20)='',
	@srecommend INT,
	@maxcustid	INT	
AS
BEGIN	 
	SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
		
		
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('CustInfo','CustVirtualRate') AND type = 'U'
		) <> 2
	RETURN
	 
	
	INSERT INTO [dbo].[CustVirtualRate]
		   ([custid]
		   ,[sporttype]
		   ,[bettype]
		   ,[isLive]
		   ,[virtualMultiplier])		
	SELECT custid,
		t.sporttype,
		t.bettype,
		b.isLive,
		ci.virtualMultiplier
	FROM CustInfo ci WITH(NOLOCK)
		CROSS APPLY 
		(
		SELECT 1 as sporttype, 1 as bettype
		UNION 
		SELECT 1 as sporttype, 2 as bettype
		UNION 
		SELECT 1 as sporttype, 3 as bettype
		UNION 
		SELECT 1 as sporttype, 7 as bettype
		UNION 
		SELECT 1 as sporttype, 8 as bettype
		UNION 
		SELECT 1 as sporttype, 12 as bettype			
		UNION 
		SELECT 99 as sporttype, 1 as bettype
		UNION 
		SELECT 99 as sporttype, 2 as bettype
		UNION 
		SELECT 99 as sporttype, 3 as bettype
		UNION 
		SELECT 99 as sporttype, 7 as bettype
		UNION 
		SELECT 99 as sporttype, 8 as bettype
		UNION 
		SELECT 99 as sporttype, 12 as bettype 
		UNION 
		SELECT 99 as sporttype, 20 as bettype 
		UNION 
		SELECT 99 as sporttype, 21 as bettype 
		UNION 
		SELECT 99 as sporttype, 154 as bettype 
		UNION 
		SELECT 99 as sporttype, 1301 as bettype 
		UNION 
		SELECT 99 as sporttype, 1311 as bettype 
		UNION 
		SELECT 99 as sporttype, 1324 as bettype 
		) t
		CROSS APPLY (
		SELECT 0 as isLive
		UNION 
		SELECT 1 as isLive
		)b
	WHERE ci.custid <= @maxcustid
		AND ci.srecommend = @srecommend
		AND ci.custid NOT IN (1176092, --member01 : testing account
			16948215 , --Supertestmt01
			16949221 , --Supertestmt02
			16970766 , --Supertestmt03
			16970775 , --Supertestmt04
			17083289 , --supertestuatQ
			17085294 , --supertestuatR
			17098973 , --SupertestCUAT
			17125794 , --Supertestmt00
			17126556 , --Supertestmt001
			16948266 , --Mastertestmt01
			16948704 , --Mastertestmt02
			16969765 , --SUPERTESTMT0100
			16969766 , --SUPERTESTMT0101
			16969775 , --SUPERTESTMT0102
			16970148 , --SUPERTESTMT0200
			16970937 , --SUPERTESTMT0201
			17085242 , --supertestuatQ01
			17085249 , --supertestuatQ02
			17085251 , --supertestuatQ03
			17085296 , --supertestuatR01
			17085298 , --supertestuatR02
			17085299 , --03
			17098989 , --SupertestCUAT01
			17099312 , --SupertestCUAT02
			17125807 , --Mastertestmt00
			17126492 , --Mastertestmt001
			17126497 , --Mastertestmt002
			17134876 , --SUPERTESTMT00100
			17134879 , --SUPERTESTMT00101
			17134885 , --SUPERTESTMT00102
			17142772 , --SUPERTESTMT00105
			98626 , --billma01
			98632 , --IT-TIM
			723883 , --IT-EDDIE
			16948683 , --Agenttestmt01
			16948695 , --Membertestmt01
			16948708 , --Agenttestmt02
			16948716 , --Membertestmt02
			16969811 , --SUPERTESTMT010000
			16969827 , --SUPERTESTMT010001
			16969845 , --SUPERTESTMT010001000
			16969893 , --SUPERTESTMT010001001
			16971332 , --SUPERTESTMT020000001
			16971345 , --SUPERTESTMT020000002
			16972718 , --SUPERTESTMT020000003
			16972803 , --SUPERTESTMT020000004
			16972813 , --SUPERTESTMT020000005
			16970182 , --SUPERTESTMT020000
			16970198 , --SUPERTESTMT020000000
			17085253 , --supertestuatQ0101
			17085256 , --supertestuatQ0101001
			17099298 , --SupertestCUAT0101
			17099302 , --SupertestCUAT0101001
			17099305 , --SupertestCUAT0101002
			17099309 , --SupertestCUAT0102
			17125818 , --Agenttestmt00
			17125823 , --Membertestmt00
			17126502 , --Agenttestmt001
			17126516 , --Membertestmt001
			17134916 , --SUPERTESTMT0010200
			17134948 , --SUPERTESTMT0010201
			17134975 , --SUPERTESTMT0010202
			17135013 , --SUPERTESTMT0010202000
			17141147 , --SUPERTESTMT0010202001
			17141169 , --SUPERTESTMT0010202002
			17142798 , --SUPERTESTMT0010500
			17142807  --SUPERTESTMT0010500000
			)
		AND ci.recommend <> 14228863 --STAFFTWPG
	
END
GO

-- END STEP 1: DEPLOY THIS SP @DBTRANS.CustDB --------
------------------------------------------------------	


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB06/DBTP) -----
--------------------------------------------------------------------------------------
 

CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = xx
INSERT INTO #supers(custid)
SELECT custid
FROM custInfo ci with(nolock) 
where roleid = 4
	AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------

---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
--------------------------------------------------------------------------------------
 

CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = xx

INSERT INTO #supers(custid)
SELECT custid
FROM custInfo ci with(nolock) 
where roleid = 4
	AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBTRANS'
END			
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-----------------------------------------------------------------------------------
