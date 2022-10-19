/*<info serverAlias="DBSID-bodb02"></info>*/
USE bodb02
GO
/*
	Created: 20220928@Evan
	DB: DBSID-bodb02 (run SiteDB2 only)
	Task: Initialize data for LICSettings,LicenseeBATransaction_active for SiteDB1 (100 Lics) [RedmineID: #178142]
*/


-- Step 1: Migrate data of BATransaction table 

DECLARE @SiteDBGroupID SMALLINT;
SELECT @SiteDBGroupID = dbo.f_Get_SiteDBGroupID()  -- 1

INSERT INTO LicenseeBATransaction_active(TransID,transdate,custid,recommend,srecommend)
SELECT l.TransID,l.transdate,l.custid,l.recommend,l.srecommend 
FROM DBLIC.bodb_Licensee.dbo.LicenseeBATransaction_active l WITH(NOLOCK)
	INNER JOIN CustDB.dbo.Dep_CustSuper d WITH(NOLOCK) ON d.custid = l.srecommend
WHERE	d.SiteDBGroupID = @SiteDBGroupID  
		AND site IN ('NLDSports', 'XmenSW', 'OCMSS', 'LIGAWLHKB', 'DTGJZ', 'TXJT', '3star88', 'ECLBET', 'Mybet88', 'WINCLUB88', 'INSERTGAME', 'Alphalota', 'Barcelo9', 'Aladdin99', 'BVCLLC', 'Jiuyou', 'Yintai', 'Letian', 'WRServices', 'Xiaoxiang', 'YakaGaming', '5ATech', 'IGSW', 'HBPT', 'TSLA', 'WRSeamless', 'TYgaming', 'KSTECH2', 'De365', 'UGaming', '0sServices', 'ZhiFeng019', 'mbxusdt', 'GoldenF2', 'ZhiFeng173', 'UNOGAMING', 'ZTech', 'XLMEDIA', 'AEUGSW', '24aviaCV', 'ACsports', 'FLCSW', 'GoldenFCV', 'HaHaGaming', 'HOroyal', 'IDNSPORT', 'IDNUPVND', 'JDJDAPI', 'JUNBOVN', 'KzingP88', 'KZSW', 'MultiSL88', 'OXPLAY', 'SGM88', 'STEBBCBI', 'TYgamingSW', 'WSlots', 'yuanbaoCV', 'ZF133FIN2', 'ZF215CNY', 'ZF267SW', 'ZF271SW', 'ZFRT155new', 'ZFRT159', 'ZFRT175', 'ZFRT179', 'ZFRT219', 'ZFRT240', 'ZFRT242', 'ZFRT259', 'ZFRT263', 'ZFRT80GPGT', 'ZhiFeng041', 'ZhiFeng050', 'ZhiFeng051', 'ZhiFeng094', 'ZhiFeng107', 'ZhiFeng116', 'ZhiFeng132', 'ZhiFeng168', 'ZhiFeng176', 'ZhiFeng200', 'ZhiFeng204', 'ZhiFeng221', 'ZhiFeng223', 'ZhiFeng228', 'ZhiFeng242', 'ZhiFeng248', 'ZhiFeng253', 'ZhiFeng255', 'ZhiFeng262', 'ZhiFeng266', 'ZhiFeng267', 'ZhiFeng271', 'ZhiFeng030','M18SW','ZFRT264','LG777','ZF138USD','ZhiFeng282')
GO
		

-- Step 2: Update Min - Max TransId flag for BA Transaction Job

DECLARE @SiteDBGroupID SMALLINT;
SELECT @SiteDBGroupID = dbo.f_Get_SiteDBGroupID()

DECLARE @VValue2_SequenceID BIGINT, @TransID BIGINT;
DECLARE @VValue2_TransID BIGINT = 0;

SELECT	@VValue2_SequenceID = CAST(ISNULL(vvalue2,0) AS BIGINT) 
FROM	DBLIC.bodb_Licensee.dbo.LICSettings WITH (ROWLOCK) 
WHERE	vname = 'BA_transid'

SELECT	@TransID = TransId FROM DBCTG.bodb02.dbo.bettrans WITH(NOLOCK) WHERE sequenceid = @VValue2_SequenceID
SELECT	@VValue2_TransID = MAX(TransId) FROM bettrans WITH(NOLOCK) WHERE TransId <= @TransID AND SiteDBGroupID = @SiteDBGroupID

UPDATE dbo.LICSettings WITH(ROWLOCK) SET VValue2 = ISNULL(@VValue2_TransID,0) WHERE vname = 'BA_transid'