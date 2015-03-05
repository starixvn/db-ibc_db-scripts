USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 20150203
	Task: Terminate licensee i668bet in LA site
	Task link : #30024
*/
/*
ChargeID 338,360,384,400,419,447
*/
DECLARE  @TerminateDate DATE , @PartyID INT
SELECT @PartyID = p.PartyID
		, @TerminateDate = '2015-01-26'
FROM dbo.OAS_Party p WITH (NOLOCK)
WHERE p.PartyName = 'i668bet'

UPDATE dbo.OAS_ChargeInfo WITH (ROWLOCK, UPDLOCK) 
SET ToDate = @TerminateDate
	, Remark = 'Terminate licensee #30024'
WHERE FromParty = @PartyID
	AND ToDate = '2050-01-01'