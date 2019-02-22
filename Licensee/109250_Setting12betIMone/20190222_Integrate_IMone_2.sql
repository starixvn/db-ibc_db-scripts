USE bodb02
GO

/*
	Created: 20190222@Ben (Reviewer: Sophia)
	Description: #109250: 12bet - Integrate IMone

	Run on dbtrans.bodb02
*/
 
--RUN ON DBTRANS
--insert data for ThirdPartySetting table
IF NOT EXISTS (SELECT 1 FROM dbo.ThirdPartySetting WITH (NOLOCK) WHERE ThirdPartyType = 14)
BEGIN
    INSERT INTO dbo.ThirdPartySetting (ThirdPartyType, ThirdPartyName, TransferBettype, CancelBettype)           
    VALUES  ( 14 , 'IMone' , 22034 , 22035 )
END

GO

