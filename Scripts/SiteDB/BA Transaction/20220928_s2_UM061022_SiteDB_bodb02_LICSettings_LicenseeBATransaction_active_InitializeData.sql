/*<info serverAlias="DBSID-bodb02"></info>*/
USE bodb02
GO
/*
	Created: 20220801@Evan
	DB: DBSID-bodb02
	Task: Initialize data for LICSettings,LicenseeBATransaction_active for SiteDB2 [RedmineID: #178145]
*/


-- LicenseeBATransaction_active : Migrate data

DECLARE @SiteDBGroupID SMALLINT;
SELECT @SiteDBGroupID = dbo.f_Get_SiteDBGroupID() -- 2

INSERT INTO LicenseeBATransaction_active(TransID,transdate,custid,recommend,srecommend)
SELECT l.TransID,l.transdate,l.custid,l.recommend,l.srecommend 
FROM DBLIC.bodb_Licensee.dbo.LicenseeBATransaction_active l WITH(NOLOCK)
	INNER JOIN CustDB.dbo.Dep_CustSuper d WITH(NOLOCK) ON d.custid = l.srecommend
WHERE	d.SiteDBGroupID = @SiteDBGroupID  
		AND site IN ('9Club','X2Dynamic','OneSports')
GO

-- LICSettings: Update Min - Max TransId flag for BA Transaction Job

DECLARE @SiteDBGroupID SMALLINT;
SELECT @SiteDBGroupID = dbo.f_Get_SiteDBGroupID()

DECLARE @VValue_SequenceID BIGINT ,@VValue2_SequenceID BIGINT;
DECLARE @VValue_TransID BIGINT = 0, @VValue2_TransID BIGINT = 0;
DECLARE @TransID1 BIGINT, @TransID2 BIGINT;

SELECT	@VValue_SequenceID = CAST(ISNULL(vvalue,0) AS BIGINT), 
		@VValue2_SequenceID = CAST(ISNULL(vvalue2,0) AS BIGINT) 
FROM	DBLIC.bodb_Licensee.dbo.LICSettings WITH (ROWLOCK) 
WHERE	vname = 'BA_transid'

SELECT	@TransID1 = TransId FROM DBCTG.bodb02.dbo.bettrans WITH(NOLOCK) WHERE sequenceid = @VValue_SequenceID
SELECT	@TransID2 = TransId FROM DBCTG.bodb02.dbo.bettrans WITH(NOLOCK) WHERE sequenceid = @VValue2_SequenceID

SELECT	@VValue_TransID = MAX(TransId) FROM bettrans WITH(NOLOCK) WHERE TransId <= @TransID1 AND SiteDBGroupID = @SiteDBGroupID
SELECT	@VValue2_TransID = MAX(TransId) FROM bettrans WITH(NOLOCK) WHERE TransId <= @TransID2 AND SiteDBGroupID = @SiteDBGroupID

INSERT INTO dbo.LICSettings (VName, VValue, VValue2)
SELECT 'BA_transid', @VValue_TransID, @VValue2_TransID UNION ALL
SELECT 'BA_MaxOfFailedCount', '1', '' UNION ALL
SELECT 'BA_MissingTransID', '0', ''