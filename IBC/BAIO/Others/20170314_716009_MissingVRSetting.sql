/*
	Created: 20170410@Helen
	Task: 
	DB: DBCUST/CUSTDB
*/
USE CUSTDB
GO

CREATE TABLE #Cust_NoVR (CustID INT PRIMARY KEY, roleID INT)

CREATE TABLE #GenerateVirtualSetting (seqNo INT,  bitmap binary(64)     )

INSERT INTO #Cust_NoVR (CustID,roleID)
SELECT  ci.custid, ci.roleid 
FROM CustInfo ci WITH (NOLOCK)
	LEFT JOIN CustVirtualSetting cvs WITH (NOLOCK) ON ci.custid=cvs.custid 
WHERE ci.Enabled=1 AND ci.currency <>20
	  AND cvs.custid IS NULL

-- For super: virtualmultiplier = 0	
DECLARE @virtualmultiplier SMALLMONEY = 0

IF EXISTS (SELECT 1 FROM #Cust_NoVR WHERE roleID = 4)
BEGIN
	
		INSERT INTO #GenerateVirtualSetting
		SELECT seqNo,
		(
			SELECT TOP 1 bitmap
			FROM dbo.f_GenerateVirtualSetting_multiple(0x00, CONVERT(VARCHAR(MAX), virtualXML))
		) AS bitmapVirtual
		FROM (SELECT DISTINCT seqNo	FROM ProfileVirtualSetting WITH(NOLOCK)	) pvs
		CROSS APPLY (
		SELECT (
			SELECT	(	SELECT	ipvs.profileID			AS '@p',
								vr.virtualMultiplier	AS '@v'
						FROM	ProfileVirtualSetting	AS ipvs WITH(NOLOCK)
							CROSS APPLY (SELECT CAST(1.00 AS SMALLMONEY) AS virtualMultiplier
						) vr
						WHERE	ipvs.seqNo = pvs.seqNo
						FOR XML PATH ('r'), 
						TYPE
					)
			FOR XML PATH ('root'), 
			TYPE
		) AS virtualXML
		) p	
		
		INSERT INTO [CustVirtualSetting] (custid, seqNo, bitmapVirtual)	
		SELECT CVR.CustID,VR.seqNo,VR.bitmap
		FROM #Cust_NoVR CVR
			CROSS APPLY (SELECT seqNo,bitmap FROM #GenerateVirtualSetting) AS VR
		WHERE CVR.roleID = 4
END
    
--Virtual rate
INSERT INTO [dbo].[CustVirtualSetting] (custid, seqNo, bitmapVirtual)
SELECT VR.CustID, seqNo, bitmapVirtual
FROM #Cust_NoVR vr
	INNER JOIN custInfo CI WITH (NOLOCK) ON CI.custid = vr.CustID
	INNER JOIN CustVirtualSetting CVR WITH(NOLOCK) ON CVR.custid = CI.srecommend  
WHERE VR.roleID = 3

INSERT INTO [dbo].[CustVirtualSetting] (custid, seqNo, bitmapVirtual)
SELECT VR.CustID, seqNo, bitmapVirtual
FROM #Cust_NoVR vr
	INNER JOIN custInfo CI WITH (NOLOCK) ON CI.custid = vr.CustID
	INNER JOIN CustVirtualSetting CVR WITH(NOLOCK) ON CVR.custid = CI.mrecommend  
WHERE VR.roleID = 2

INSERT INTO [dbo].[CustVirtualSetting] (custid, seqNo, bitmapVirtual)
SELECT VR.CustID, seqNo, bitmapVirtual
FROM #Cust_NoVR vr
	INNER JOIN custInfo CI WITH (NOLOCK) ON CI.custid = vr.CustID
	INNER JOIN CustVirtualSetting CVR WITH(NOLOCK) ON CVR.custid = CI.recommend  
WHERE VR.roleID = 1

----------- UPDATE virtualmultiplier (custInfo) --------------------------------------------
-- Super Level
UPDATE CI
	SET virtualmultiplier =  @virtualmultiplier
FROM custInfo  CI WITH (NOLOCK)
	INNER JOIN #Cust_NoVR VR ON CI.custid = VR.CustID
WHERE CI.roleid = 4	

-- Master Level
UPDATE CI
	SET virtualmultiplier =  VR_CI.virtualmultiplier 
FROM custInfo  CI WITH (NOLOCK)
	INNER JOIN #Cust_NoVR VR ON CI.custid = VR.CustID
	CROSS APPLY (SELECT ISNULL(virtualmultiplier,1) AS virtualmultiplier 
				 FROM CustInfo ci_1 WITH(NOLOCK) 
				 WHERE ci_1.CustID = ci.srecommend
				) AS VR_CI
WHERE CI.roleid = 3

-- Agent Level
UPDATE CI
	SET virtualmultiplier =  VR_CI.virtualmultiplier 
FROM custInfo  CI WITH (NOLOCK)
	INNER JOIN #Cust_NoVR VR ON CI.custid = VR.CustID
	CROSS APPLY (SELECT ISNULL(virtualmultiplier,1) AS virtualmultiplier 
				 FROM CustInfo ci_1 WITH(NOLOCK) 
				 WHERE ci_1.CustID = ci.mrecommend
				) AS VR_CI
WHERE CI.roleid = 2

-- Member Level
UPDATE CI
	SET virtualmultiplier = VR_CI.virtualmultiplier
FROM custInfo  CI WITH (NOLOCK)
	INNER JOIN #Cust_NoVR VR ON CI.custid = VR.CustID
	CROSS APPLY (SELECT ISNULL(virtualmultiplier,1) AS virtualmultiplier 
				 FROM CustInfo ci_1 WITH(NOLOCK) 
				 WHERE ci_1.CustID = ci.recommend
				) AS VR_CI
WHERE CI.roleid = 1
				
