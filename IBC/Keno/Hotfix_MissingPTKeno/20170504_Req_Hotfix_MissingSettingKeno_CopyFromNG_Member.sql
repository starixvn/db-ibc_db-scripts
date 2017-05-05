/*
	Created: 20170504@Helen
	Task: Keno - Missing PT setting for some accounts - [Redmine: 76020]

*/

CREATE TABLE #List2 (CustID INT PRIMARY KEY)

INSERT INTO #List2 (CustID)
SELECT DISTINCT custid
FROM custInfo WITH (NOLOCK)
WHERE custid IN (16262933,
16328621,
16352692,
16387778,
16568767,
16572860,
17012670,
17264067,
17380948,
17411171,
17455548,
17496622,
17504199,
17512467,
17525617,
17525673,
17528236,
17564590,
17597507,
17669429,
17669502,
17822241,
17828059,
18148548,
18203456,
19357366,
19357378,
19357400,
19357441,
19491308,
19744359,
19744376,
19744541,
19747592,
19747603,
19751693,
19751802,
19751828,
19771016,
20385988,
21028886,
21510405,
21570927,
21761622,
22173172,
22229061,
22229174,
22229253,
22253283,
22363005,
22391324,
22456707,
22484584,
22576376,
22822224,
23720001,
23940217,
24012546,
24182126,
24182185,
24266148,
24318160,
24371280,
24556305,
24722959,
24794391,
24902430,
24902451,
24965646,
25015191,
25015214,
25033381,
25069489,
25118824,
25167994,
25168031,
25168087,
25206218,
25220997,
25237177,
25240955,
25252508,
25423629,
25431936
)

UPDATE CSG
	 SET 
	  apositiontaking = csn.apositiontaking--apos
	 , mpositiontaking = csn.mpositiontaking --mpos
	 , spositiontaking  = csn.spositiontaking--spos
     , playerdiscount = csn.playerdiscount--pdis
	 , discount = csn.discount--dis
	 , adiscount = csn.adiscount--adis
	 , sdiscount = csn.sdiscount--sdis
	 , autopositiontaking = csn.autopositiontaking--autopos
     , isautopositiontaking = csn.isautopositiontaking --isautopos
	 , autompositiontaking = csn.autompositiontaking--autompos
	 , isautompositiontaking = csn.isautompositiontaking --isautompos
FROM CustSettingGame CSG WITH (ROWLOCK,UPDLOCK) 
	INNER JOIN #List2 L2 ON CSG.Custid = l2.custid
	INNER JOIN CustSetting3rd csn WITH (NOLOCK) ON L2.CustID = csn.CustID AND CSN.sporttype = 161 AND CSN.bettype  = 81
WHERE CSG.Sporttype = 202
	
	
