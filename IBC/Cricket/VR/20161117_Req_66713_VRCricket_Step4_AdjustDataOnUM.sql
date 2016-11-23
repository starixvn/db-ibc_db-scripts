		
	DECLARE @profile_1x2_Live			INT,
			@profile_1x2_NonLive		INT,
			@profile_MoneyLine_Live		INT,
			@profile_MoneyLine_NonLive	INT,
			@max_custid					INT
	
	CREATE TABLE #tempCustVirtualSetting(
	[custid] [int] NOT NULL,
	[seqNo] [tinyint] NOT NULL,
	[bitmapVirtual] [binary](64) NOT NULL)		
			
	SELECT @profile_1x2_Live=129,@profile_1x2_NonLive=130
	
	SELECT @profile_MoneyLine_Live= ProfileID 
	FROM ProfileVirtualSetting WITH(NOLOCK) WHERE sporttype=27 AND bettype=20 and islive=1
	
	SELECT @profile_MoneyLine_NonLive= ProfileID 
	FROM ProfileVirtualSetting WITH(NOLOCK) WHERE sporttype=27 AND bettype=20 and islive=0
	
	INSERT INTO #tempCustVirtualSetting(custid,[seqNo],[bitmapVirtual])
	SELECT ci.Custid,3,
	CONVERT(binary(64), STUFF(
	CONVERT(binary(64), STUFF(0x64646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464, 1+((@profile_1x2_Live-1)%64), 1, SUBSTRING(cvs2.bitmapVirtual,   1+((@profile_MoneyLine_Live-1)%64), 1)))
	,1+((@profile_1x2_NonLive-1)%64), 1,SUBSTRING(cvs2.bitmapVirtual,   1+((@profile_MoneyLine_NonLive-1)%64), 1)))
	
	FROM custInfo ci WITH(NOLOCK)
	INNER JOIN CustVirtualSetting    AS cvs2 WITH (NOLOCK) ON	ci.custid = cvs2.custid   AND cvs2.seqNo=2
	INNER JOIN CustVirtualSetting    AS cvs3 WITH (NOLOCK) ON	ci.custid = cvs3.custid   AND cvs3.seqNo=3
	WHERE (SUBSTRING(cvs2.bitmapVirtual,   1+((@profile_MoneyLine_NonLive-1)%64), 1) <> SUBSTRING(cvs3.bitmapVirtual,   1+((@profile_1x2_NonLive-1)%64), 1)
	OR  SUBSTRING(cvs2.bitmapVirtual,   1+((@profile_MoneyLine_Live-1)%64), 1) <> SUBSTRING(cvs3.bitmapVirtual,   1+((@profile_1x2_Live-1)%64), 1))
	AND ci.custid<=@max_custid
	
	UPDATE cvs WITH(ROWLOCK,UPDLOCK)
	SET cvs.[bitmapVirtual]=t.[bitmapVirtual]
	FROM CustVirtualSetting cvs
	INNER JOIN #tempCustVirtualSetting t ON cvs.custid=t.custid AND cvs.seqno=t.seqNo