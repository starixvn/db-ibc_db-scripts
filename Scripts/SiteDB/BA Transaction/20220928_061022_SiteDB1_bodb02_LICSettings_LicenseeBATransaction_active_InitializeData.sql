/*<info serverAlias="DBSID-bodb02"></info>*/
USE bodb02
GO
/*
	Created: 20220928@Evan
	DB: DBSID-bodb02 
	Task: Initialize data for LICSettings,LicenseeBATransaction_active SiteDB1 (Migration 100 Lics) [RedmineID: #178145]
*/


-- Step 1: Migrate data of BATransaction table 

DECLARE @SiteDBGroupID SMALLINT;
SELECT @SiteDBGroupID = dbo.f_Get_SiteDBGroupID() -- 1

INSERT INTO LicenseeBATransaction_active(TransID,transdate,custid,recommend,srecommend)
SELECT l.TransID,l.transdate,l.custid,l.recommend,l.srecommend 
FROM DBLIC.bodb_Licensee.dbo.LicenseeBATransaction_active l WITH(NOLOCK)
	INNER JOIN CustDB.dbo.Dep_CustSuper d WITH(NOLOCK) ON d.custid = l.srecommend
WHERE	d.SiteDBGroupID = @SiteDBGroupID  
		AND site IN ('24Tech','MRCATSB','24AVIA','ig128','A1game','txwl002','weicai','shengboyun','633esports','pmwint','Diamond','ig128s','442ball','asiabet88','TLC','JBO','Betway','KingFun',
			'IBO','Kzing2','MANBETX','LS88','TH3','V03','XTSB','KZO41','kzsbxjCV','Nexus','IGPTech','AJJCV','KeenOcean','K8VN','Storm88','liv66','liv66SW','win365','livv88sw','WINHX1','KhmerG',
			'afb99','khmer','ManCity','Mancity2','N88','N8B','N8G','NukeGaming','Pay4d','Weiwei','Avia','MARS','AnvoFH','erhaozhan','TCbet','TaoCai','FHLMSABA','Titank','FHLMSABAS','Sunrise',
			'Sunriseb2b','SunriseCV','Wanfang','KUTECH','GamingSoft','Dade','Nbbet','BetDeal','Xtu168','GSCSW','Yibo','YiboCV','JIDU','Wanbo','ZhiFeng032','ZhiFeng036','ZhiFeng035','ZhiFeng021',
			'ZhiFeng009','ZFRT082','mtegames','ZhiFeng037','ZFRT125','ZFRT133','NewFuture','ZFRT132','ZhiFeng040','ZFRT128','ZFRT080','JIB88','ZhiFeng012','ZFRT115','ZFRT142','SAGAME88','ZFRT150',
			'ZFRT081','NextBet','IONclub','Ae88','Liga','ISC888')
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
