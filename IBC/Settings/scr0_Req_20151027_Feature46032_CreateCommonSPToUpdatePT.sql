 /*
	Created: Johnson
	Date: 2015-10-27
	Task: Adjust min pt for customers list requested
	DB: DBCUST/CUSTDB
 */
 
 ---STEP 0: deploy this sp on DBCUST
 ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
    @custid int,
    @Target VARCHAR(20) = '',
    @minpositiontaking_1 smallmoney = 0,
    @minpositiontaking_2 smallmoney= 0,
    @minpositiontaking_3 smallmoney= 0,
    @minpositiontaking_4 smallmoney= 0,
    @minpositiontaking_5 smallmoney= 0,
    @minpositiontaking_6 smallmoney= 0,
    @minpositiontaking_7 smallmoney= 0,
    @minpositiontaking_8 smallmoney= 0,
    @minpositiontaking_9 smallmoney= 0,
    @minpositiontaking_10 smallmoney= 0,
    @minpositiontaking_9999 smallmoney = 0,
    @minlivepositiontaking_1 smallmoney= 0,
    @minlivepositiontaking_3 smallmoney= 0,
    @minlivepositiontaking_7 smallmoney= 0,
    @minlivepositiontaking_8 smallmoney= 0,
    
    @minv2positiontaking_1 smallmoney= 0,
    @minv2positiontaking_2 smallmoney= 0,
    @minv2positiontaking_3 smallmoney= 0,
    @minv2positiontaking_7 smallmoney= 0,
    @minv2positiontaking_8 smallmoney= 0,
    --@minv2positiontaking_9 smallmoney,
    @minv2positiontaking_20 smallmoney= 0,

    @minv3positiontaking_1 smallmoney= 0,
    @minv3positiontaking_2 smallmoney= 0,
    @minv3positiontaking_3 smallmoney= 0,
    @minv3positiontaking_20 smallmoney= 0,

    @minv5positiontaking_1 smallmoney= 0,
    @minv5positiontaking_2 smallmoney= 0,
    @minv5positiontaking_3 smallmoney= 0,
    @minv5positiontaking_20 smallmoney= 0,
    @minv5positiontaking_9999 smallmoney = 0,

    @minv8positiontaking_1 smallmoney= 0,
    @minv8positiontaking_3 smallmoney= 0,
    @minv8positiontaking_20 smallmoney= 0,

    @minv10positiontaking_1 smallmoney= 0,
    @minv10positiontaking_2 smallmoney= 0,
    @minv10positiontaking_3 smallmoney= 0,
    @minv10positiontaking_20 smallmoney= 0,

    @minv11positiontaking_1 smallmoney= 0,
    @minv11positiontaking_20 smallmoney= 0,

    @minv99positiontaking_1 smallmoney= 0,
    @minv99positiontaking_2 smallmoney= 0,
    @minv99positiontaking_3 smallmoney= 0,
    @minv99positiontaking_9 smallmoney= 0,
    @minv99positiontaking_20 smallmoney= 0,
    
    @minv154positiontaking_20 smallmoney = 0
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
		
	Declare @roleid int, @srecommend int, @mrecommend int, @recommend int
	select @roleid = roleid, @srecommend=srecommend, @mrecommend=mrecommend, @recommend=recommend from customer with (NOLOCK) where custid = @custid
	
	
    Update custoverride with (ROWLOCK, UPDLOCK) set minpositiontaking = b.minpositiontaking, minlivepositiontaking = b.minlivepositiontaking
    from custoverride inner join     
            (
                select         @custid as custid,  1 as sporttype, 1 as bettype, @minpositiontaking_1 as minpositiontaking,  @minlivepositiontaking_1 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 2 as bettype, @minpositiontaking_2 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 3 as bettype, @minpositiontaking_3 as minpositiontaking,  @minlivepositiontaking_3 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 4 as bettype, @minpositiontaking_4 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 5 as bettype, @minpositiontaking_5 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 6 as bettype, @minpositiontaking_6 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 7 as bettype, @minpositiontaking_7 as minpositiontaking,  @minlivepositiontaking_7 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 8 as bettype, @minpositiontaking_8 as minpositiontaking,  @minlivepositiontaking_8 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 9 as bettype, @minpositiontaking_9 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 10 as bettype, @minpositiontaking_10 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 9999 as bettype, @minpositiontaking_9999 as minpositiontaking,  0 as minlivepositiontaking
                
                union all select     @custid as custid,  2 as sporttype, 1 as bettype, @minv2positiontaking_1 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  2 as sporttype, 2 as bettype, @minv2positiontaking_2 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  2 as sporttype, 3 as bettype, @minv2positiontaking_3 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  2 as sporttype, 7 as bettype, @minv2positiontaking_7 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  2 as sporttype, 8 as bettype, @minv2positiontaking_8 as minpositiontaking,  0 as minlivepositiontaking
                --union all select     @custid as custid,  2 as sporttype, 9 as bettype, @minv2positiontaking_9 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  2 as sporttype, 20 as bettype, @minv2positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking

                union all select     @custid as custid,  3 as sporttype, 1 as bettype, @minv3positiontaking_1 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  3 as sporttype, 2 as bettype, @minv3positiontaking_2 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  3 as sporttype, 3 as bettype, @minv3positiontaking_3 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  3 as sporttype, 20 as bettype, @minv3positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking

                union all select     @custid as custid,  5 as sporttype, 1 as bettype, @minv5positiontaking_1 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  5 as sporttype, 2 as bettype, @minv5positiontaking_2 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  5 as sporttype, 3 as bettype, @minv5positiontaking_3 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  5 as sporttype, 20 as bettype, @minv5positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  5 as sporttype, 9999 as bettype, @minv5positiontaking_9999 as minpositiontaking,  0 as minlivepositiontaking

                union all select     @custid as custid,  8 as sporttype, 1 as bettype, @minv8positiontaking_1 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  8 as sporttype, 3 as bettype, @minv8positiontaking_3 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  8 as sporttype, 20 as bettype, @minv8positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking

                union all select     @custid as custid,  10 as sporttype, 1 as bettype, @minv10positiontaking_1 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  10 as sporttype, 2 as bettype, @minv10positiontaking_2 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  10 as sporttype, 3 as bettype, @minv10positiontaking_3 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  10 as sporttype, 20 as bettype, @minv10positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking

                union all select     @custid as custid,  11 as sporttype, 1 as bettype, @minv11positiontaking_1 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  11 as sporttype, 20 as bettype, @minv11positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking

                union all select     @custid as custid,  99 as sporttype, 1 as bettype, @minv99positiontaking_1 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  99 as sporttype, 2 as bettype, @minv99positiontaking_2 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  99 as sporttype, 3 as bettype, @minv99positiontaking_3 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  99 as sporttype, 9 as bettype, @minv99positiontaking_9 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  99 as sporttype, 20 as bettype, @minv99positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking
                
                union all select     @custid as custid,  154 as sporttype, 20 as bettype, @minv154positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking
                
            ) as b on custoverride.custid = b.custid and custoverride.sporttype=b.sporttype and custoverride.bettype = b.bettype
    where custoverride.custid = @custid
		AND b.minpositiontaking > 0 
		AND 1 = case when b.bettype in (1,3,7,8) and b.minlivepositiontaking = 0 THEN 0 ELSE 1 END
		
	
	if @roleid = 2
	BEGIN
		EXEC dbo.Acc_CustSetting_04 @recommend = @recommend, @mrecommend = @mrecommend, @srecommend = @srecommend, @roleid = 2					
	END
	else if @roleid = 3
	BEGIN
		EXEC dbo.Acc_CustSetting_04 @mrecommend = @mrecommend, @srecommend = @srecommend, @roleid = 3					
	END
	else if @roleid= 4 
	BEGIN
		EXEC dbo.Acc_CustSetting_04 @srecommend = @srecommend, @roleid = 4					
	END
	              
END    
    