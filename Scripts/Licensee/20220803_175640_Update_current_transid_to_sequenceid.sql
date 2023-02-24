/*<info serverAlias="DBEXT-bodb02,DBACC-bodb02,DBBOF-bodb02,DBBAL-bodb02"></info>*/
/*
	Created: 20220803@Evan
	DB: DBEXT-bodb02,DBACC-bodb02,DBBOF-bodb02,DBBAL-bodb02
	Task: Change value setting transid to sequenceid [RedmineID: #175640]
*/

USE bodb02
GO

DECLARE @SequenceID1 BIGINT, @SequenceID2 BIGINT;
DECLARE @TransID1 BIGINT, @TransID2 BIGINT;

SELECT	@TransID1 = CAST(ISNULL(vvalue,0) AS BIGINT), 
		@TransID2 = CAST(ISNULL(vvalue2,0) AS BIGINT) 
FROM	bodb_licensee.dbo.LICSettings WITH (ROWLOCK) 
WHERE	vname = 'BA_transid'

SELECT	@SequenceID1 = SequenceID FROM bettrans WITH(NOLOCK) WHERE TransId = @TransID1
SELECT	@SequenceID2 = SequenceID FROM bettrans WITH(NOLOCK) WHERE TransId = @TransID2

UPDATE	bodb_licensee.dbo.LICSettings WITH(ROWLOCK)
SET		vvalue = CAST(@SequenceID1 AS VARCHAR(200)) ,
		vvalue2 = CAST(@SequenceID2 AS VARCHAR(200)) 
WHERE	vname = 'BA_transid'

GO
