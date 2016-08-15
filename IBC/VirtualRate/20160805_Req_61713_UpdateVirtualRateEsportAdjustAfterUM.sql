/*
	Created: 20160805@Winnie
	Task: Modify Virtual Rate data following new requirements - [Redmine: #61713]
	DB: DBCUST/CustDB
*/
Use CustDB
Go

   -- Member level
    UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid 	
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=1 and islive=0
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=1 and pv.islive=0
   WHERE SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)<>SUBSTRING(bitmapVirtual,   1+((pv.profileID-1)%64), 1)
    
    UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid 
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=1 and islive=1
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=1 and pv.islive=1
    WHERE SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)<>SUBSTRING(bitmapVirtual,   1+((pv.profileID-1)%64), 1)
    
    UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid 	
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=2 and islive=0
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=2 and pv.islive=0
    WHERE SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)<>SUBSTRING(bitmapVirtual,   1+((pv.profileID-1)%64), 1)
    
    UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=2 and islive=1
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=2 and pv.islive=1
    WHERE SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)<>SUBSTRING(bitmapVirtual,   1+((pv.profileID-1)%64), 1)
    
    UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid 	
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=3 and islive=0
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=3 and pv.islive=0
    WHERE SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)<>SUBSTRING(bitmapVirtual,   1+((pv.profileID-1)%64), 1)
    
    UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=3 and islive=1
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=3 and pv.islive=1
   WHERE SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)<>SUBSTRING(bitmapVirtual,   1+((pv.profileID-1)%64), 1)
    
    UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid 
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=20 and islive=0
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=20 and pv.islive=0
   WHERE SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)<>SUBSTRING(bitmapVirtual,   1+((pv.profileID-1)%64), 1)
    
    
    UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid 	
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=20 and islive=1
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=20 and pv.islive=1
    WHERE SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)<>SUBSTRING(bitmapVirtual,   1+((pv.profileID-1)%64), 1)

