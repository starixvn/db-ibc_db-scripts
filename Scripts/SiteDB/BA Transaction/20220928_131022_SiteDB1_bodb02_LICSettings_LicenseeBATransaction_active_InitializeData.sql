/*<info serverAlias="DBSID-bodb02"></info>*/
USE bodb02
GO
/*
	Created: 20220928@Evan
	DB: DBSID-bodb02 
	Task: Initialize data for LICSettings,LicenseeBATransaction_active for SiteDB1 ((Migration 153 Lics)) [RedmineID: #178145]
*/


-- Step 1: Migrate data of BATransaction table 

DECLARE @SiteDBGroupID SMALLINT;
SELECT @SiteDBGroupID = dbo.f_Get_SiteDBGroupID() -- 1

INSERT INTO LicenseeBATransaction_active(TransID,transdate,custid,recommend,srecommend)
SELECT l.TransID,l.transdate,l.custid,l.recommend,l.srecommend 
FROM DBLIC.bodb_Licensee.dbo.LicenseeBATransaction_active l WITH(NOLOCK)
	INNER JOIN CustDB.dbo.Dep_CustSuper d WITH(NOLOCK) ON d.custid = l.srecommend
WHERE	d.SiteDBGroupID = @SiteDBGroupID  
		AND site IN ('allwincity','allwinCV','bdtt','bdtt2','GB888CV','Bobbet','Tianbo','DingTai','MTech','Omni88','e8casino','e8casinoCV','GoldenF','LEIHUO','DongYing',
			'bmwbet','HIDZ','HONBET','Newhonbet','HOT99','XTDGT','LLgaming','AEUG','UG2','JJBGAME','VKGAME','JJBGAMECV','VKGAMECV','KOKVN','KOKVN2','Lucky88','11bet','Fabet',
			'One88','Debet','Zbet','Sin88','Sunwin','Five88','Red88','Lode88','Zowin','SV88','Nbet','OXbet','Sky88','SM88','SL88SW','Okada','BPLE','OkadaSW','SunGame','Sun988',
			'SSSSEA','Ty777','Mopgaming','Raisetech','TopGame','ZFRT143','ZFRT166','ZhiFeng055','ZFRT156','ZhiFeng106','ZhiFeng122','ZFRT129','ZhiFeng098','ZFRT165','ZFRT144',
			'ZhiFeng147','ZFRT155','ZhiFeng026','ZFRT186','ZhiFeng156','ZhiFeng133','ZFRT126CV','ZFRT126','CENTRAL168','ZFRT090','ZF055PMW','ZFRT195','ZhiFeng138','ZhiFeng183',
			'ZhiFeng013','ZFRT167','ZF138THB','ZFRT144CV','ZF138VND','ZFRT161','ZhiFeng201','ZFRT158CV','Zhifeng215','ZhiFeng208','ZFRT213','ZhiFeng222','Zzun88','Man1878',
			'iBET','Xinbo','HonorW','M8Credit','FLC','OCMS','dj888','JIBET','awc2','YongBao','Datang001','infini88','Hecbet','Royal','vssports','DEWA','88Macao','9wickets',
			'LSM99','Leng4D','Bonanza88','Senibet','WBS','OPEBET','DFGame','OYO','awc','loc','wmcasino','OESports','yuanbao','Rakyat4DSW','GBET','Towin','C7YOUXICV','SEAL888',
			'ZF026','starsoccer','24AVIASL','H1royal','HFYX','ZhiFeng142','ZFRT218','KSTECH','WLSTAR','ZFRT198','F88IN1SW','ZhiFeng084','GoldenF2CV','WGAMING','DMsports','12B',
			'Riverich','ZF215aTR','AKYL99','Lucklotter','Niu8gaming')
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
