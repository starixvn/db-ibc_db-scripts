/*
	Created: Winnie
	Date: 2016-11-21
	Task: Insert VR settings for Cricket on UM
	DB: DBCUST/CustDB 
*/ 

------------------------------------------------------
	
	DECLARE @profile_1x2_Live			INT,
			@profile_1x2_NonLive		INT,
			@profile_MoneyLine_Live		INT,
			@profile_MoneyLine_NonLive	INT,
			@max_custid					INT
			
	SELECT @profile_1x2_Live=129,@profile_1x2_NonLive=130,@max_custid=xx
	
	SELECT @profile_MoneyLine_Live= ProfileID 
	FROM ProfileVirtualSetting WITH(NOLOCK) WHERE sporttype=27 AND bettype=20 and islive=1
	
	SELECT @profile_MoneyLine_NonLive= ProfileID 
	FROM ProfileVirtualSetting WITH(NOLOCK) WHERE sporttype=27 AND bettype=20 and islive=0
	
	INSERT INTO CustVirtualSetting([custid],[seqNo],[bitmapVirtual])
	SELECT cvs.custid,3,
	CONVERT(binary(64), STUFF(
	CONVERT(binary(64), STUFF(0x64646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464, 1+((@profile_1x2_Live-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((@profile_MoneyLine_Live-1)%64), 1)))
	,1+((@profile_1x2_NonLive-1)%64), 1,SUBSTRING(bitmapVirtual,   1+((@profile_MoneyLine_NonLive-1)%64), 1)))
		
	FROM        CustVirtualSetting    AS cvs WITH (NOLOCK) 
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid   
    WHERE cvs.seqNo=2 AND ci.custid>@max_custid 
    
    
   