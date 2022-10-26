/*<info serverAlias="DBLIC-bodb_LicenseeReport,DBPTSC-bodb_PlaytechCS"></info>*/

/*
	Created: 20221026@Sophia
	Task : Sync DB052 from DB053 due to inconsistency data [Redmine: #179594]
	DB: DB052.bodb_LicenseeReport , DB052.bodb_PlaytechCS 
	Note: RUN at DB052 ONLY
	Description: 

		Jun :  
			   2022-06-01 table rpt_BettingByProduct, rpt_Betting , productID = 45 AE Sexy, siteID = 24 
		July:  
			   2022-07-07  table rpt_BettingByProduct, rpt_Betting,  productID = 0 Sportsbook, siteID = 2 
			   2022-07-05  table rpt_BettingByProduct, productID = 10, siteID = 1,19,22 
	 

*/
USE bodb_LicenseeReport

----I. Jun
-------1a.rpt_BettingByProduct

--SELECT DB052.Turnover, DB053.Turnover
--FROM rpt_BettingByProduct DB052 WITH (NOLOCK) 
--INNER JOIN DB053.bodb_LicenseeReport.dbo.rpt_BettingByProduct AS DB053 WITH (NOLOCK) 
--ON DB052.rptDate = DB053.rptDate AND DB052.productID = DB053.productID AND DB052.siteID = DB053.siteID AND DB052.StatusID = DB053.StatusID 
--WHERE DB053.rptDate ='2022-06-01' AND DB053.productID = 45 AND DB053.siteID = 24 AND DB053.StatusID = 113
--- 1 row

UPDATE DB052
SET Turnover = DB053.Turnover
FROM rpt_BettingByProduct DB052 WITH (ROWLOCK) 
INNER JOIN DB053.bodb_LicenseeReport.dbo.rpt_BettingByProduct AS DB053 WITH (NOLOCK) 
ON DB052.rptDate = DB053.rptDate AND DB052.productID = DB053.productID AND DB052.siteID = DB053.siteID AND DB052.StatusID = DB053.StatusID 
WHERE DB052.rptDate ='2022-06-01' AND DB052.productID = 45 AND DB052.siteID = 24 AND DB052.StatusID = 113 


-------1b.rpt_Betting 
--SELECT DB052.Turnover, DB053.Turnover
--FROM rpt_Betting DB052 WITH (NOLOCK) 
--INNER JOIN DB053.bodb_LicenseeReport.dbo.rpt_Betting  AS DB053 WITH (NOLOCK) 
--ON DB052.rptDate = DB053.rptDate AND DB052.Bettype = DB053.Bettype AND DB052.siteID = DB053.siteID AND DB052.Status = DB053.Status 
--WHERE DB052.rptDate ='2022-06-01' AND DB052.Bettype = 3104 AND DB052.siteID = 24 AND  DB052.Status = 113
--- 1 row

UPDATE DB052
SET Turnover = DB053.Turnover
FROM rpt_Betting DB052 WITH (ROWLOCK) 
INNER JOIN DB053.bodb_LicenseeReport.dbo.rpt_Betting AS DB053 WITH (NOLOCK) 
ON DB052.rptDate = DB053.rptDate AND DB052.Bettype = DB053.Bettype AND DB052.siteID = DB053.siteID AND DB052.Status = DB053.Status 
WHERE DB052.rptDate ='2022-06-01' AND DB052.Bettype = 3104 AND DB052.siteID = 24 AND  DB052.Status = 113


----------------------------------
----II. July
-------2a.rpt_BettingByProduct

--SELECT DB052.* , DB053.*
--FROM rpt_BettingByProduct DB052 WITH (NOLOCK) 
--INNER JOIN DB053.bodb_LicenseeReport.dbo.rpt_BettingByProduct AS DB053 WITH (NOLOCK) 
--ON DB052.rptDate = DB053.rptDate AND DB052.productID = DB053.productID AND DB052.siteID = DB053.siteID AND DB052.StatusID = DB053.StatusID AND DB052.CurrencyId = DB053.CurrencyId 
--WHERE DB052.rptDate ='2022-07-07' AND DB052.productID = 0 AND DB052.siteID = 2  
--and DB052.statusID IN (112, 115) and DB052.CurrencyId = 51
-- 2 rows

UPDATE DB052
SET GrossWL = DB053.GrossWL
,MemberWL = DB053.MemberWL
,Turnover = DB053.Turnover
,BetCount = DB053.BetCount
,ValidBetAmount = DB053.ValidBetAmount
FROM rpt_BettingByProduct DB052 WITH (ROWLOCK) 
INNER JOIN DB053.bodb_LicenseeReport.dbo.rpt_BettingByProduct AS DB053 WITH (NOLOCK) 
ON DB052.rptDate = DB053.rptDate AND DB052.productID = DB053.productID AND DB052.siteID = DB053.siteID AND DB052.StatusID = DB053.StatusID AND DB052.CurrencyId = DB053.CurrencyId 
WHERE DB052.rptDate ='2022-07-07' AND DB052.productID = 0 AND DB052.siteID = 2  
and DB052.statusID IN (112, 115) and DB052.CurrencyId = 51

-------2b.rpt_Betting

--SELECT DB052.*, DB053.*
--FROM rpt_Betting DB052 WITH (NOLOCK) 
--INNER JOIN DB053.bodb_LicenseeReport.dbo.rpt_Betting  AS DB053 WITH (NOLOCK) 
--ON DB052.rptDate = DB053.rptDate AND DB052.Bettype = DB053.Bettype AND DB052.siteID = DB053.siteID 
--AND DB052.Status = DB053.Status AND  DB052.IsLive = DB053.IsLive AND DB052.CurrencyId = DB053.CurrencyId 
--AND DB052.LeagueID = DB053.LeagueID  
--WHERE DB052.rptDate ='2022-07-07' AND  DB052.siteID = 2  
--and DB052.status  IN (112, 115) and DB052.CurrencyId = 51 and DB052.bettype = 1 AND DB052.LeagueID = 95731
-- 3 rows

UPDATE DB052
SET BetCount = DB053.BetCount
,WinLoss = DB053.WinLoss
,WinLossA = DB053.WinLossA
,WinLossVirtual = DB053.WinLossVirtual
,oddsspread = DB053.oddsspread
FROM rpt_Betting DB052 WITH (ROWLOCK) 
INNER JOIN DB053.bodb_LicenseeReport.dbo.rpt_Betting  AS DB053 WITH (NOLOCK) 
ON DB052.rptDate = DB053.rptDate AND DB052.Bettype = DB053.Bettype AND DB052.siteID = DB053.siteID 
AND DB052.Status = DB053.Status AND  DB052.IsLive = DB053.IsLive AND DB052.CurrencyId = DB053.CurrencyId 
AND DB052.LeagueID = DB053.LeagueID  
WHERE DB052.rptDate ='2022-07-07' AND  DB052.siteID = 2  
and DB052.status  IN (112, 115) and DB052.CurrencyId = 51 and DB052.bettype = 1 AND DB052.LeagueID = 95731


-------2c.rpt_BettingByProduct

--SELECT DB052.* , DB053.*
--FROM rpt_BettingByProduct DB052 WITH (NOLOCK) 
--INNER JOIN DB053.bodb_LicenseeReport.dbo.rpt_BettingByProduct AS DB053 WITH (NOLOCK) 
--ON DB052.rptDate = DB053.rptDate AND DB052.productID = DB053.productID AND DB052.siteID = DB053.siteID AND DB052.StatusID = DB053.StatusID AND DB052.CurrencyId = DB053.CurrencyId 
--WHERE DB052.rptDate ='2022-07-05' AND DB052.productID = 10 AND DB052.siteID IN (1,19,22)   
-- 12 rows

UPDATE DB052
SET MemberWL = DB053.MemberWL
,Turnover = DB053.Turnover
,BetCount = DB053.BetCount  
FROM rpt_BettingByProduct DB052 WITH (ROWLOCK) 
INNER JOIN DB053.bodb_LicenseeReport.dbo.rpt_BettingByProduct AS DB053 WITH (NOLOCK) 
ON DB052.rptDate = DB053.rptDate AND DB052.productID = DB053.productID AND DB052.siteID = DB053.siteID AND DB052.StatusID = DB053.StatusID AND DB052.CurrencyId = DB053.CurrencyId 
WHERE DB052.rptDate ='2022-07-05' AND DB052.productID = 10 AND DB052.siteID IN (1,19,22)   

 