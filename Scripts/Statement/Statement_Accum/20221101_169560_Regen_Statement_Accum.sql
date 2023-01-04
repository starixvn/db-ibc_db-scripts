/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20221101@Danny
	DB: DBRPT-bodb_Report
	Task: Gen data for Statement [RedmineID: #169560]
*/
USE bodb_Report

CREATE TABLE #tmp_Cust(ID INT identity(1,1), accdate DATETIME,CustId INT, totalAmt MONEY )

INSERT INTO #tmp_Cust(accdate, CustId)
select MIN(accdate) accdate, CustId 
from Statement with(nolock) 
where
custID IN (select t.CustId from Statement_Accum_WrongBalance_UAT t  with(nolock) where Diff_From = '2022-06-10' and IsFixed IS NULL) and transtype = 'BAL'
GROUP BY CustID

INSERT INTO Statement_Accum (CustID, AccDate, TotalAmt)
select s.CustID, s.AccDate, s.TotalAmt  
from Statement s with(nolock)
INNER JOIN #tmp_Cust t ON s.custid = t.CustId AND s.accdate = t.accdate AND s.transtype = 'BAL'

DECLARE @balDate TABLE (balDate DATETIME)
INSERT INTO @balDate(balDate)
SELECT AccDate FROM Statement WITH(NOLOCK) WHERE CustID = 3 AND TransType = 'BAL'  AND accdate > '2022-05-20'
UNION  SELECT '2022-10-21' AS AccDate
ORDER BY AccDate ASC

DECLARE @i INT = 1, @CustID_Regen INT , @BalDate_regen DATETIME
WHILE EXISTS (SELECT TOP 1 1 FROM #tmp_cust WHERE ID = @i)
BEGIN
	SELECT @CustID_Regen  =  CustID , @BalDate_regen = accdate
	FROM #tmp_cust WHERE ID = @i 
	; with u AS
	(
	  SELECT b.balDate, x.totalAmt
	  FROM @balDate b
	  CROSS APPLY (
		  SELECT SUM(totalamt) totalamt
		  FROM Statement x with(nolock) 
		  where x.AccDate < b.balDate 
		  AND x.CustId = @CustID_Regen 
		  AND ( x.transtype NOT IN ('BAL','GP') OR  (x.transtype  = 'BAL' AND ACcDate = @BalDate_regen)) 
		  AND ACcDate >= @BalDate_regen
	  ) x
	  WHERE b.balDate > @BalDate_regen
	 )
		MERGE dbo.Statement_Accum AS t
		USING u AS u ON t.AccDate = u.balDate AND t.CustId = @CustID_Regen
		WHEN MATCHED THEN UPDATE
			SET TotalAmt = u.totalAmt
		WHEN NOT MATCHED THEN
			INSERT(CustID, AccDate, TotalAmt)
			VALUES(@CustID_Regen, u.balDate, u.TotalAmt);

	SELECT @i = @i + 1
END

-- Update IsFixed
UPDATE  Statement_Accum_WrongBalance_UAT with(ROWLOCK, UPDLOCK)
SET IsFixed = 1
WHERE CustID IN (select x.CustID FROM  #tmp_Cust x)

DROP TABLE #tmp_Cust

/*
-- 305 custs

CREATE TABLE #tmp_Statement (CustID INT, ACcDate DATETIME, transtype NVARCHAR(50), totalAmt MONEY)
INSERT INTO #tmp_Statement (CustID,ACcDate,transtype,totalAmt) 
SELECT CustID,ACcDate,transtype,totalAmt
FROM tmp_Statement_UAT WITH(NOLOCK)
WHERE CustID IN 
(
	54096787,54099774,54101965,54102104,54135404,54145727,54150206,54156893,54169177,
	54087449,54121911,54170719,54174492,54177398,54180050,54192819,54240938,54242064,54248900,54250205,54241205,
	54080170,54120880,54127451,54129095,54145341,54150829,54164358,54164394,54164802,54179216,
	54182475,54183628,54183862,54184190,54189888,54190120,54192619,54192728,54196438,54106715,54120863,54135333,
	54135383,54135901,54136328,54139062,54139068,54145310,54153510,54161113,54161838,54164399,54164899,54168776,
	54178258,54179164,54182305,54188523,54189298,54190027,54190667,54196260,54196951,54160701,54161589,54162003,
	54163195,54166806,54168915,54169990,54170128,54171068,54174232,54174476,54174720,54175930,54176904,54178143,
	54179976,54182617,54185119,54186310,54189032,54194623,54197001,54197458,54197773,54199255,54201217,54201643,
	54203019,54204662,54205327,54206645,54209524,54209579,54211194,54212539,54213693,54215311,54217504,54221662,
	54221977,54222466,54223795,54225065,54228307,54228695,54229226,54231033,54232329,54233479,54234509,54235689,
	54236512,54236537,54237252,54237662,54237746,54239219,54239641,54239761,54241144,54241305,54242902,54246350,
	54246934,54248086,54248348,54248835,54250633,54251357,54252239,54256135,54257929,54261104,54262130,54264225,
	54264464,54264511,54266075,54266791,54414403,54416612,54417374,54417398,54418935,54420883,54421739,54424676,
	54429363,54433323,54075371,54077997,54080115,54081168,54082472,54086906,54090555,54095962,54102923,54115914,
	54118361,54118405,54121051,54122338,54130007,54130887,54132295,54134747,54135803,54139794,54140027,54141120,
	54141455,54142101,54144617,54144798,54144860,54146939,54148987,54149683,54152916,54155343,54158320,54158803,
	54442955,54162721,54163721,54166024,54170013,54173448,54174266,54174780,54176557,54177128,54177452,54182672,
	54184708,54186067,54193662,54197197,54197465,54198170,54200989,54201606,54201934,54203400,54205215,54206347,
	54209338,54209566,54209742,54211324,54213657,54213714,54216034,54217843,54221970,54222453,54222611,54224821,
	54227116,54228660,54228917,54229959,54231683,54233433,54233597,54236268,54236533,54237188,54237614,54237724,
	54238389,54239287,54239700,54240361,54241066,54235548,54241794,54242687,54244088,54246528,54247015,54248121,
	54248401,54248882,54249394,54250241,54251223,54251981,54253211,54256766,54260553,54261245,54264085,54264460,
	54264492,54266062,54266140,54266813,54414389,54415776,54417283,54417393,54418269,54419139,54420897,54423588,
	54426312,54433310,54077635,54079151,54082459,54084783,54087059,54089411,54091406,54101646,54105718,54114844,
	54117267,54118369,54119609,54122935,54130323,54132102,54133255,54138446,54139835,54140896,54141447,54141637,
	54142664,54144654,54144847,54145246,54146867,54147566,54149059,54152486,54158607,54159769
)
AND AccDate = '2022-04-21'


MERGE dbo.Statement AS t
USING #tmp_Statement u AS u ON t.CustId = u.CustId AND t.AccDate = u.accdate AND t.transtype = u.transtype
WHEN MATCHED THEN UPDATE
	SET TotalAmt = u.totalAmt
WHEN NOT MATCHED THEN
	INSERT(CustID, AccDate, TotalAmt, transtype)
	VALUES(u.CustID, u.AccDate, u.TotalAmt, u.transtype);


MERGE dbo.Statement AS t
USING tmp_Statement_UAT u ON t.CustId = u.CustId AND t.AccDate = u.accdate AND t.transtype = u.transtype
WHEN MATCHED AND t.transDesc IS NULL THEN UPDATE
	SET transDesc = 'Betting'
;

-- Update IsFixed
UPDATE  Statement_Accum_WrongBalance_UAT with(ROWLOCK, UPDLOCK)
SET IsFixed = 1
WHERE CustID IN (select x.CustID FROM  #tmp_Statement x)


DROP TABLE #tmp_Statement
*/
/*

CREATE TABLE #tmp_Cust (ID INT IDENTITY(1,1), CustID INT, TotalAmt MONEY)

INSERT INTO #tmp_cust(CustID, TotalAmt) values (14518252,0.54)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (15200326,-3176.41)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (16036674,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (17407699,23046.005)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (22443090,2000.75)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (28653887,-6391)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (31208497,223.73)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (32336244,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (32465266,-235292)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (33497068,-10331.03)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (33497069,-5971)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (34024028,758.1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (36111416,28)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (39348645,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (40059974,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (40725046,202)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (42067047,300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (42678254,314.44)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (43781092,-1407.375)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (44266523,2.02)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (44975069,406)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (45321592,-254)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (45912037,3160)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (46686629,21)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (47363352,58000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (47499395,62)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (47990092,2.11)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (48040544,1.17)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (48076701,-8530.895)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (49162965,58)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (49762840,30)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (49763412,2156)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (49926017,3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (49946289,231.7)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (50414681,13)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (50496116,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (50569162,2000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (50580392,1860)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (51210095,99.5625)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (51291313,700)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (51427802,45656.1753)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (51718084,7.69)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (51820409,6.69)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (51841914,600)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (51870262,1.59)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (52206651,1001.02)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (52217385,65)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (52937717,400)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (53041564,17)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (53127256,7.81)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (53197804,23.36)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (53252690,17.3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (53281141,35.17)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (53292612,314)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (53388944,55493)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (53584834,150000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (53623596,-209)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (53760331,1.9)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (53839684,3.1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (53943130,120.09)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (54019611,150)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (54048691,2.52)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (54235092,1010.7)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (54459296,35.35)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (54484996,59.52)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (54634379,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (54641448,150)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (54948419,3085.3292)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (55029763,800)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (55030531,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (55164484,233.34)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (55399344,390)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (55481249,60)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (56144479,2.95)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (56346194,236.91)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (56444525,3109.42)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (56503816,10000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (56507102,0.0033)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (56535125,10.07)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (56622359,2.73)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (56655895,2.61)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (56754284,896)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (56789706,2.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (56832006,-1778.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (56973361,949.9192)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (57217237,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (57234230,10000.66)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (57271238,19643)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (57293525,18.86)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (57395785,2.79)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (57518763,526.2)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (57561482,22.8)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (57567706,3070.33)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (57624255,150)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (57626498,4.95)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (57804807,10519.34)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (57853662,1000.06)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (57855539,3703)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (58100352,357.24)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (58423776,8.27)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (58432890,0.54)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (58449467,1.9)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (58607864,4.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (58635594,515)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (58856821,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (58955290,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59162975,5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59229248,32.7)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59236249,6)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59244172,7)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59379418,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59501733,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59590510,705.882)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59602119,9.8)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59628287,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59727792,2.9)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59779703,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59799356,44.8)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59821151,-274.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59870103,117.558)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59916501,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (59923021,20746.65)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60180829,9.51)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60219297,5.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60255183,1.76)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60278878,300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60317292,-69372.4035)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60317421,-1.85)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60453459,4.02)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60574107,2.2)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60579670,1980)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60658130,8.82)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60689361,55493)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60745609,61)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60747437,32)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60757295,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60858473,11)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (60933801,20.1295)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61025085,1840)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61092382,1.55)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61098440,4.66)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61103033,101)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61121438,1.57)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61129632,40945.2435)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61155647,259.2256)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61218433,13348.78)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61246498,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61254287,94)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61290834,79.79)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61318292,7.22)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61389779,191)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61407231,1011.92)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61443763,99500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61520819,-13425.33)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61536418,-4.252)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61536722,10.065)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61560761,-605)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61695088,7.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61723560,666.468)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61745493,-141.954)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61757440,381.8)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61792274,16)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61803835,101)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61865962,15000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61887579,300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61905783,4.98)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61908911,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (61934426,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62090544,2075.97)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62099032,5044.43)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62149994,5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62195147,1085)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62265733,23)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62335498,7)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62404710,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62423511,10000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62432432,6068.4)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62473604,2.38)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62474430,0.7875)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62484435,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62503935,168.3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62514121,13.27)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62553330,38)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62560572,1.03)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62563727,8872.36)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62589679,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62607868,123900)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62635272,92)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62643446,24)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62672924,85)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62683952,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62702209,-1.09)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62702285,4)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62718100,6)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62719029,0.2713)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62741700,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62752335,15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62758188,1.11)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62762738,1.22)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62788649,92.35)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62821404,69367)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62840184,44.1236)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62852638,164)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62867621,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62918570,300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62928302,150)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62943196,560.84)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62949555,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62972567,2000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62979693,3449)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (62984472,27.16)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63021841,418.8804)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63054107,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63088518,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63095285,11953.1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63113811,0.0002)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63191289,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63207845,457.16)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63216986,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63242363,0.007)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63261301,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63284559,-0.5576)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63297170,109.24)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63298223,7256)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63302550,113)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63346738,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63507402,1495)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63529368,74.55)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63554211,1.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63570249,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63582485,5400)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63627688,33729.78)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63632023,250)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63643811,1.67)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63656002,0.0061)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63733658,3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63759983,1020.63)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63771058,1.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63811802,24.17)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63820462,0.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63837616,88)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63840016,0.006)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63872801,121)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63888800,7.02)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63891061,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63895422,3012)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63913412,104)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63927212,8.74)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63963661,4.29)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63973860,2008.18)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63974671,692)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (63989371,0.0012)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64011346,1400.25)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64014549,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64021671,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64022581,57.4)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64025484,480)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64031417,4)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64032516,10000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64038648,38)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64053888,28.19)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64073201,5.07)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64076396,-4437.0575)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64079252,30.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64098593,7)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64108892,17136)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64111728,0.5696)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64114289,-53116.39)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64115167,29)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64125678,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64140046,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64147442,120)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64148998,24801)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64153317,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64160674,73.06)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64163728,300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64165607,40)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64167895,1.82)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64175062,15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64176976,-446047.2623)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64179926,8784)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64180572,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64182744,5040.2)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64187193,33142)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64198671,92.98)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64200817,150)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64204078,55.8)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64206823,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64216620,719.31)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64232432,2987.7764)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64232490,1.37)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64238071,0.1062)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64249286,0.0054)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64254886,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64255592,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64256313,20000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64259906,25725)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64260758,43.66)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64272895,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64275480,1.05)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64275485,31.58)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64276788,903)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64290482,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64290664,-1911.2)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64291127,-2999.26)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64292813,0.0093)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64294825,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64296900,11.347)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64297623,1.2)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64298289,-4777.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64300007,18)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64301237,24904.0665)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64302750,22741.36)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64305644,13.45)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64309003,-69462.625)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64310215,624)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64315078,0.125)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64319405,30)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64320057,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64348044,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64351390,123)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64356064,0.0221)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64356199,15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64356249,-158216)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64361349,12921)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64366500,15060.8)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64369605,0.0452)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64371223,51)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64374604,35273)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64376576,0.5925)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64379614,53000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64379882,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64383921,-68200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64385291,0.0063)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64386372,2594.7402)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64386823,57)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64388329,25)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64388785,41.73)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64388939,3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64388953,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64390624,2.16)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64390676,468)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64391840,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64392068,9)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64393550,3030)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64396243,3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64397347,3702.2775)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64399025,102.16)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64399785,1924)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64401106,1007)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64401201,1445)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64401363,1500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64403807,0.0094)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64407484,0.0092)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64408614,0.0022)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64409870,151)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64411179,0.0012)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64411475,1.8576)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64412338,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64413845,1335)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64413946,2466)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64414034,3.4798)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64414293,52)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64414709,5.1187)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64414775,0.485)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64415210,61)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64418985,704)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64419083,0.15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64419675,10095.9)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64419761,204)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64420108,40)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64421034,1.6819)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64421091,30)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64421763,0.18)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64423331,0.145)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64428288,25498)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64430299,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64435014,50000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64435016,2.16)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64436145,2.06)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64437093,4930)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64437788,0.7406)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64440024,5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64441055,98)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64447210,4200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64447486,-13087.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64448033,73)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64448372,7669)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64448624,2)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64448806,28.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64450915,8378.92)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64451355,367)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64453018,6000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64453493,51.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64453629,100000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64455144,3700)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64455494,0.025)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64455558,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64455686,101)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64456532,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64458266,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64461298,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64461713,8)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64462371,15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64463806,2000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64463881,5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64465948,0.0088)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64469583,0.74)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64470019,21)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64470373,18.2)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64472040,7.8497)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64472062,198.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64478729,320)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64478757,51.4)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64480627,165)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64481641,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64481784,2.38)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64482469,240)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64482872,0.0048)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64483100,8.455)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64483669,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64484365,0.965)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64484817,2400)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64485057,4.4619)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64485532,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64486216,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64487238,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64488080,2.79)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64490401,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64490875,1200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64490958,400)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64491720,170)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64491945,0.6901)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64492895,0.0008)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64493688,8)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64494245,0.0068)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64497333,1137)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64497679,15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64497958,3094)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64498462,0.632)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64498729,451)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64499661,299)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64499997,2000000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64500142,0.6)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64500210,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64500803,111)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64501834,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64502142,162)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64502195,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64502875,2043.39)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64502885,1.5075)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64503415,1900)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64503889,5000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64504199,15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64504314,450.25)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64505582,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64505622,1111)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64507643,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64508076,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64508438,5.46)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64508976,0.8543)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64511879,30)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64512431,590)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64512601,8)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64513038,58.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64513757,505)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64514183,80)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64516957,10000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64519504,3889.2081)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64522855,300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64525146,2230000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64525413,0.6281)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64525756,315)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64525981,0.0093)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64527074,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64528312,3.8693)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64530674,10558)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64530979,10.26)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64531138,0.0347)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64533724,701)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64534096,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64534103,168)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64534113,201)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64534601,21164)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64534970,1559)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64535953,19940)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64536667,87)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64539869,30)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64540042,420)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64540059,12.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64540479,499)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64541677,18)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64541707,5583)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64543534,38)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64544314,35.4818)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64544545,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64544630,9)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64544931,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64545706,2.0212)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64545730,-16751.79)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64546653,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64547159,1856)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64547292,17)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64547500,0.0412)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64547543,0.0044)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64548353,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64548371,14136)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64550347,912.08)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64552799,0.0066)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64552898,6)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64555240,0.0026)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64555444,725)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64556012,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64556152,2.59)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64557257,528.08)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64558274,68)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64558910,15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64559926,0.0081)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64560917,501)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64561564,13)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64561813,0.0021)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64562431,281)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64562456,-3100000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64563537,53.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64563818,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64564944,12.66)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64565764,15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64566027,380.95)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64566803,64500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64567229,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64567620,12)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64567778,15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64567936,0.0016)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64568024,1.19)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64569519,1021)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64570488,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64570625,0.2733)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64570636,1595)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64571122,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64572323,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64572557,3000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64573501,1920)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64573884,7300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64574625,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64575164,0.008)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64575292,521.4)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64576854,299.73)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64577509,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64578227,2.1938)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64579126,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64579836,24.27)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64580410,0.0056)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64580814,29.18)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64581529,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64581779,194)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64583002,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64583366,808)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64583479,0.0035)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64583971,6.96)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64584727,31500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64584922,1.9224)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64585348,1.4745)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64586807,957.3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64588800,78)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64588928,97)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64589628,0.0004)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64590032,1000000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64590279,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64590359,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64590570,0.67)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64591466,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64592618,11000000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64592978,0.0036)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64594333,5.17)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64596786,2266.81)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64596949,203)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64597093,0.245)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64597097,0.605)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64598640,10000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64598744,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64599329,98)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64599528,0.15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64599653,150)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64601347,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64601739,30477.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64601965,300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64602020,18.2297)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64602484,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64603293,0.5466)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64604247,2000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64604342,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64604776,0.0078)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64605177,11.3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64605319,3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64605497,-3105940)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64606011,5000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64606020,2090)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64606095,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64606413,0.0027)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64606561,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64607379,2559)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64607630,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64607665,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64608071,23)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64608222,199)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64609066,5000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64609781,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64609783,0.84)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64609952,5108)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64609968,396.94)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64610191,0.6)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64610291,32158)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64610351,3003)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64610595,0.0034)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64610802,300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64610861,0.28)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64611267,15.85)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64611656,11.3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64611692,38)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64611712,0.85)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64612288,1.5548)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64612350,1523)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64612619,0.0628)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64612684,5050)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64613110,15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64613393,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64613667,4)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64613718,0.64)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64613785,6.72)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64613987,120020)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64614204,98)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64614256,1580)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64614472,66788)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64615117,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64615298,300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64615389,225.32)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64615740,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64615984,98)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64616075,384)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64616891,0.83)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64617012,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64619896,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64619981,76)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64620577,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64620671,2750.98)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64621110,8.2)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64621282,103992.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64621706,12)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64622534,8.3764)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64623155,82.4)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64624461,705)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64625215,33)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64625527,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64625547,0.295)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64626548,30000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64627285,0.0026)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64627602,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64628179,410)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64628638,24400)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64628758,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64628995,4247)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64629378,125)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64630539,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64630826,30)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64630981,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64631014,15.9)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64631441,1158)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64631481,170)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64631789,60)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64632592,4930)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64632819,0.69)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64632959,445)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64633402,32)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64633415,750)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64633780,6500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64633805,28)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64633917,49)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64634219,87)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64634324,0.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64634327,0.25)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64634599,38)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64634732,40)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64634824,19)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64634846,3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64635062,59)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64635104,38)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64635214,25)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64635218,46)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64636389,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64636448,2000000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64636902,40)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64636908,2000000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64637156,4)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64637223,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64637245,7.39)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64637379,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64637752,38)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64638933,14000000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64639155,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64639175,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64639196,6.15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64639478,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64639607,18)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64640048,2)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64640385,147)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64640675,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64640774,40)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64640884,0.18)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64640971,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64641038,897)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64641734,1400)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64641744,3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64642165,15000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64642773,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64643008,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64643097,1326)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64643190,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64643210,2000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64643472,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64643509,0.99)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64643962,1050)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64644311,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64644465,138734)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64644565,600)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64644782,2000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64645874,7)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64646301,96.03)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64646322,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64646390,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64646454,8.77)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64647039,800)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64647139,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64647703,108.91)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64647770,102.39)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64647829,3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64647868,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64647874,1636)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64648205,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64648306,101)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64648569,7)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64648719,499.98)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64648856,95)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64648894,15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64648906,7.41)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64649067,49)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64649202,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64649544,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64649696,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64650187,107)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64650313,205)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64650328,128)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64650401,26)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64650425,21)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64650512,154.96)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64650719,0.94)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64651048,505)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64651343,2010)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64651672,20000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64651910,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64652160,985.86)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64652514,40)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64652871,48)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64653500,15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64653572,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64654489,1.61)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64654675,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64654902,100000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64655206,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64655348,5.57)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64655648,46.74)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64655684,15)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64655842,260.99)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64656020,18)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64656172,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64656711,97)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64656715,400)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64656781,46)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64656803,4.19)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64657045,130)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64657180,96.04)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64657221,79.8)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64657420,10771)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64657899,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64658213,31)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64658303,980)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64658407,1012)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64658603,88)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64658767,30)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64659136,40)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64659188,8)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64659647,407.36)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64659927,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64660101,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64660640,1.68)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64661013,19)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64661267,17)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64661598,50000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64661836,840)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64662012,3500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64662144,1.63)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64662366,300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64662541,61.3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64662566,101)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64662592,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64662594,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64662765,1300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64662933,10000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64663093,300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64663300,124.24)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64663515,255)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64663568,4)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64663689,101)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64663729,250)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64663746,142)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64663788,108)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64663789,83)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64663832,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64664078,53.3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64664119,0.0084)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64664231,36)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64664340,73)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64664345,37)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64664366,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64664418,194)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64664419,300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64664448,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64664564,17360)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64664612,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64664743,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64664776,337)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64664819,20000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64665074,170)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64665186,160)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64665542,308)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64665629,340)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64665695,49)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64665762,980)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64665812,5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64665818,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64665838,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64665845,842)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64665862,1500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64665863,0.44)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64665966,5832)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64666269,1004)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64666520,10.77)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64666547,50.5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64666595,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64666659,42)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64666742,30)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64666758,129127.3)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64666788,25)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64666923,1960)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64666987,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64667164,400)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64667296,300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64667314,517.06)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64667344,1005)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64667362,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64667410,60)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64667461,300)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64667492,600)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64667497,68)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64667569,58.8)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64667597,201)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64667609,10001)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64667623,540)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64667713,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668006,30)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668019,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668050,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668084,5000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668115,500)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668192,256)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668228,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668256,129)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668316,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668317,5)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668325,40)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668468,1)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668475,400)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668476,384)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668526,5.22)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668577,210)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668618,580)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668651,2962)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668727,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668772,808)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668774,128)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668786,100)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668875,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668920,36)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668956,39)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668958,350)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668969,450)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64668989,101)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669042,1007)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669043,20)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669055,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669070,250)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669089,250)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669181,1.7)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669201,2044)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669209,1000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669269,99)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669277,4)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669293,199)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669301,200)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669325,2000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669329,10)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669334,11000)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669355,50)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669370,5163.8952)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669374,1488.96)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669389,69)
INSERT INTO #tmp_cust(CustID, TotalAmt) values (64669433,1)
-- Update IsFixed
UPDATE  Statement_Accum_WrongBalance_UAT with(ROWLOCK, UPDLOCK)
SET IsFixed = 1
WHERE CustID IN (select x.CustID FROM  #tmp_cust x)

-- Fix data Statement

CREATE TABLE #tmp_Statement (CustID INT, ACcDate DATETIME)
INSERT INTO #tmp_Statement (CustID,ACcDate) VALUES
(61980443,'2022-06-16 0:00:00'),	
(62045527,'2022-06-16 0:00:00'),	
(62068550,'2022-06-16 0:00:00'),	
(62085573,'2022-06-16 0:00:00'),	
(62088262,'2022-06-16 0:00:00'),	
(58366381,'2022-06-30 0:00:00'),	
(58453904,'2022-06-30 0:00:00'),	
(58459758,'2022-06-30 0:00:00'),	
(58295114,'2022-06-30 0:00:00'),	
(58439900,'2022-06-30 0:00:00'),	
(58305114,'2022-06-30 0:00:00'),	
(58414524,'2022-06-30 0:00:00'),	
(58481540,'2022-06-30 0:00:00'),	
(54363126,'2022-04-21 0:00:00'),	
(54363800,'2022-04-21 0:00:00'),	
(54364631,'2022-04-21 0:00:00'),	
(54366000,'2022-04-21 0:00:00'),	
(54366728,'2022-04-21 0:00:00'),	
(54367553,'2022-04-21 0:00:00'),	
(54368229,'2022-04-21 0:00:00'),	
(54368581,'2022-04-21 0:00:00'),	
(54368797,'2022-04-21 0:00:00'),	
(54369352,'2022-04-21 0:00:00'),	
(54369508,'2022-04-21 0:00:00'),	
(54369892,'2022-04-21 0:00:00'),	
(54369901,'2022-04-21 0:00:00'),	
(54370528,'2022-04-21 0:00:00'),	
(54370552,'2022-04-21 0:00:00'),	
(54371356,'2022-04-21 0:00:00'),	
(54371421,'2022-04-21 0:00:00'),	
(54371489,'2022-04-21 0:00:00'),	
(54371842,'2022-04-21 0:00:00'),	
(54372653,'2022-04-21 0:00:00'),	
(54379904,'2022-04-21 0:00:00'),	
(54379912,'2022-04-21 0:00:00'),	
(54385847,'2022-04-21 0:00:00'),	
(54385906,'2022-04-21 0:00:00'),	
(54386203,'2022-04-21 0:00:00'),	
(54387226,'2022-04-21 0:00:00'),	
(54391979,'2022-04-21 0:00:00'),	
(54394186,'2022-04-21 0:00:00'),	
(54396039,'2022-04-21 0:00:00'),	
(54402457,'2022-04-21 0:00:00'),	
(54403300,'2022-04-21 0:00:00'),	
(54404279,'2022-04-21 0:00:00'),	
(54404764,'2022-04-21 0:00:00'),	
(54406159,'2022-04-21 0:00:00'),	
(54406830,'2022-04-21 0:00:00'),	
(54408466,'2022-04-21 0:00:00'),	
(54408532,'2022-04-21 0:00:00'),	
(54409425,'2022-04-21 0:00:00'),	
(54410999,'2022-04-21 0:00:00'),	
(54411113,'2022-04-21 0:00:00'),	
(54411490,'2022-04-21 0:00:00'),	
(54362678,'2022-04-21 0:00:00'),	
(54362985,'2022-04-21 0:00:00'),	
(54363822,'2022-04-21 0:00:00'),	
(54364690,'2022-04-21 0:00:00'),	
(54364900,'2022-04-21 0:00:00'),	
(54365527,'2022-04-21 0:00:00'),	
(54367782,'2022-04-21 0:00:00'),	
(54368143,'2022-04-21 0:00:00'),	
(54368150,'2022-04-21 0:00:00'),	
(54368520,'2022-04-21 0:00:00'),	
(54368768,'2022-04-21 0:00:00'),	
(54369381,'2022-04-21 0:00:00'),	
(54369723,'2022-04-21 0:00:00'),	
(54369933,'2022-04-21 0:00:00'),	
(54370242,'2022-04-21 0:00:00'),	
(54370548,'2022-04-21 0:00:00'),	
(54371111,'2022-04-21 0:00:00'),	
(54371124,'2022-04-21 0:00:00'),	
(54371420,'2022-04-21 0:00:00'),	
(54371469,'2022-04-21 0:00:00'),	
(54371863,'2022-04-21 0:00:00'),	
(54373899,'2022-04-21 0:00:00'),	
(54374653,'2022-04-21 0:00:00'),	
(54376308,'2022-04-21 0:00:00'),	
(54376384,'2022-04-21 0:00:00'),	
(54376390,'2022-04-21 0:00:00'),	
(54378488,'2022-04-21 0:00:00'),	
(54379506,'2022-04-21 0:00:00'),	
(54379565,'2022-04-21 0:00:00'),	
(54381019,'2022-04-21 0:00:00'),	
(54381044,'2022-04-21 0:00:00'),	
(54381872,'2022-04-21 0:00:00'),	
(54381954,'2022-04-21 0:00:00'),	
(54384395,'2022-04-21 0:00:00'),	
(54384403,'2022-04-21 0:00:00'),	
(54385198,'2022-04-21 0:00:00'),	
(54387105,'2022-04-21 0:00:00'),	
(54387153,'2022-04-21 0:00:00'),	
(54389963,'2022-04-21 0:00:00'),	
(54391998,'2022-04-21 0:00:00'),	
(54393880,'2022-04-21 0:00:00'),	
(54394115,'2022-04-21 0:00:00'),	
(54394165,'2022-04-21 0:00:00'),	
(54394248,'2022-04-21 0:00:00'),	
(54394414,'2022-04-21 0:00:00'),	
(54397533,'2022-04-21 0:00:00'),	
(54399722,'2022-04-21 0:00:00'),	
(54402963,'2022-04-21 0:00:00'),	
(54403539,'2022-04-21 0:00:00'),	
(54403681,'2022-04-21 0:00:00'),	
(54404009,'2022-04-21 0:00:00'),	
(54405201,'2022-04-21 0:00:00'),	
(54405368,'2022-04-21 0:00:00'),	
(54406831,'2022-04-21 0:00:00'),	
(54409239,'2022-04-21 0:00:00'),	
(54409457,'2022-04-21 0:00:00'),	
(54410900,'2022-04-21 0:00:00'),	
(54411747,'2022-04-21 0:00:00'),	
(54413728,'2022-04-21 0:00:00'),	
(54170719,'2022-07-14 0:00:00'),	
(54192819,'2022-07-14 0:00:00'),	
(54156893,'2022-07-14 0:00:00'),	
(54169177,'2022-07-14 0:00:00'),	
(54174492,'2022-07-14 0:00:00'),	
(54177398,'2022-07-14 0:00:00'),	
(54180050,'2022-07-14 0:00:00'),	
(54267386,'2022-04-21 0:00:00'),	
(54268332,'2022-04-21 0:00:00'),	
(54268348,'2022-04-21 0:00:00'),	
(54268691,'2022-04-21 0:00:00'),	
(54268801,'2022-04-21 0:00:00'),	
(54269327,'2022-04-21 0:00:00'),	
(54269946,'2022-04-21 0:00:00'),	
(54269968,'2022-04-21 0:00:00'),	
(54270037,'2022-04-21 0:00:00'),	
(54270202,'2022-04-21 0:00:00'),	
(54270521,'2022-04-21 0:00:00'),	
(54278207,'2022-04-21 0:00:00'),	
(54283909,'2022-04-21 0:00:00'),	
(54284358,'2022-04-21 0:00:00'),	
(54285437,'2022-04-21 0:00:00'),	
(54285471,'2022-04-21 0:00:00'),	
(54275393,'2022-04-21 0:00:00'),	
(54286665,'2022-04-21 0:00:00'),	
(54287392,'2022-04-21 0:00:00'),	
(54288461,'2022-04-21 0:00:00'),	
(54288788,'2022-04-21 0:00:00'),	
(54289106,'2022-04-21 0:00:00'),	
(54289129,'2022-04-21 0:00:00'),	
(54289567,'2022-04-21 0:00:00'),	
(54290008,'2022-04-21 0:00:00'),	
(54290201,'2022-04-21 0:00:00'),	
(54291470,'2022-04-21 0:00:00'),	
(54291988,'2022-04-21 0:00:00'),	
(54293509,'2022-04-21 0:00:00'),	
(54297913,'2022-04-21 0:00:00'),	
(54298455,'2022-04-21 0:00:00'),	
(54300110,'2022-04-21 0:00:00'),	
(54302401,'2022-04-21 0:00:00'),	
(54302619,'2022-04-21 0:00:00'),	
(54304281,'2022-04-21 0:00:00'),	
(54304789,'2022-04-21 0:00:00'),	
(54306755,'2022-04-21 0:00:00'),	
(54310672,'2022-04-21 0:00:00'),	
(54314983,'2022-04-21 0:00:00'),	
(54315245,'2022-04-21 0:00:00'),	
(54316381,'2022-04-21 0:00:00'),	
(54316816,'2022-04-21 0:00:00'),	
(54318058,'2022-04-21 0:00:00'),	
(54318577,'2022-04-21 0:00:00'),	
(54318601,'2022-04-21 0:00:00'),	
(54319021,'2022-04-21 0:00:00'),	
(54267811,'2022-04-21 0:00:00'),	
(54267945,'2022-04-21 0:00:00'),	
(54267962,'2022-04-21 0:00:00'),	
(54268627,'2022-04-21 0:00:00'),	
(54268777,'2022-04-21 0:00:00'),	
(54268894,'2022-04-21 0:00:00'),	
(54271310,'2022-04-21 0:00:00'),	
(54273151,'2022-04-21 0:00:00'),	
(54276718,'2022-04-21 0:00:00'),	
(54276983,'2022-04-21 0:00:00'),	
(54277745,'2022-04-21 0:00:00'),	
(54281006,'2022-04-21 0:00:00'),	
(54281966,'2022-04-21 0:00:00'),	
(54272538,'2022-04-21 0:00:00'),	
(54283635,'2022-04-21 0:00:00'),	
(54284389,'2022-04-21 0:00:00'),	
(54284721,'2022-04-21 0:00:00'),	
(54285208,'2022-04-21 0:00:00'),	
(54285448,'2022-04-21 0:00:00'),	
(54286293,'2022-04-21 0:00:00'),	
(54286312,'2022-04-21 0:00:00'),	
(54287356,'2022-04-21 0:00:00'),	
(54289927,'2022-04-21 0:00:00'),	
(54290378,'2022-04-21 0:00:00'),	
(54290838,'2022-04-21 0:00:00'),	
(54292252,'2022-04-21 0:00:00'),	
(54292554,'2022-04-21 0:00:00'),	
(54293014,'2022-04-21 0:00:00'),	
(54293938,'2022-04-21 0:00:00'),	
(54294050,'2022-04-21 0:00:00'),	
(54294918,'2022-04-21 0:00:00'),	
(54294960,'2022-04-21 0:00:00'),	
(54296122,'2022-04-21 0:00:00'),	
(54297683,'2022-04-21 0:00:00'),	
(54298587,'2022-04-21 0:00:00'),	
(54300374,'2022-04-21 0:00:00'),	
(54303273,'2022-04-21 0:00:00'),	
(54305598,'2022-04-21 0:00:00'),	
(54306380,'2022-04-21 0:00:00'),	
(54308588,'2022-04-21 0:00:00'),	
(54308654,'2022-04-21 0:00:00'),	
(54309174,'2022-04-21 0:00:00'),	
(54310067,'2022-04-21 0:00:00'),	
(54310729,'2022-04-21 0:00:00'),	
(54312415,'2022-04-21 0:00:00'),	
(54313159,'2022-04-21 0:00:00'),	
(54313376,'2022-04-21 0:00:00'),	
(54316068,'2022-04-21 0:00:00'),	
(54316416,'2022-04-21 0:00:00'),	
(54321424,'2022-04-21 0:00:00'),	
(54321517,'2022-04-21 0:00:00'),	
(54321565,'2022-04-21 0:00:00'),	
(54321842,'2022-04-21 0:00:00'),	
(54322426,'2022-04-21 0:00:00'),	
(54322469,'2022-04-21 0:00:00'),	
(54322834,'2022-04-21 0:00:00'),	
(54323059,'2022-04-21 0:00:00'),	
(54324020,'2022-04-21 0:00:00'),	
(54324373,'2022-04-21 0:00:00'),	
(54324823,'2022-04-21 0:00:00'),	
(54325693,'2022-04-21 0:00:00'),	
(54328659,'2022-04-21 0:00:00'),	
(54329845,'2022-04-21 0:00:00'),	
(54331609,'2022-04-21 0:00:00'),	
(54332046,'2022-04-21 0:00:00'),	
(54334081,'2022-04-21 0:00:00'),	
(54334954,'2022-04-21 0:00:00'),	
(54335078,'2022-04-21 0:00:00'),	
(54336998,'2022-04-21 0:00:00'),	
(54341025,'2022-04-21 0:00:00'),	
(54341754,'2022-04-21 0:00:00'),	
(54342867,'2022-04-21 0:00:00'),	
(54344309,'2022-04-21 0:00:00'),	
(54344362,'2022-04-21 0:00:00'),	
(54339315,'2022-04-21 0:00:00'),	
(54340811,'2022-04-21 0:00:00'),	
(54345881,'2022-04-21 0:00:00'),	
(54347395,'2022-04-21 0:00:00'),	
(54347637,'2022-04-21 0:00:00'),	
(54348028,'2022-04-21 0:00:00'),	
(54348439,'2022-04-21 0:00:00'),	
(54348655,'2022-04-21 0:00:00'),	
(54348805,'2022-04-21 0:00:00'),	
(54350936,'2022-04-21 0:00:00'),	
(54351708,'2022-04-21 0:00:00'),	
(54351758,'2022-04-21 0:00:00'),	
(54351967,'2022-04-21 0:00:00'),	
(54352234,'2022-04-21 0:00:00'),	
(54352291,'2022-04-21 0:00:00'),	
(54353028,'2022-04-21 0:00:00'),	
(54353576,'2022-04-21 0:00:00'),	
(54356468,'2022-04-21 0:00:00'),	
(54359830,'2022-04-21 0:00:00'),	
(54360036,'2022-04-21 0:00:00'),	
(54360080,'2022-04-21 0:00:00'),	
(54360195,'2022-04-21 0:00:00'),	
(54361005,'2022-04-21 0:00:00'),	
(54351131,'2022-04-21 0:00:00'),	
(54361158,'2022-04-21 0:00:00'),	
(54361584,'2022-04-21 0:00:00'),	
(54322446,'2022-04-21 0:00:00'),	
(54322498,'2022-04-21 0:00:00'),	
(54322641,'2022-04-21 0:00:00'),	
(54323055,'2022-04-21 0:00:00'),	
(54323108,'2022-04-21 0:00:00'),	
(54323824,'2022-04-21 0:00:00'),	
(54325804,'2022-04-21 0:00:00'),	
(54326081,'2022-04-21 0:00:00'),	
(54326666,'2022-04-21 0:00:00'),	
(54328086,'2022-04-21 0:00:00'),	
(54330243,'2022-04-21 0:00:00'),	
(54331547,'2022-04-21 0:00:00'),	
(54331757,'2022-04-21 0:00:00'),	
(54331822,'2022-04-21 0:00:00'),	
(54331824,'2022-04-21 0:00:00'),	
(54332000,'2022-04-21 0:00:00'),	
(54333401,'2022-04-21 0:00:00'),	
(54335215,'2022-04-21 0:00:00'),	
(54336953,'2022-04-21 0:00:00'),	
(54338165,'2022-04-21 0:00:00'),	
(54338499,'2022-04-21 0:00:00'),	
(54338849,'2022-04-21 0:00:00'),	
(54338925,'2022-04-21 0:00:00'),	
(54341449,'2022-04-21 0:00:00'),	
(54342443,'2022-04-21 0:00:00'),	
(54344790,'2022-04-21 0:00:00'),	
(54344899,'2022-04-21 0:00:00'),	
(54347657,'2022-04-21 0:00:00'),	
(54348502,'2022-04-21 0:00:00'),	
(54348844,'2022-04-21 0:00:00'),	
(54349629,'2022-04-21 0:00:00'),	
(54349646,'2022-04-21 0:00:00'),	
(54351709,'2022-04-21 0:00:00'),	
(54352227,'2022-04-21 0:00:00'),	
(54352297,'2022-04-21 0:00:00'),	
(54352803,'2022-04-21 0:00:00'),	
(54353148,'2022-04-21 0:00:00'),	
(54353173,'2022-04-21 0:00:00'),	
(54353213,'2022-04-21 0:00:00'),	
(54353339,'2022-04-21 0:00:00'),	
(54353438,'2022-04-21 0:00:00'),	
(54353524,'2022-04-21 0:00:00'),	
(54353531,'2022-04-21 0:00:00'),	
(54354201,'2022-04-21 0:00:00'),	
(54354276,'2022-04-21 0:00:00'),	
(54354302,'2022-04-21 0:00:00'),	
(54355322,'2022-04-21 0:00:00'),	
(54358857,'2022-04-21 0:00:00'),	
(54359507,'2022-04-21 0:00:00'),	
(54359564,'2022-04-21 0:00:00'),	
(54360687,'2022-04-21 0:00:00'),	
(54360745,'2022-04-21 0:00:00'),	
(54361494,'2022-04-21 0:00:00'),	
(53865384,'2022-07-14 0:00:00'),	
(53877770,'2022-07-14 0:00:00'),	
(53909115,'2022-07-14 0:00:00'),	
(54020552,'2022-07-14 0:00:00'),	
(54096787,'2022-07-14 0:00:00'),	
(54125499,'2022-07-14 0:00:00'),	
(53611067,'2022-07-14 0:00:00'),	
(54087449,'2022-07-14 0:00:00'),	
(54099774,'2022-07-14 0:00:00'),	
(53899208,'2022-07-14 0:00:00'),	
(54101965,'2022-07-14 0:00:00'),	
(54102104,'2022-07-14 0:00:00'),	
(54114070,'2022-07-14 0:00:00'),	
(54121911,'2022-07-14 0:00:00'),	
(54135404,'2022-07-14 0:00:00'),	
(54145727,'2022-07-14 0:00:00'),	
(54150206,'2022-07-14 0:00:00'),	
(51064709,'2022-07-14 0:00:00'),	
(51071320,'2022-07-14 0:00:00'),	
(51225427,'2022-07-14 0:00:00'),	
(51236523,'2022-07-14 0:00:00'),	
(51643254,'2022-07-14 0:00:00'),	
(51671475,'2022-07-14 0:00:00'),	
(51827660,'2022-07-14 0:00:00'),	
(51926482,'2022-07-14 0:00:00'),	
(52324404,'2022-07-14 0:00:00'),	
(52801204,'2022-07-14 0:00:00'),	
(52802288,'2022-07-14 0:00:00'),	
(53466024,'2022-07-14 0:00:00'),	
(53543421,'2022-07-14 0:00:00'),	
(51026711,'2022-07-14 0:00:00'),	
(51227820,'2022-07-14 0:00:00'),	
(51243387,'2022-07-14 0:00:00'),	
(52140461,'2022-07-14 0:00:00'),	
(52169442,'2022-07-14 0:00:00'),	
(52265572,'2022-07-14 0:00:00'),	
(52353746,'2022-07-14 0:00:00'),	
(53081902,'2022-07-14 0:00:00'),	
(53308023,'2022-07-14 0:00:00'),	
(53398059,'2022-07-14 0:00:00'),	
(53456852,'2022-07-14 0:00:00'),	
(51546735,'2022-07-14 0:00:00'),	
(51982420,'2022-07-14 0:00:00'),	
(52284508,'2022-07-14 0:00:00'),	
(52813766,'2022-07-14 0:00:00'),	
(53083348,'2022-07-14 0:00:00'),	
(54240938,'2022-07-14 0:00:00'),	
(54241205,'2022-07-14 0:00:00'),	
(54242064,'2022-07-14 0:00:00'),	
(54248900,'2022-07-14 0:00:00'),	
(54250205,'2022-07-14 0:00:00')	

; WITH u AS
(
	select x.custid,x.accdate,x.totalamt,x.transtype 
	from tmp_Statement_UAT x with(nolock)
	INNER JOIN #tmp_Statement y ON x.custid = y.CustID AND x.accdate = y.ACcDate AND x.TransType = 'BET'
)
MERGE dbo.Statement AS t
USING u AS u ON t.CustId = u.CustId AND t.AccDate = u.accdate AND t.transtype = u.transtype
WHEN MATCHED THEN UPDATE
	SET TotalAmt = u.totalAmt
WHEN NOT MATCHED THEN
	INSERT(CustID, AccDate, TotalAmt, transtype)
	VALUES(u.CustID, u.AccDate, u.TotalAmt, u.transtype);

UPDATE  Statement_Accum_WrongBalance_UAT with(ROWLOCK, UPDLOCK)
SET IsFixed = 1
WHERE CustID IN (select x.CustID FROM  #tmp_Statement x)
AND CustID NOT IN (
54087449,
54096787,
54099774,
54101965,
54102104,
54121911,
54135404,
54145727,
54150206,
54156893,
54169177,
54170719,
54174492,
54177398,
54180050,
54192819,
54240938,
54241205,
54242064,
54248900,
54250205
)
*/

/*

INSERT INTO Statement_Accum (CustID, AccDate, TotalAmt)
select CustID, '2022-06-03' AccDate, TotalAmt  from #tmp_cust


DECLARE @balDate TABLE (balDate DATETIME)
INSERT INTO @balDate(balDate)
SELECT AccDate FROM Statement WITH(NOLOCK) WHERE CustID = 3 AND TransType = 'BAL'  AND accdate > '2022-06-03'
UNION  SELECT '2022-10-21' AS AccDate
ORDER BY AccDate ASC

DECLARE @i INT = 1, @CustID_Regen INT 
WHILE EXISTS (SELECT TOP 1 1 FROM #tmp_cust WHERE ID = @i)
BEGIN
	SELECT @CustID_Regen  =  CustID FROM #tmp_cust WHERE ID = @i 
	; with u AS
	(
	  SELECT b.balDate, x.totalAmt
	  FROM @balDate b
	  CROSS APPLY (
		  SELECT SUM(totalamt) totalamt
		  FROM Statement x with(nolock) 
		  where x.AccDate < b.balDate 
		  AND x.CustId = @CustID_Regen 
		  AND ( x.transtype NOT IN ('BAL','GP') OR  (x.transtype  = 'BAL' AND ACcDate = '2022-06-03')) 
		  AND ACcDate >= '2022-06-03'
	  ) x
	 )
		MERGE dbo.Statement_Accum AS t
		USING u AS u ON t.AccDate = u.balDate AND t.CustId = @CustID_Regen
		WHEN MATCHED THEN UPDATE
			SET TotalAmt = u.totalAmt
		WHEN NOT MATCHED THEN
			INSERT(CustID, AccDate, TotalAmt)
			VALUES(@CustID_Regen, u.balDate, u.TotalAmt);

	SELECT @i = @i + 1
END
*/