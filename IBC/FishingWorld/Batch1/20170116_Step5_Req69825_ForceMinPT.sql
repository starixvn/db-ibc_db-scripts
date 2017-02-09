/*
	Created: Winnie
	Task: Force MinPT for Fishing World [RedmineID: 69825]
	DB: DBCUST/CustDB
	Date: 20170116
*/ 

ALTER PROCEDURE [dbo].[Acc_DynamicCustSetting3rd_09]
	@target VARCHAR(20),
	@CustId INT,	
	@RoleID TINYINT
	,@maxcustid INT
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN	
	IF dbo.f_CheckRepTable('CustPTSetting3rd_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustPTSetting3rd_Member') = 0 RETURN		
	
	DECLARE @Sporttype INT
	SELECT @Sporttype=219
	DECLARE @BitOrder INT
	SELECT @BitOrder= bitmapOrder from ProductStatusProfile WITH(NOLOCK) where SportType=@Sporttype
	DECLARE @MinPT INT
	
	IF(@RoleID=4)
	BEGIN
		SELECT @MinPT= SuperPT
		FROM [dbo].CustPTSetting3rd_Agent cs WITH(NOLOCK)
		WHERE cs.custid=@CustId	AND SportType=@Sporttype
		
		UPDATE cs
		SET cs.MinPT=@MinPT
		FROM CustPTSetting3rd_Agent cs WITH(ROWLOCK,UPDLOCK)
		WHERE cs.custid=@CustId	AND SportType=@Sporttype AND CustID<=@maxcustid
		
		UPDATE m
		SET SuperPT=@MinPT
		FROM CustPTSetting3rd_Member m WITH(ROWLOCK,UPDLOCK)
		INNER JOIN custInfo c WITH(NOLOCK) ON m.CustID=c.custid 
		WHERE c.srecommend=@CustId	AND SportType=@Sporttype AND m. CustID<=@maxcustid
	END
	ELSE IF (@RoleID=3)-- direct master
	BEGIN
		SELECT @MinPT= MasterPT
		FROM [dbo].CustPTSetting3rd_Agent cs WITH(NOLOCK)
		WHERE cs.custid=@CustId	AND SportType=@Sporttype
		
		UPDATE cs
		SET cs.MinPT=@MinPT
		FROM CustPTSetting3rd_Agent cs WITH(ROWLOCK,UPDLOCK)
		WHERE cs.custid=@CustId	AND SportType=@Sporttype AND CustID<=@maxcustid
		
		UPDATE m
		SET MasterPT=@MinPT
		FROM CustPTSetting3rd_Member m WITH(ROWLOCK,UPDLOCK)
		INNER JOIN custInfo c WITH(NOLOCK) ON m.CustID=c.custid 
		WHERE c.mrecommend=@CustId	AND SportType=@Sporttype AND m. CustID<=@maxcustid	
	END	
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
	DECLARE  @RoleID TINYINT,@CustID INT,@max_custid INT
	SELECT @max_custid=xxx
	
	CREATE TABLE #tempcusts (custid INT PRIMARY KEY, roleId INT,isfinished bit default(0))
	INSERT INTO #tempcusts(custid,roleId)
	
	SELECT custid,roleid
	FROM Customer WITH(NOLOCK) WHERE username IN ('S222R','S222HK','S222AH','S222BH','S222CH','S222DH','2EH','S222FH','S222GH','2KH','S222MH','2AH','2BH','2CH','2DH','2LH','2MH','2NH','2PH','2MM'
	,'2YH','2FH','2GH','2MN','2WH','S222JH','2HH','2RM','2NN','2HK','2RR','2JH','S222N','S222ZH','2XX','2WW','2RH','2IH','2QH','2OH','2SH','2AA','2AB','2MP','2HA','2MY','2MQ','2UH','2HB'
	,'MKWRM','SRRMB','SKWRMB','SRARMB','SRH','SRHK','SRMA','SRHKA','SRJ','SRKH','SRHH','SRK','SRHD','SRMC','SRQ','SRHC'
	,'KKM','KKH','KKMA','KKC','KKD','KKE','KKJ','KKN','KKY','KKF','KKG','KKK','KKL','KKI','KKR','KAB','KGK','KGL','KGM','KGN'
	,'SRS','KAD','KGA','KGB','KBA','KBB','KBC','KGE','KBD','KBE','KAG','KAH','KAJ','KAK','KBG','KBH','KBJ','KBK','KBU','KBL','KBV','KBW','KAI'	
	,'HG9','HGG','HG8','HG7','HG6','HG88','HG101','HG102','HG71','HG81','HG29','HA8','H39','HGA','H7','HG3','HGB','HG5'	
	,'D77','D78','D79','D80','D81','D82','D83','D85','D66','DRN','DRP','BB1','D96','BB9'
	,'TS1','TS2','TS3','TS4','TS5','TS6','D99','DRM'
	,'JBK','JBM','JBJ')

	WHILE (1 = 1)
	BEGIN
	UPDATE TOP (1) #tempcusts
	SET isfinished = 1
		,@CustId = custid	
		,@RoleID = RoleId 
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustSetting3rd_09 @Custid = @Custid , @RoleID = @RoleID	,@maxcustid = @max_custid	
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
	END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------

	DECLARE  @RoleID TINYINT,@CustID INT,@max_custid INT
	SELECT @max_custid=xxx
	
	CREATE TABLE #tempcusts (custid INT PRIMARY KEY, roleId INT,isfinished bit default(0))
	INSERT INTO #tempcusts(custid,roleId)	
	SELECT custid,roleid
	FROM Customer WITH(NOLOCK) WHERE username IN ('S222R','S222HK','S222AH','S222BH','S222CH','S222DH','2EH','S222FH','S222GH','2KH','S222MH','2AH','2BH','2CH','2DH','2LH','2MH','2NH','2PH','2MM'
	,'2YH','2FH','2GH','2MN','2WH','S222JH','2HH','2RM','2NN','2HK','2RR','2JH','S222N','S222ZH','2XX','2WW','2RH','2IH','2QH','2OH','2SH','2AA','2AB','2MP','2HA','2MY','2MQ','2UH','2HB'
	,'MKWRM','SRRMB','SKWRMB','SRARMB','SRH','SRHK','SRMA','SRHKA','SRJ','SRKH','SRHH','SRK','SRHD','SRMC','SRQ','SRHC'
	,'KKM','KKH','KKMA','KKC','KKD','KKE','KKJ','KKN','KKY','KKF','KKG','KKK','KKL','KKI','KKR','KAB','KGK','KGL','KGM','KGN'
	,'SRS','KAD','KGA','KGB','KBA','KBB','KBC','KGE','KBD','KBE','KAG','KAH','KAJ','KAK','KBG','KBH','KBJ','KBK','KBU','KBL','KBV','KBW','KAI'	
	,'HG9','HGG','HG8','HG7','HG6','HG88','HG101','HG102','HG71','HG81','HG29','HA8','H39','HGA','H7','HG3','HGB','HG5'	
	,'D77','D78','D79','D80','D81','D82','D83','D85','D66','DRN','DRP','BB1','D96','BB9'
	,'TS1','TS2','TS3','TS4','TS5','TS6','D99','DRM'
	,'JBK','JBM','JBJ')
	
		
	WHILE (1 = 1)
	BEGIN
	UPDATE TOP (1) #tempcusts
	SET isfinished = 1
		,@CustId = custid	
		,@RoleID = RoleId 
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustSetting3rd_09 @Custid = @Custid , @RoleID = @RoleID		,@maxcustid = @max_custid		
			,@target = 'DBCUST'
			
			
	waitfor delay '00:00:0.280'
	END

