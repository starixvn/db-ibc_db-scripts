USE bodb02
GO

/*
	Created: 20190222@Ben (Reviewer: Sophia)
	Description: #109250: 12bet - Integrate IMone

	Run on dbpro/dbtrans
*/

--RUN ON DBPRO
--insert data for bettype table
IF NOT EXISTS (SELECT 1 FROM dbo.bettype WITH (NOLOCK) WHERE typeid = 22034)
BEGIN
	INSERT INTO dbo.bettype ( typeid , typenamee , typenamec , typedesc , typenamec_uni , ParentTypeid )
	VALUES (22034, 'DTRAIMone', 'DTRAIMone', 'E-Sports IMone Transfer', 'DTRAIMone', 22034)
END

IF NOT EXISTS (SELECT 1 FROM dbo.bettype WITH (NOLOCK) WHERE typeid = 22035)
BEGIN
	INSERT INTO dbo.bettype (typeid, typenamee, typenamec, typedesc, typenamec_uni, ParentTypeid)
	VALUES (22035, 'DCANIMone', 'DCANIMone', 'E-Sports IMone Cancel Transfer', 'DCANIMone', 22035)	
END

--RUN ON DBTRANS
--insert data for ThirdPartySetting table
IF NOT EXISTS (SELECT 1 FROM dbo.ThirdPartySetting WITH (NOLOCK) WHERE ThirdPartyType = 14)
BEGIN
    INSERT INTO dbo.ThirdPartySetting (ThirdPartyType, ThirdPartyName, TransferBettype, CancelBettype)           
    VALUES  ( 14 , 'IMone' , 22034 , 22035 )
END

GO

