/*<info serverAlias="DBPRO-bodb02"></info>*/

USE bodb02
GO

/*
	Created: 20201111@Danny
	DB: DBPRO.bodb02
	Task: Update SportBetTypeMatrix.SubProduct from 'PHAIO' to ' '
*/

UPDATE b
SET b.SubProduct = ''
FROM dbo.SportBettypeMatrix b with(ROWLOCK)
WHERE  b.SubProduct = 'PHAIO'
GO
