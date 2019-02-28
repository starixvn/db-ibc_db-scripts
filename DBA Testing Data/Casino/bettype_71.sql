INSERT INTO bodb02.dbo.bettrans
(
	custid,transdate,oddsid,hdp1,hdp2,odds,stake,actual_stake,status,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,
	apositiontaking,mpositiontaking,spositiontaking,tpositiontaking,playerdiscount,discount,adiscount,sdiscount,livehomescore,liveawayscore,
	liveindicator,betteam,creator,refno,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,matchid,recommend,mrecommend,srecommend,
	ruben,betid,statuswinlost,modds,betdaqid,currency,ip,transdesc,virtualrate,oddstype,statusID,currency2,bettype,balance,transid2,
	SecAcceptFlag,recommdate,comstatus,ExtraInfo
)
VALUES
(
	18660740,'2017-10-01 03:41:04.213',0,0.00,0.00,0.00,2457.50,2457.50,'WON',3079.50,0.00,-404.30,-93.30,0.00,0.00,4.3006,2.4575,
	0.00,0.65,0.15,0.80,0.00000000,0.00000000,0.00000000,0.00000000,0,0,
	0,NULL,18660740,100748565049,'2017-10-01 00:00:00','i',0,NULL,NULL,2E-102,0,18654595,1651752,1426163,
	1,945,NULL,1.00,NULL,20,'059.103.164.059','Casino Betting',2E-102,NULL,112,NULL,71,NULL,NULL,
	NULL,NULL,0,NULL
)

SELECT *
FROM bodb02.dbo.bettrans WITH (NOLOCK)
WHERE bettype = 71

UPDATE bodb02.dbo.bettrans WITH (ROWLOCK, UPDLOCK)
SET winlostdate = '20170926'
WHERE transid = 102683011260

SELECT *
FROM CustDB.dbo.Customer WITH (NOLOCK) WHERE custid = 18660740