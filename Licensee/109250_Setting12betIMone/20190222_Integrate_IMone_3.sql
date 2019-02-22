USE bodb_Report
GO

/*
	Created: 20190222@Ben (Reviewer: Sophia)
	Description: #109250: 12bet - Integrate IMone

	Run on db06.bodb02
*/

IF NOT EXISTS (SELECT 1 FROM dbo.tblCasinoPartners WITH(NOLOCK) WHERE PartnerId = 14)
BEGIN
	INSERT INTO dbo.tblCasinoPartners(PartnerId, PartnerName, TransferId, CancelTransferId)
	VALUES(14, 'IMone', 22034, 22035)
END

GO

