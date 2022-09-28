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
SELECT @SiteDBGroupID = dbo.f_Get_SiteDBGroupID()  -- 2

INSERT INTO LicenseeBATransaction_active(TransID,transdate,custid,recommend,srecommend)
SELECT l.TransID,l.transdate,l.custid,l.recommend,l.srecommend 
FROM DBLIC.bodb_Licensee.dbo.LicenseeBATransaction_active l WITH(NOLOCK)
	INNER JOIN CustDB.dbo.Dep_CustSuper d WITH(NOLOCK) ON d.custid = l.srecommend
WHERE	d.SiteDBGroupID = @SiteDBGroupID  
		AND site IN ('18Luck','TGAA0813','XinliCV','Xinli2CV','YSYBO688','SKY1688','vnggame','368Cash','TT128','368CashSW','568Win','568WinSW','ab6688','ABEMT','Abcasino','Million','AG','AMG','PKbet',
			'PanguGame','BETSUN','HuangMa','BigGaming','818Bet','HongChow','TangChao','CGame','SSSGaming','HCVIP','WinWin','BWGaming','CGame4','7kplatform','BGCV','SEAGaming','Aoncash','M8bola',
			'Q8bola','NBCbet','Unobet','Winn69','Axiawin','Ratugg','Lagadewa','Monstergol','B24VN','Rio66','HAIFA','BBIN2','BBIN3','BE7','Luckywin88','beplay','beplayCV','DBP','Monaco','RBCV','3star88',
			'ECLBET','Mybet88','WINCLUB88','INSERTGAME','Alphalota','Barcelo9','Aladdin99','BVCLLC','Jiuyou','Yintai','Letian','WRServices','Xiaoxiang','YakaGaming','5ATech','IGSW','HBPT','TSLA',
			'WRSeamless','TYgaming','Dawoo','pinbo','QUBO','DawooCV','Dawooxin','YYHbet','FB88','FB88CV','Happy1668','YAYOU','US8YAYOU','HC6YAYOU','J9YAYOU','Hejiyongle','Boma365','Hengcai88','GESAB',
			'mansion88','Happy8','THECLUB','THEDEN','Mayayule','Dachen','MayFair','Vwin','MrCat','Fugui','TitanOne','VWIN66','WKCUR','WKPHIL','TitanCraft','Saibo','Titanbet','Mayibet','MayibetCV',
			'OLE777','OLE777CV','UNOGAMING','ZTech','XLMEDIA','Soon88','Soon88CV','TGO','365online','YBTech','BOSSB','YTX','Yunji','GAMEBee','SDY','dfbetCV','SDYSW','Entaplay','Tripleone','MICL','laba360',
			'TSEnter','BSSB168','MYGAME','IgameTech','ARYA','MYGAMECV','BSSB168CV','TSXJCV','W88','GPIGAME','MAX88','ALPHA88','VN88','Win88','DF88','Asian88','ID88','BOG22','W88CV','ROYAL88','alog','zt828',
			'Macaubet','Winbox','JDYGaming','V9betSW','PKKing','ug396','Baji','NLDSports','998bet','hjccasino','ITCbet','Callmeboss','HL8','9bet','WABET','VCBA','GMASTER','Gampag','LIGAWLHKB','bigbet',
			'Peakk','Bolanation','Comebet','N8BK','3ge888','C7YOUXI','Gaobet','OSUSDT','VCBACV','Uwoniwin','383sport','USSBET','X33Asia','9w','LUCKYBET','XmenSW','kbosportCV','KSTECH2','GoToWin','kbosports',
			'OCMSS','ANGbet','De365','TGXICV','mbxusdt','Winsplay','GoldenF2','ZhiFeng019','GmasterS','DTGJZ','UGaming','ZhiFeng173','AEUGSW','0sServices','YSYBO688CV','TXJT','OBGM')
GO

-- LICSettings: Update Min - Max TransId flag for BA Transaction Job

DECLARE @SiteDBGroupID SMALLINT;
SELECT @SiteDBGroupID = dbo.f_Get_SiteDBGroupID()

DECLARE @VValue2_SequenceID BIGINT, @TransID BIGINT;
DECLARE @VValue2_TransID BIGINT = 0;

SELECT	@VValue2_SequenceID = CAST(ISNULL(vvalue2,0) AS BIGINT) 
FROM	DBLIC.bodb_Licensee.dbo.LICSettings WITH (ROWLOCK) 
WHERE	vname = 'BA_transid'

SELECT	@TransID = TransId FROM DBCTG.bodb02.dbo.bettrans WITH(NOLOCK) WHERE sequenceid = @VValue2_SequenceID
SELECT	@VValue2_TransID = MAX(TransId) FROM bettrans WITH(NOLOCK) WHERE TransId <= @TransID AND SiteDBGroupID = @SiteDBGroupID

UPDATE dbo.LICSettings WITH(ROWLOCK) SET VValue2 = @VValue2_TransID WHERE vname = 'BA_transid'