/*
	Created: Susan
	Date: 2017-01-03
	DB: DBCUST/CustDB
	--step 0: prepare structure for tmpStakeLevelMapping on DBTP
*/ 

CREATE TABLE [dbo].[tmpStakeLevelMapping](
	[ExchangeId] [int] NULL,
	[StakeLevelID_LC] [int] NULL,
	[GameTypeID] [int] NULL,
	[StakeLevelID_GD] [int] NULL,
 ) ON [DATA]

INSERT INTO [tmpStakeLevelMapping]
SELECT  3  AS 'Exchangeid' ,  2246  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   10   AS 'StakeLevelID_GD' 
UNION ALL
SELECT  3  AS 'Exchangeid' ,  1277  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   11   AS 'StakeLevelID_GD'  
UNION ALL
SELECT  3  AS 'Exchangeid' ,  1278  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   12   AS 'StakeLevelID_GD'  
UNION ALL
SELECT  3  AS 'Exchangeid' ,  1279  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   13   AS 'StakeLevelID_GD'  
UNION ALL 
SELECT  3  AS 'Exchangeid' ,  1594  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   197   AS 'StakeLevelID_GD'  
UNION ALL 
SELECT  3  AS 'Exchangeid' ,  1595  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   198   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  3  AS 'Exchangeid' ,  1596  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   199   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  16  AS 'Exchangeid' ,  2248  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   42   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  16  AS 'Exchangeid' ,  1316  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   43   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  16  AS 'Exchangeid' ,  1317  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   44   AS 'StakeLevelID_GD'   
UNION ALL 
 SELECT  16  AS 'Exchangeid' ,  1318  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   45   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  16  AS 'Exchangeid' ,  1603  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   221   AS 'StakeLevelID_GD'  
UNION ALL 
SELECT  16  AS 'Exchangeid' ,  1604  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   222   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  16  AS 'Exchangeid' ,  1605  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   223   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  17  AS 'Exchangeid' ,  2245  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   46   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  17  AS 'Exchangeid' ,  1274  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   47   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  17  AS 'Exchangeid' ,  1275  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   48   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  17  AS 'Exchangeid' ,  1276  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   49   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  17  AS 'Exchangeid' ,  1591  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   224   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  17  AS 'Exchangeid' ,  1592  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   225   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  17  AS 'Exchangeid' ,  1593  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   226   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  20  AS 'Exchangeid' ,  1324  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   50   AS 'StakeLevelID_GD'   
UNION ALL 
 SELECT  20  AS 'Exchangeid' ,  1951  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   51   AS 'StakeLevelID_GD'   
UNION ALL 
 SELECT  20  AS 'Exchangeid' ,  1117  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   52   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  20  AS 'Exchangeid' ,  1952  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   53   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  20  AS 'Exchangeid' ,  1325  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   54   AS 'StakeLevelID_GD'   
UNION ALL 
 SELECT  20  AS 'Exchangeid' ,  1436  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   227   AS 'StakeLevelID_GD'   
UNION ALL 
 SELECT  20  AS 'Exchangeid' ,  2644  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   228   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  35  AS 'Exchangeid' ,  2243  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   83   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  35  AS 'Exchangeid' ,  1268  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   84   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  35  AS 'Exchangeid' ,  1269  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   85   AS 'StakeLevelID_GD'   
UNION ALL 
 SELECT  35  AS 'Exchangeid' ,  1270  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   86   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  35  AS 'Exchangeid' ,  1585  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   250   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  35  AS 'Exchangeid' ,  1586  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   251   AS 'StakeLevelID_GD'   
UNION ALL 
 SELECT  35  AS 'Exchangeid' ,  1587  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   252   AS 'StakeLevelID_GD'   
UNION ALL 
 SELECT  40  AS 'Exchangeid' ,  2244  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   95   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  40  AS 'Exchangeid' ,  1271  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   96   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  40  AS 'Exchangeid' ,  1272  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   97   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  40  AS 'Exchangeid' ,  1273  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   98   AS 'StakeLevelID_GD'   
UNION ALL 
 SELECT  40  AS 'Exchangeid' ,  1588  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   259   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  40  AS 'Exchangeid' ,  1589  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   260   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  40  AS 'Exchangeid' ,  1590  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   261   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  64  AS 'Exchangeid' ,  2238  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   179   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  64  AS 'Exchangeid' ,  1280  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   180   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  64  AS 'Exchangeid' ,  1281  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   181   AS 'StakeLevelID_GD'   
UNION ALL 
 SELECT  64  AS 'Exchangeid' ,  1282  AS 'StakeLevelID_LC' ,   1701  AS 'GameTypeID',   182   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  64  AS 'Exchangeid' ,  1597  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   322   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  64  AS 'Exchangeid' ,  1598  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   323   AS 'StakeLevelID_GD'   
UNION ALL 
SELECT  64  AS 'Exchangeid' ,  1599  AS 'StakeLevelID_LC' ,   1702  AS 'GameTypeID',   324   AS 'StakeLevelID_GD' 
