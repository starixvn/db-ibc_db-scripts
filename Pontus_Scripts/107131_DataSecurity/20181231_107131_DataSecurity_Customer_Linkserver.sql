/*
	Created: 20181231@Helen
	Task: https://nexdev.net/issues/107131
	DB: 
		#1 - MainDB
				DBCUST.CUSTDB
				DBTRANS.CUSTDB
		#2 - Replicated Servers ON PUB CustDB_Customer_Info.bodb02: 
				DB042.BODB02
				DB043.BODB02
				DB044.BODB02
				DB05.BODB02
				DB052.BODB02
				DB053.BODB02
				DB054.BODB02
				DB05BK1.BODB02
				DB06.BODB02
				DBLICAPI.BODB02
				DBLICAPI02.BODB02
				DBTP.BODB02
		#3 - DBAFF
				DBAFF.Affiliate_Athena000
				DBAFF.Affiliate_Spondemo
				DBAFF.Affiliate_itcbet
				DBAFF.Affiliate_MacauBet
					
		#4 - DB052
				DB052.Affiliate_12BET
		#5 - DB06
				DB06.bodb_OWP	
			
*/

SELECT  ss.name 
	,'Remote Login Name' = sl.remote_name
INTO #linkserver
FROM sys.Servers ss 
	INNER JOIN sys.linked_logins sl ON ss.server_id = sl.server_id 
WHERE sl.remote_name = 'sqllink'

SELECT * FROM #linkserver

DECLARE @String VARCHAR(MAX) = ''
SELECT @String = @String +'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N''' + name + ''', @locallogin = N''vnteam'', @useself = N''True''' + CHAR (13)
+'GO' 
FROM #linkserver

PRINT @String

DROP TABLE #linkserver