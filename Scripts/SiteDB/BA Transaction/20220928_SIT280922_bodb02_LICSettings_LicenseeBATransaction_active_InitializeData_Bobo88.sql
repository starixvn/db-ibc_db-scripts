/*<info serverAlias="DBSID-bodb02"></info>*/
USE bodb02
GO
/*
	Created: 20220928@Evan
	DB: DBSID-bodb02 (run SiteDB2 only)
	Task: Initialize data for LICSettings,LicenseeBATransaction_active [RedmineID: #178145]
*/

-- Step 1: Migrate data of BATransaction table 

DECLARE @SiteDBGroupID SMALLINT;
SELECT @SiteDBGroupID = dbo.f_Get_SiteDBGroupID() -- 2

INSERT INTO LicenseeBATransaction_active(TransID,transdate,custid,recommend,srecommend)
SELECT l.TransID,l.transdate,l.custid,l.recommend,l.srecommend 
FROM DBLIC.bodb_Licensee.dbo.LicenseeBATransaction_active l WITH(NOLOCK)
	INNER JOIN CustDB.dbo.Dep_CustSuper d WITH(NOLOCK) ON d.custid = l.srecommend
WHERE	d.SiteDBGroupID = @SiteDBGroupID  
		AND site IN ('Bobo88')
GO

-- Step 2: Update Min - Max TransId flag for BA Transaction Job
DECLARE @SiteDBGroupID SMALLINT;
SELECT @SiteDBGroupID = dbo.f_Get_SiteDBGroupID()

DECLARE @VValue_SequenceID BIGINT, @TransID BIGINT;
DECLARE @VValue_TransID BIGINT = 0;

SELECT	@VValue_SequenceID = CAST(ISNULL(vvalue,0) AS BIGINT) 
FROM	DBLIC.bodb_Licensee.dbo.LICSettings WITH (ROWLOCK) 
WHERE	vname = 'BA_transid'

SELECT	@TransID = TransId FROM DBCTG.bodb02.dbo.bettrans WITH(NOLOCK) WHERE sequenceid = @VValue_SequenceID
SELECT	@VValue_TransID = MAX(TransId) FROM bettrans WITH(NOLOCK) WHERE TransId <= @TransID AND SiteDBGroupID = @SiteDBGroupID

UPDATE dbo.LICSettings WITH(ROWLOCK) SET VValue2 = ISNULL(@VValue_TransID,0), VValue = ISNULL(@VValue_TransID,0) WHERE vname = 'BA_transid'