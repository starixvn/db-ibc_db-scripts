/*<info serverAlias="DBSID-bodb02"></info>*/
USE bodb02
GO
/*
	Created: 20220801@Evan
	DB: DBSID-bodb02
	Task: Initialize data for LICSettings,LicenseeBATransaction_active [RedmineID: #175297]
*/


-- LicenseeBATransaction_active
DECLARE @SiteDBGroupID SMALLINT;
SELECT @SiteDBGroupID = dbo.f_Get_SiteDBGroupID()

INSERT INTO LicenseeBATransaction_active(TransID,transdate,custid,recommend,srecommend)
SELECT l.TransID,l.transdate,l.custid,l.recommend,l.srecommend 
FROM DBLIC.bodb_Licensee.dbo.LicenseeBATransaction_active l WITH(NOLOCK)
	INNER JOIN CustDB.dbo.Dep_CustSuper d WITH(NOLOCK) ON d.custid = l.srecommend
WHERE d.SiteDBGroupID = @SiteDBGroupID



GO


-- LICSettings

DECLARE @SiteDBGroupID SMALLINT;
SELECT @SiteDBGroupID = dbo.f_Get_SiteDBGroupID()

DECLARE @SequenceID1 BIGINT, @SequenceID2 BIGINT;
DECLARE @TransID1 BIGINT, @TransID2 BIGINT;
DECLARE @TransID1_sitedb BIGINT = 0, @TransID2_sitedb BIGINT = 0;

SELECT	@SequenceID1 = CAST(ISNULL(vvalue,0) AS BIGINT), 
		@SequenceID2 = CAST(ISNULL(vvalue2,0) AS BIGINT) 
FROM	DBLIC.bodb_Licensee.dbo.LICSettings WITH (ROWLOCK) 
WHERE	vname = 'BA_transid'

SELECT	@TransID1 = TransId FROM DBCTG.bodb02.dbo.bettrans WITH(NOLOCK) WHERE sequenceid = @SequenceID1
SELECT	@TransID2 = TransId FROM DBCTG.bodb02.dbo.bettrans WITH(NOLOCK) WHERE sequenceid = @SequenceID2

SELECT	@TransID1_sitedb = MAX(TransId) FROM bettrans WITH(NOLOCK) WHERE TransId <= @TransID1 AND SiteDBGroupID = @SiteDBGroupID
SELECT	@TransID2_sitedb = MAX(TransId) FROM bettrans WITH(NOLOCK) WHERE TransId <= @TransID2 AND SiteDBGroupID = @SiteDBGroupID


INSERT INTO dbo.LICSettings (VName, VValue, VValue2)
SELECT 'BA_transid', @TransID1_sitedb, @TransID2_sitedb UNION ALL
SELECT 'BA_MaxOfFailedCount', '1', '' UNION ALL
SELECT 'BA_MissingTransID', '0', ''