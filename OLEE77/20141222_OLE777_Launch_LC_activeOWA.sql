USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date  : 2014-12-22
	Task : #27972 OLE777 - Launch of Live Casino
*/
CREATE TABLE #data (PartyID INT, EffectiveDate DATE, Todate DATE)
	 INSERT INTO #data
SELECT PartyID,'2014-12-18','2050-01-01' FROM dbo.OAS_Party WITH (NOLOCK) WHERE PartyName = 'OLE777' AND PartyType = 1

INSERT INTO OAS_ChargeInfo_xtest ( ProductID, FromParty, ToParty, ParentChargeID, Rate, ChargeType, FromDate, ToDate, MinAmount, MaxAmount)
SELECT  4
	  ,d.PartyID
	  ,1
	  ,0
	  ,0.07
	  ,1
	  ,d.EffectiveDate
	  ,d.Todate
	  ,NULL 
	  ,NULL
FROM #data d
--Insert to mapping
DECLARE @ChargeID INT
SELECT @ChargeID = MAX(ChargeID) FROM dbo.OAS_ChargeInfo_xtest
INSERT INTO dbo.LA_ChargeInfo_SystemMapping(ChargeID,SystemID)
SELECT @ChargeID, 4