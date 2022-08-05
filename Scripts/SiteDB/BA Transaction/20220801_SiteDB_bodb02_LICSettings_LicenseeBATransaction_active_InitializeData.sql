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
INSERT INTO dbo.LICSettings (VName, VValue, VValue2)
SELECT 'BA_transid', NULL, NULL UNION ALL
SELECT 'BA_MaxOfFailedCount', '1', '' UNION ALL
SELECT 'BA_MissingTransID', '0', ''