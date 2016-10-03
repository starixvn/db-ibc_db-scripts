/*
	Created: Helen	
	Task: Initialize Product Status of AllBet for Credit customers
	DB: DBCUST/CustDB
	Date: 20160820
*/ 
ALTER PROCEDURE [dbo].[Acc_DynamicCustomerInfo_09]
	@Custid INT
	,@roleid TINYINT
	,@srecommend INT
	,@mrecommend INT	
	,@Mode BIT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustProductStatus') = 1
	   AND dbo.f_CheckRepTable('ProductSettingDetail') = 1
	   AND dbo.f_CheckRepTable('ProductStatusProfile') = 1
	   )
		RETURN
	
	
	/*******************************CUST PRODUCT STATUS TABLE*******************************/	
	IF @Mode = 1 -- NOT reply on LC
	BEGIN
		IF @roleid = 4
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 6, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.srecommend = @Custid
		END
		ELSE IF @roleid = 3
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 6, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.mrecommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 6, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend
		END
		ELSE IF @roleid = 2
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 6, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.recommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 6, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend OR ci.custid = @mrecommend
		END
	END

	IF @Mode = 0 -- reply on LC
	BEGIN
		IF @roleid = 4
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 AND ci.DisableLiveCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 6, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.srecommend = @Custid
		END
		ELSE IF @roleid = 3
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 AND ci.DisableLiveCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 6, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.mrecommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 AND ci.DisableLiveCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 6, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend
		END
		ELSE IF @roleid = 2
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 AND ci.DisableLiveCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 6, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.recommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 AND ci.DisableLiveCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 6, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend OR ci.custid = @mrecommend
		END
	END
	
	
	
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------


CREATE TABLE #Cust (custid int, srecommend INT, mrecommend INT, roleid TINYINT, Mode BIT,IsDownLine BIT, isfinished bit default(0)) --Mode 0: depend on disable LC, 1: enable all
DECLARE @custid int, @srecommend INT, @mrecommend INT, @roleid TINYINT, @Mode BIT, @IsDownLine BIT = 0

INSERT INTO #Cust(custid, srecommend, mrecommend, roleid, Mode)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.roleid, 1 AS mode
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.site in ('INDO','755555','Koribc')
	AND ci.username IN ('CHTB',
'ST',
'STT',
'ST1T',
'ST2T',
'ST3T',
'ST4T',
'ST5T',
'ST6T',
'ST7T',
'ST8T',
'ST9T',
'BT',
'B5T',
'B1T',
'B2T',
'B3T',
'B4T',
'B6T',
'B7T',
'B8T',
'B9T',
'B10T',
'B11T',
'B12T',
'B13T',
'B14T',
'B15T',
'B16T',
'B17T',
'B18T',
'B19T',
'B20T',
'B21T',
'B22T',
'B23T',
'B24T',
'B25T',
'STEB',
'SABT',
'B26T',
'B27T',
'B28t',
'B29T',
'B30T',
'B31T',
'B32T',
'B33T',
'B35T',
'B34T',
'B36T',
'B37T',
'B38T',
'B39T',
'B40T',
'B41T',
'B42T',
'B43T',
'B44T',
'B45T',
'B46T',
'B47T',
'B48T',
'B49T',
'B50T',
'B51T',
'B52T',
'B53T',
'B54T',
'MGTB',
'MGBTB',
'MGCTB',
'SGTB',
'SGATB',
'SGI',
'SGT',
'SGAT',
'SGBT',
'SGCT',
'SGKB',
'THT',
'THD',
'THF',
'SI',
'UU',
'WH',
'UT',
'D8G',
'UK',
'IB',
'LK',
'JA',
'UM',
'SB',
'UN',
'UL',
'JB',
'IN',
'JC',
'YN',
'CL',
'UA',
'UB',
'WB',
'IJ',
'WU',
'AT',
'ZZ',
'UC',
'LN',
'KK',
'VB',
'YY',
'UE',
'IF',
'BB',
'HO',
'HU',
'SL',
'UD',
'IZ',
'JK',
'HW',
'UW',
'CX',
'UV',
'AK',
'JN',
'AI',
'JT',
'UF',
'CY',
'UZ',
'UH',
'MH',
'AH',
'UG',
'UY',
'YM',
'TA',
'AQ',
'AD',
'WG',
'WA',
'CP',
'HI',
'BI',
'BJ',
'LI',
'LW',
'UI',
'HP',
'GI',
'SW',
'DI',
'WI',
'QQ',
'DW',
'FF',
'TI',
'CI',
'IP',
'RR',
'IC',
'CO',
'CU',
'CS',
'YI',
'IR',
'VV',
'ID',
'MW',
'MM',
'AL',
'DB',
'SD',
'LR',
'WW',
'JJ',
'II',
'IM',
'IK',
'IA',
'IE',
'IG',
'IO',
'IU',
'S60RUP',
'S60AR',
'D60',
'E60',
'S16RUP',
'S6RUP',
'S6ARUP',
'AA',
'BA',
'DA',
'FA',
'VC',
'VD',
'VM',
'VF',
'GA',
'VO',
'GG',
'VP',
'S6KW',
'S7KW',
'VQ',
'FM',
'VI',
'AKO1',
'AKO2',
'VE',
'KRW',
'VA',
'VG',
'S9KW',
'MD',
'AKO3',
'S6T',
'S9KS',
'VJ',
'S9KK',
'S6S',
'VN',
'VR',
'S88D',
'S88ID',
'S88IE',
'SWO',
'JAT',
'MBO',
'LJ',
'LH',
'LU',
'LY',
'LL',
'LB',
'LC',
'LD',
'LE',
'LV',
'LF',
'LT',
'KD',
'KL',
'HA',
'LS',
'LA',
'LG',
'LM',
'LII',
'LZ',
'BGR',
'CHU',
'FFF',
'FEF',
'BET',
'USD',
'HPI',
'HPJ',
'HPH',
'HPE',
'HPA',
'MO',
'MP',
'HPG',
'MQ',
'MG',
'HTB',
'MU',
'MV',
'MZ',
'ML',
'MX',
'GN',
'GO',
'SEA',
'SEB',
'SEC',
'SYI',
'SNI',
'SLS',
'SLT',
'ALTH',
'ALRP',
'ALKR',
'HT1',
'HT2',
'HT3',
'HT4',
'HT5',
'KKT',
'KKB',
'KAE',
'KAF',
'KBF',
'KBT',
'KCT',
'KDT',
'KET',
'KND',
'KNE',
'KFT',
'KFU',
'U8',
'HGW',
'S7D',
'S7W',
'PK',
'P11',
'P12',
'P15',
'P13',
'P14',
'P16',
'P17',
'P18',
'P19',
'P22',
'P20',
'P21',
'AS',
'AP',
'AJ',
'AN',
'WINA',
'WINB',
'WINC',
'WINZ',
'WINE',
'WINS',
'WINF',
'WING',
'WINH',
'WINJ',
'WINI',
'WINO',
'WINP',
'ACE',
'FAT',
'DON',
'BAT',
'TOP',
'BJB',
'BTM',
'AW',
'AZ',
'AG',
'AF',
'WJ',
'AWTA',
'AWTB',
'KID',
'ZTA',
'ZTB',
'CRA',
'STL',
'STK',
'STJ',
'STP',
'STG',
'STY',
'TU1',
'TU2',
'TU3'
)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Cust
	SET isfinished = 1
		,@custid = custid	
		,@srecommend = srecommend	
		,@mrecommend = mrecommend
		,@roleid = roleid
		,@Mode = Mode
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 
			@custid = @custid			
			,@srecommend = @srecommend
			,@mrecommend = @mrecommend
			,@roleid = @roleid
			,@Mode = @Mode
			
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #Cust (custid int, srecommend INT, mrecommend INT, roleid TINYINT, Mode BIT, isfinished bit default(0)) --Mode 0: depend on disable OneRNG, 1: enable all
DECLARE @custid int, @srecommend INT, @mrecommend INT, @roleid TINYINT, @Mode BIT

INSERT INTO #Cust(custid, srecommend, mrecommend, roleid, Mode)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.roleid, 1 AS mode
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.site in ('INDO','755555','Koribc')
	AND ci.username IN ('CHTB',
'ST',
'STT',
'ST1T',
'ST2T',
'ST3T',
'ST4T',
'ST5T',
'ST6T',
'ST7T',
'ST8T',
'ST9T',
'BT',
'B5T',
'B1T',
'B2T',
'B3T',
'B4T',
'B6T',
'B7T',
'B8T',
'B9T',
'B10T',
'B11T',
'B12T',
'B13T',
'B14T',
'B15T',
'B16T',
'B17T',
'B18T',
'B19T',
'B20T',
'B21T',
'B22T',
'B23T',
'B24T',
'B25T',
'STEB',
'SABT',
'B26T',
'B27T',
'B28t',
'B29T',
'B30T',
'B31T',
'B32T',
'B33T',
'B35T',
'B34T',
'B36T',
'B37T',
'B38T',
'B39T',
'B40T',
'B41T',
'B42T',
'B43T',
'B44T',
'B45T',
'B46T',
'B47T',
'B48T',
'B49T',
'B50T',
'B51T',
'B52T',
'B53T',
'B54T',
'MGTB',
'MGBTB',
'MGCTB',
'SGTB',
'SGATB',
'SGI',
'SGT',
'SGAT',
'SGBT',
'SGCT',
'SGKB',
'THT',
'THD',
'THF',
'SI',
'UU',
'WH',
'UT',
'D8G',
'UK',
'IB',
'LK',
'JA',
'UM',
'SB',
'UN',
'UL',
'JB',
'IN',
'JC',
'YN',
'CL',
'UA',
'UB',
'WB',
'IJ',
'WU',
'AT',
'ZZ',
'UC',
'LN',
'KK',
'VB',
'YY',
'UE',
'IF',
'BB',
'HO',
'HU',
'SL',
'UD',
'IZ',
'JK',
'HW',
'UW',
'CX',
'UV',
'AK',
'JN',
'AI',
'JT',
'UF',
'CY',
'UZ',
'UH',
'MH',
'AH',
'UG',
'UY',
'YM',
'TA',
'AQ',
'AD',
'WG',
'WA',
'CP',
'HI',
'BI',
'BJ',
'LI',
'LW',
'UI',
'HP',
'GI',
'SW',
'DI',
'WI',
'QQ',
'DW',
'FF',
'TI',
'CI',
'IP',
'RR',
'IC',
'CO',
'CU',
'CS',
'YI',
'IR',
'VV',
'ID',
'MW',
'MM',
'AL',
'DB',
'SD',
'LR',
'WW',
'JJ',
'II',
'IM',
'IK',
'IA',
'IE',
'IG',
'IO',
'IU',
'S60RUP',
'S60AR',
'D60',
'E60',
'S16RUP',
'S6RUP',
'S6ARUP',
'AA',
'BA',
'DA',
'FA',
'VC',
'VD',
'VM',
'VF',
'GA',
'VO',
'GG',
'VP',
'S6KW',
'S7KW',
'VQ',
'FM',
'VI',
'AKO1',
'AKO2',
'VE',
'KRW',
'VA',
'VG',
'S9KW',
'MD',
'AKO3',
'S6T',
'S9KS',
'VJ',
'S9KK',
'S6S',
'VN',
'VR',
'S88D',
'S88ID',
'S88IE',
'SWO',
'JAT',
'MBO',
'LJ',
'LH',
'LU',
'LY',
'LL',
'LB',
'LC',
'LD',
'LE',
'LV',
'LF',
'LT',
'KD',
'KL',
'HA',
'LS',
'LA',
'LG',
'LM',
'LII',
'LZ',
'BGR',
'CHU',
'FFF',
'FEF',
'BET',
'USD',
'HPI',
'HPJ',
'HPH',
'HPE',
'HPA',
'MO',
'MP',
'HPG',
'MQ',
'MG',
'HTB',
'MU',
'MV',
'MZ',
'ML',
'MX',
'GN',
'GO',
'SEA',
'SEB',
'SEC',
'SYI',
'SNI',
'SLS',
'SLT',
'ALTH',
'ALRP',
'ALKR',
'HT1',
'HT2',
'HT3',
'HT4',
'HT5',
'KKT',
'KKB',
'KAE',
'KAF',
'KBF',
'KBT',
'KCT',
'KDT',
'KET',
'KND',
'KNE',
'KFT',
'KFU',
'U8',
'HGW',
'S7D',
'S7W',
'PK',
'P11',
'P12',
'P15',
'P13',
'P14',
'P16',
'P17',
'P18',
'P19',
'P22',
'P20',
'P21',
'AS',
'AP',
'AJ',
'AN',
'WINA',
'WINB',
'WINC',
'WINZ',
'WINE',
'WINS',
'WINF',
'WING',
'WINH',
'WINJ',
'WINI',
'WINO',
'WINP',
'ACE',
'FAT',
'DON',
'BAT',
'TOP',
'BJB',
'BTM',
'AW',
'AZ',
'AG',
'AF',
'WJ',
'AWTA',
'AWTB',
'KID',
'ZTA',
'ZTB',
'CRA',
'STL',
'STK',
'STJ',
'STP',
'STG',
'STY',
'TU1',
'TU2',
'TU3'
)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Cust
	SET isfinished = 1
		,@custid = custid	
		,@srecommend = srecommend	
		,@mrecommend = mrecommend
		,@roleid = roleid
		,@Mode = Mode
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 
			@custid = @custid			
			,@srecommend = @srecommend
			,@mrecommend = @mrecommend
			,@roleid = @roleid
			,@Mode = @Mode
			,@target = 'DBCUST'
			
			
	waitfor delay '00:00:0.280'
END