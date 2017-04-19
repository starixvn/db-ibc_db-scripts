/*
	Create: Helen
	Task: [Incident] - Missing Customer Setting - 19 Apr, 2017
	DB: DBCUST/CUSTDB
	
*/

CREATE TABLE #Cust_MissingSetting (Custid INT, Roleid INT)
INSERT INTO #Cust_MissingSetting (Custid,Roleid)
SELECT c.custid,roleid
FROM Customer c WITH (NOLOCK)
WHERE c.username IN (
'JWL6789139',
'JWL6789138',
'JWL6789136',
'SD8F0802005',
'SJK652209002',
'SD5F0102222',
'SD831025245',
'TV7E1221009',
'HPVDM99987',
'B6TKY77210',
'DTC35D1',
'FC132D0T002',
'ZA940725X04',
'SCHB20003',
'DTC35DC01',
'SCHB20002',
'DX540411002',
'BV391504000',
'TY81240200J',
'DX540411001',
'S88DWW88260',
'S88DWW88261',
'S88DWW88262',
'HDZ788123',
'HDZ788000')

DELETE FROM dbo.custSetting WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.CustProductStatus WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.custOverride WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.CustPTSetting3rd_Agent WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.CustPTSetting3rd_Member WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.CustSettingMode3rd WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.CustStakeLevel_Agent WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.CustStakeLevel_Member WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)

DELETE FROM dbo.CustWinLossLimit_Agent WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.CustWinLossLimit_Member WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.CustCommRate WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.CustSetting3rd WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.CustSettingGame WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.CustVirtualSetting WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.CustBetSetting3rd_Agent WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.CustBetSetting3rd_Member WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.CustDiscount3rd_Member WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.CustDiscount3rd_Agent WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM dbo.custOverride3rd WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM customer WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM custinfo WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM CustWinLimit WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM CustSuper WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM CustMaster WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM CustAgent WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM CustLoginInfo WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM P2PGAMESETTING WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM P2PGroupComm WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM CustOverrideGame WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM CustGameType WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM AgentCommRate WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM CustCommRate WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)

DELETE FROM DBTXN.bodb02.dbo.BalCreditSports WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM DBTXN.bodb02.dbo.BalCreditTransfer WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM DBTXN.bodb02.dbo.BalCreditCasino WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM DBTXN.bodb02.dbo.BalCreditOthers WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)

DELETE FROM DBTXN.bodb02.dbo.BalDebitSports WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM DBTXN.bodb02.dbo.BalDebitTransfer WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM DBTXN.bodb02.dbo.BalDebitCasino WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
DELETE FROM DBTXN.bodb02.dbo.BalDebitOthers WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)

DELETE FROM CustPTGroupSetting3rd_Member WHERE custid IN (SELECT custid FROM #Cust_MissingSetting)
	
