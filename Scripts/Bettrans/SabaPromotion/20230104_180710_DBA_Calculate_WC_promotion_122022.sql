/* run at DB052 */
-- scripts WC promotion
-- Creator: 20230104@Danny
use bodb_licensee
DECLARE @FromDate DATETIME = '2022-12-01',
		@ToDate   DATETIME = '2022-12-31',
		@PartyIds VARCHAR(MAX)

-- Insert Licensee Info here
CREATE TABLE #temp_list (
	PartyID				INT, 
	PartyName			VARCHAR(50),
	BaseCurrencyName	VARCHAR(12), 
	ID					INT identity(1,1), 
	BaseCurrencyID		INT, 
	DummyCurrencyID		INT,
	DummyCurrencyCode	VARCHAR(12), 
	DummyCustID			INT, 
	SiteDBGroupID		TINYINT,
	IsSelected			BIT NOT NULL DEFAULT 1,
	OandaExchange		FLOAT
	)

-- PROD
INSERT INTO #temp_list(PartyName,DummyCustID) VALUES 
('18Luck',33257253),
('24AVIA',38339001),
('24AVIASL',46540005),
('365online',37974158),
('3ge888',48317377),
('442ball',56475435),
('633esports',39516604),
('88Macao',61335779),
('A1game',32657304),
('ab6688',51403442),
('Abcasino',61335815),
('ABEMT',71084002),
('AG',74140920),
('AKYL99',64853062),
('allwincity',38103535),
('allwinCV',56973864),
('AnvoFH',36338503),
('ARYA',57160509),
('BGCV',56947988),
('BigGaming',61336101),
('bmwbet',63021853),
('BSSB168',46496093),
('BSSB168CV',56678284),
('C7YOUXI',63062017),
('C7YOUXICV',63281037),
('Callmeboss',32100898),
('CGame',61336141),
('CGame4',39474231),
('Datang001',39474640),
('Dawoo',61336178),
('DawooCV',56973699),
('Dawooxin',62702296),
('dfbetCV',56948080),
('dghash',69883096),
('Diamond',45986962),
('DingTai',37204051),
('DMsports',66412904),
('DongYing',55573477),
('e8casino',27462608),
('e8casinoCV',56973946),
('erhaozhan',38732267),
('FHLMSABA',49290109),
('FHLMSABAS',58021903),
('FLC',49350817),
('GAMEBee',45536579),
('Gampag',61338008),
('Gaobet',35554784),
('GBET',65356526),
('GoldenF',54948472),
('GoldenF2',62989818),
('GS003',72476078),
('HC6YAYOU',43841258),
('Heaven',26616930),
('Hecbet',61338057),
('HIDZ',63806830),
('hjccasino',40024953),
('HuangMa',61338151),
('HX9Candy',68701465),
('IDNSPORT',66534181),
('ig128',33663786),
('ig128s',44127940),
('JDYGaming',55141472),
('JIBET',31568811),
('JJBGAME',55253886),
('JJBGAMECV',56899355),
('JUYOU',64255976),
('K8ioSW',70052696),
('kbosportCV',61536736),
('LEIHUO',55217339),
('liv66SW',46906359),
('livv88sw',47676040),
('Lucklotter',67191099),
('MARS',31607896),
('Mayayule',61338641),
('Mayibet',45530898),
('MayibetCV',57188155),
('Million',57187794),
('Mopgaming',37099109),
('MTech',39175470),
('mtegames',40483115),
('MYGAME',49149364),
('MYGAMECV',56713994),
('NewFuture',38729556),
('NLDSports',60317303),
('OBGM',51460872),
('OLE777',61338689),
('OLE777CV',56973083),
('OneSports',40586153),
('OPEBet',26797563),
('OSUSDT',46497403),
('OXPLAY',64845651),
('PKbet',61338739),
('pmwint',43487367),
('Raisetech',36130230),
('SDY',48038173),
('SDYSW',62117497),
('sea168',70095706),
('SEAGaming',60161457),
('shengboyun',39469798),
('SKY1688',62772061),
('Soon88',40290207),
('Soon88CV',56722252),
('Sunriseb2b',26854661),
('SunriseCV',56973373),
('TaoCai',41083838),
('TCbet',40767150),
('TGAA0813',54329937),
('TopGame',37140458),
('Towin',52419066),
('TSEnter',44914412),
('TSXJCV',56947920),
('TXJT',66443845),
('txwl002',36236362),
('US8YAYOU',44199470),
('VCBA',65751786),
('VCBACV',61792567),
('VKGAME',55254122),
('VKGAMECV',56899089),
('vssports',63774422),
('Wanbo',39264244),
('win365',52761443),
('WINHX1',64605467),
('wmcasino',43194394),
('Xinbo',29461700),
('Xinli2CV',59112277),
('Xinli3CV',69199312),
('XinliCV',56947858),
('Yibo',29315716),
('YiboCV',56445408),
('Yunji',40515749),
('YYHbet',60108946),
('ZF026',64845397),
('ZF055PMW',51517994),
('ZF138THB',57979917),
('ZF138USD',69584057),
('ZF138VND',60666589),
('ZF147CV',72840018),
('ZF215aTR',67006108),
('ZF215CNY',66144615),
('ZFRT080',62982184),
('ZFRT090',51459369),
('ZFRT126',56652036),
('ZFRT126CV',56652522),
('ZFRT129',46753496),
('ZFRT132',47104978),
('ZFRT144',49145470),
('ZFRT144CV',56439076),
('ZFRT152',61761958),
('ZFRT156',50409694),
('ZFRT158CV',64562447),
('ZFRT161',52364262),
('ZFRT165',51045825),
('ZFRT166',50927001),
('ZFRT167',54232694),
('ZFRT179',53973910),
('ZFRT186',55148845),
('ZFRT195',63609447),
('ZFRT213',65358027),
('ZFRT218',61370398),
('ZFRT240',66275506),
('ZFRT276',71257385),
('ZFRT282',70783703),
('ZhiFeng009',42639394),
('ZhiFeng012',42988979),
('ZhiFeng013',59073958),
('ZhiFeng021',43558472),
('ZhiFeng032',41252475),
('ZhiFeng035',42166991),
('ZhiFeng036',42506128),
('ZhiFeng040',46883710),
('ZhiFeng041',68593122),
('ZhiFeng055',50926770),
('ZhiFeng084',57797635),
('ZhiFeng122',51045945),
('ZhiFeng133',56475517),
('ZhiFeng138',53453775),
('ZhiFeng147',54039863),
('ZhiFeng168',59113956),
('ZhiFeng176',68739647),
('ZhiFeng183',66630838),
('ZhiFeng208',61630178),
('ZhiFeng222',64296960),
('ZhiFeng228',66738970),
('ZhiFeng255',66704813),
('ZhiFeng266',67481742),
('ZhiFeng299',70055933),
('ZhiFeng303',77487813),
('ZhiFeng306',71079745),
('0sServices',57520217),
('12Bet',18178396),
('368Cash',61335723),
('368CashSW',48618474),
('383sport',57749450),
('3star88',61335740),
('568Win',39340057),
('568WinSW',46886792),
('998bet',42864005),
('9bet',18189343),
('9Club',61335796),
('ABCGAME',65723849),
('ABCgamevip',68325840),
('Ae88',61335855),
('AEUG',33202711),
('AEUGSW',52714648),
('Aladdin99',50925262),
('alog',61335884),
('ALPHA88',28731364),
('Alphalota',45533308),
('Aoncash',18178809),
('asiabet88',61335968),
('awc',61371378),
('awc2',61371459),
('aws03',67794717),
('AWS08',68942221),
('B24VN',37727062),
('B8KRW',68243954),
('Baji',61368920),
('Barcelo9',56033201),
('bdtt',46099298),
('bdtt2',46667046),
('Bet88CV',67226577),
('Betway',60347424),
('bigbet',60597945),
('Bobo88',26663404),
('BOG22',38225556),
('Bolanation',25673312),
('Boma365',61336116),
('Bonanza88',30867735),
('BPLE',41878836),
('Bwing (N8B)',41799222),
('DBP',48426869),
('De365',54317823),
('DEWA',61336230),
('DF88',41899854),
('DFGame',62953612),
('ECLBET',26130124),
('Fabbet',68592864),
('F88IN1SW',62222403),
('FB88',29336804),
('FB88CV',57972495),
('GamingSoft',33331891),
('GB888CV',56973899),
('GESAB',36334377),
('Gmaster',28627551),
('GMDFD',58901543),
('Goal123 (N8G)',41799128),
('GPIGAME',26241492),
('GSCSW',49149148),
('GsportsCV',68248525),
('H1royal',59590521),
('Happy8',36003665),
('HBPT',54097904),
('HFYX',53623602),
('HL8',61338096),
('HOroyal',67033731),
('HOT99',46203555),
('iBET',61338355),
('IBO',61338388),
('ID88',37725428),
('IGSW',47023214),
('infini88',54209065),
('INSERTGAME',37676603),
('IONclub',61338467),
('ISC888',74141354),
('ITCBet',18179005),
('JBO',60717395),
('Jiuyou',67033945),
('khmer',47178658),
('khmerA2',48030290),
('KingFun',63878341),
('KSTECH2',63243708),
('KUTECH',38469029),
('Kzing2',44674559),
('KZSW',65061756),
('LegendWin',49702899),
('Leng4D',36697689),
('LG777',69579192),
('LIGAWLHKB',51947047),
('LLgaming',50671344),
('loc',51351588),
('Lode88',40193421),
('LSM99',56234329),
('LUCKYBET',63285013),
('M8bola',18179159),
('M8Credit',42723852),
('Macaubet',61338587),
('MANBETX',43054425),
('ManCity',45285421),
('Mancity2',65381014),
('MAX88',28296051),
('MICL',29326536),
('Monaco',29721034),
('Mybet88',47432932),
('N88',39744384),
('n88clubSW',63362823),
('N8BK',45250330),
('NextBet',61338666),
('Nexus',60080165),
('Niu8gaming',63999240),
('NukeGaming',45402044),
('OCMS',53587768),
('OCMSS',55223506),
('OkadaSW',47022050),
('Omni88',49056141),
('Ot88',67677770),
('Pay4d',46063421),
('Q8bola',18868759),
('Rakyat4DSW',58834869),
('RBCV',56974041),
('Rio66',54740958),
('Royal',61338760),
('ROYAL88',61505606),
('SENBKK',67003254),
('SGM88',67224446),
('Sky88',43844263),
('SL88SW',63061260),
('Slot7777',75536286),
('SM88',49368705),
('starsoccer',39634799),
('STEBBCBI',57490200),
('Sunwin',35479122),
('TGXI',52761593),
('TGXICV',63575755),
('TH3',51793486),
('Titanbet',58330552),
('TLC',61338813),
('Tripleone',28730946),
('TSLA',62317723),
('TT128',45046060),
('TWWIN',67445080),
('TYgaming',63285309),
('ug396',54325890),
('UGaming',67488840),
('UNOGAMING',47433388),
('Uwoniwin',37435457),
('V03',51793129),
('V9betSW',57152991),
('VN88',33733105),
('vnggame',66213881),
('VWIN66',35562412),
('W88',61338839),
('W88CV',56973002),
('WABET',44672564),
('Wanfang',38321526),
('Weiwei',41962248),
('Winbox',43454890),
('WINCLUB88',31588927),
('WKCUR',36351352),
('WKPHIL',36352113),
('WRSeamless',64630879),
('WRServices',57004085),
('X2Dynamic',46663460),
('X33Asia',51499128),
('XLMEDIA',60898354),
('XmenSW',63614963),
('XTSB',52954253),
('Xtu168',36976133),
('Yintai',54445481),
('YongBao',28357441),
('YSYBO688',62318341),
('YSYBO688CV',59799516),
('yuanbao',60317432),
('Zowin',41798789),
('zt828',49687461),
('ZTech',60933812),
('CandyA18',68425309)

-- LOCAL
--INSERT INTO #temp_list(PartyName, BaseCurrencyName, DummyCurrency, DummyCustID, SiteDBGroupID) VALUES 
--('21Cash','CNY','CNY',56947988,2),
--('TLC','CNY','USD',46497403,2),
--('W88','CNY','USD',46497403,2),
--('368Cash','CNY','USD',46497403,2),
--('DELA','CNY','USD',46497403,2)

CREATE TABLE #tmpMinFee (PartyId INT, ProductId INT, GroupId INT, GroupMinFeeId INT, 
FeeTypeId TINYINT, IsPrimary BIT,FromDate DATE, ToDate DATE, ProrateMinFee MONEY, BasedProrateMinFee MONEY, BaseCurrencyID INT)


DECLARE @Result TABLE
(
        PartyId INT, ProductId INT, LicensingFeeTypeId SMALLINT, GrossLicensingFee MONEY, LicensingFee MONEY, ExtraAmount MONEY, IsChargedByGroupMinFee BIT, IsChargedByMinFee BIT
        ,Rebate MONEY, RebateRate MONEY, RebateRemark NVARCHAR(4000), Discount MONEY, DiscountRate MONEY, DiscountRemark NVARCHAR(4000)
        ,BetCount INT, Turnover MONEY, MemberWL MONEY, BACommission MONEY
)


UPDATE t
SET t.PartyID = p.PartyID,
	t.BaseCurrencyID = bc.BaseCurrencyId,
	t.BaseCurrencyName = 
						CASE WHEN bc.BaseCurrencyId = 13 THEN 'CNY' 
							 WHEN bc.BaseCurrencyId = 6 THEN 'EUR'	
							 WHEN bc.BaseCurrencyId = 12 THEN 'GBP' 
							 WHEN bc.BaseCurrencyId = 3 THEN 'USD'
							 WHEN bc.BaseCurrencyId = 2 THEN 'MYR' 
							 WHEN bc.BaseCurrencyId = 142 THEN 'USDT' END 
FROM	#temp_list t
	INNER JOIN dbo.OAS_Party p WITH (NOLOCK) ON t.PartyName = p.PartyName
	INNER JOIN dbo.OAS_PartyDetail pd WITH (NOLOCK) ON p.PartyId = pd.PartyId
	CROSS APPLY (
		SELECT TOP 1 bc.BaseCurrencyId
		FROM dbo.OAS_PartyBaseCurrency bc WITH (NOLOCK)
		WHERE bc.PartyId = p.PartyId AND bc.FromDate <= @ToDate AND bc.ToDate >= @FromDate
		ORDER BY bc.ToDate DESC
	) bc
	INNER JOIN bodb02..Exchange ex  WITH (NOLOCK) ON bc.BaseCurrencyId = ex.ExchangeId

-- Insert parties with same min fee group
INSERT INTO #temp_list (PartyId, PartyName, IsSelected)
SELECT t.PartyId, t.PartyName, 0
FROM (
	SELECT DISTINCT m.PartyId, p.PartyName
	FROM dbo.LA_GroupMinFeeAssignment m WITH (NOLOCK)
	INNER JOIN OAS_Party p WITH (NOLOCK) ON m.PartyID = p.PartyID
	WHERE EXISTS (
		SELECT 1
		FROM #temp_list pl
			INNER JOIN dbo.LA_GroupMinFeeAssignment a WITH (NOLOCK) ON pl.PartyId = a.PartyId
			INNER JOIN dbo.LA_GroupMinFeeHeader h WITH (NOLOCK) ON a.GroupMinFeeId = h.GroupMinFeeId
		WHERE h.FromDate <= @ToDate AND h.ToDate >= @FromDate
			AND a.GroupMinFeeId = m.GroupMinFeeId
	)
) t
	LEFT JOIN #temp_list pl ON t.PartyId = pl.PartyId
WHERE pl.PartyId IS NULL

UPDATE t
SET 
	t.BaseCurrencyID = bc.BaseCurrencyId,
	t.BaseCurrencyName = 
						CASE WHEN bc.BaseCurrencyId = 13 THEN 'CNY' 
							 WHEN bc.BaseCurrencyId = 6 THEN 'EUR'	
							 WHEN bc.BaseCurrencyId = 12 THEN 'GBP' 
							 WHEN bc.BaseCurrencyId = 3 THEN 'USD'
							 WHEN bc.BaseCurrencyId = 2 THEN 'MYR' 
							 WHEN bc.BaseCurrencyId = 142 THEN 'USDT' END 
FROM	#temp_list t
	INNER JOIN dbo.OAS_Party p WITH (NOLOCK) ON t.PartyID = p.PartyID
	INNER JOIN dbo.OAS_PartyDetail pd WITH (NOLOCK) ON p.PartyId = pd.PartyId
	CROSS APPLY (
		SELECT TOP 1 bc.BaseCurrencyId
		FROM dbo.OAS_PartyBaseCurrency bc WITH (NOLOCK)
		WHERE bc.PartyId = p.PartyId AND bc.FromDate <= @ToDate AND bc.ToDate >= @FromDate
		ORDER BY bc.ToDate DESC
	) bc
	INNER JOIN bodb02..Exchange ex  WITH (NOLOCK) ON bc.BaseCurrencyId = ex.ExchangeId
WHERE t.IsSelected = 0
-- END

-- Update more dummy info
UPDATE t
SET		t.DummyCurrencyID = c.currency,
		t.DummyCurrencyCode = CASE WHEN Ex.Code = 'UST' THEN 'USDT' ELSE Ex.Code END,
		t.SiteDBGroupID = s.SiteDBGroupID
FROM  #temp_list t
INNER JOIN bodb02..Customer c WITH(NOLOCK) ON t.DummyCustID = c.custid
INNER JOIN bodb02..Site s  WITH(NOLOCK) ON c.site = s.Site
INNER JOIN bodb02..Exchange ex  WITH(NOLOCK) ON c.currency = ex.ExchangeId
WHERE t.DummyCustID IS NOT NULL

-- Update OandaExchange
UPDATE t
SET  t.OandaExchange = CASE WHEN t.DummyCurrencyCode = t.BaseCurrencyName THEN 1 ELSE x.BaseCurrencyRate END 
FROM #temp_list t
OUTER APPLY (SELECT CASE WHEN t.BaseCurrencyName = 'MYR' THEN x.MYR
							   WHEN t.BaseCurrencyName = 'USD' THEN x.USD
							   WHEN t.BaseCurrencyName = 'EUR' THEN x.EUR
							   WHEN t.BaseCurrencyName = 'CNY' THEN x.CNY
							   WHEN t.BaseCurrencyName = 'GBP' THEN x.GBP
							   WHEN t.BaseCurrencyName = 'THB' THEN x.THB
							   WHEN t.BaseCurrencyName = 'HKD' THEN x.HKD
							   WHEN t.BaseCurrencyName = 'IDR' THEN x.IDR
							   WHEN t.BaseCurrencyName = 'SGD' THEN x.SGD
							   WHEN t.BaseCurrencyName = 'VND' THEN x.VND
							   WHEN t.BaseCurrencyName = 'KRW' THEN x.KRW
							   WHEN t.BaseCurrencyName = 'INR' THEN x.INR
							   WHEN t.BaseCurrencyName = 'PHP' THEN x.PHP
								END BaseCurrencyRate
FROM bodb02..ExchangeDailyOanda x WITH (NOLOCK)
WHERE x.ExchangeId = t.DummyCurrencyID AND t.BaseCurrencyName <>  t.DummyCurrencyCode AND x.ExchangeDate = @ToDate
) x

WHERE t.DummyCurrencyID IS NOT NULL

DELETE #temp_list WHERE PartyID IS NULL

SET @PartyIds = NULL
;WITH CTE_PartyId AS (SELECT DISTINCT PartyId FROM #temp_list)
SELECT @PartyIds = COALESCE(@PartyIds + ',', '') + CONVERT(VARCHAR(20), PartyId) FROM CTE_PartyId

INSERT INTO #tmpMinFee (PartyId, ProductId, GroupId, GroupMinFeeId, FeeTypeId, IsPrimary, FromDate, ToDate, BasedProrateMinFee, BaseCurrencyID)
SELECT PartyId, ProductId, GroupId, GroupMinFeeId, FeeTypeId, IsPrimary, FromDate, ToDate, ProrateMinFee, BaseCurrencyId
FROM dbo.LA_f_GetProrateMinFee(@PartyIds, @FromDate, @ToDate) m

--select 'debug',* FROM #tmpMinFee

DECLARE @i INT = 1, @BaseCurrencyName VARCHAR(10), @PartyIds_run VARCHAR(MAX)
DECLARE @tblBaseCurr TABLE (ID INT identity(1,1), BaseCurrencyName VARCHAR(10))
INSERT INTO @tblBaseCurr (BaseCurrencyName)
SELECT DISTINCT BaseCurrencyName FROM #temp_list WHERE BaseCurrencyName IS NOT NULL

WHILE EXISTS (SELECT TOP 1 1 FROM @tblBaseCurr WHERE ID = @i)
BEGIN
	SELECT @BaseCurrencyName = BaseCurrencyName FROM @tblBaseCurr WHERE ID = @i
	SET @PartyIds_run = NULL
	SELECT @PartyIds_run = COALESCE(@PartyIds_run + ',', '') + CONVERT(VARCHAR(20), PartyId) FROM #temp_list WHERE BaseCurrencyName = @BaseCurrencyName

    INSERT INTO @Result
    (
            PartyId, ProductId, LicensingFeeTypeId, GrossLicensingFee, LicensingFee, ExtraAmount, IsChargedByGroupMinFee, IsChargedByMinFee
            ,Discount, DiscountRate, DiscountRemark, Rebate, RebateRate, RebateRemark
    )
    EXEC bodb_Licensee.dbo.LA_AmountToCompanyByProduct
            @PartyIds = @PartyIds_run
            ,@ProductCodes = ''
            ,@Currencies = ''
            ,@FromDate = @FromDate
            ,@ToDate = @ToDate
            ,@BaseCurrencyName = @BaseCurrencyName

    SELECT @i = @i + 1

END

SELECT	tl.BaseCurrencyID,
		tl.BaseCurrencyName AS BillingCurrency,
		tl.PartyName, 
		ROUND(r.LicensingFee,2) LicensingFee,
		ROUND(r.Discount,2) Discount,
		ROUND(r.Rebate,2) Rebate,
		ISNULL(ROUND(r37.LicensingFee,2),0) saba_promotion,
		ROUND(CAST((ROUND(r.LicensingFee,2) - ROUND(r.Discount,2) - ISNULL(ROUND(r37.LicensingFee,2),0))  * 0.1 AS MONEY),2) WC_promo,
		r.IsChargedByMinFee,
		r.IsChargedByGroupMinFee,
		tf.GroupMinFeeId,
		tf.IsPrimary,
		tf.BasedProrateMinFee,
		tf.BaseCurrencyID AS Minfee_baseCurr,
		tf.FeeTypeId,
		tl.DummyCurrencyCode  DummyCurrency,
		tl.DummyCustID,
		tl.SiteDBGroupID,
		tl.IsSelected,
		CAST(tl.OandaExchange AS FLOAT) OandaExchange
INTO #tmp
FROM @Result r
INNER JOIN #temp_list tl ON r.PartyId = tl.PartyID
LEFT JOIN @Result r37 ON r.PartyId = r37.PartyId AND r37.ProductId = 37
LEFT JOIN #tmpMinFee tf ON r.PartyId = tf.PartyId AND tf.FeeTypeId IN (0,1) -- 0: MF, 1:GMF
WHERE r.ProductId = 0 --AND r.IsChargedByMinFee = 0 AND r.IsChargedByGroupMinFee = 0

ALTER TABLE #tmp ADD WC_promo_final MONEY

-- No WC promo ( Charge by MF or GMF)
UPDATE #tmp SET WC_promo = 0 WHERE WC_promo < 0
UPDATE #tmp SET WC_promo_final = WC_promo

UPDATE #tmp SET WC_promo_final = 0, WC_promo = 0
WHERE  IsChargedByMinFee =1 OR IsChargedByGroupMinFee = 1

UPDATE #tmp SET WC_promo_final = 0, WC_promo = 0
WHERE GroupMinFeeId > 0 AND GroupMinFeeId IN (SELECT DISTINCT GroupMinFeeId FROM #tmp WHERE IsChargedByMinFee =1 OR IsChargedByGroupMinFee = 1)

-- Adjust MF
IF EXISTS (SELECT TOP 1 1 FROM #tmp WHERE WC_promo > 0 AND GroupMinFeeId > 0 AND FeeTypeId = 0)
BEGIN
	UPDATE	#tmp
	SET		WC_promo_final = CASE WHEN BasedProrateMinFee > (LicensingFee - WC_promo - saba_promotion) THEN WC_promo - (BasedProrateMinFee - (LicensingFee - WC_promo - saba_promotion))
									ELSE WC_promo END 
	WHERE	WC_promo > 0 AND GroupMinFeeId > 0 AND IsPrimary = 1 AND FeeTypeId = 0
END

-- Adjust GMF
IF EXISTS (SELECT TOP 1 1 FROM #tmp WHERE WC_promo > 0 AND GroupMinFeeId > 0 AND FeeTypeId = 1)
BEGIN
		
	DECLARE @AdjustGroupMinFee TABLE (GroupMinFeeId INT, TotalAdjustAmount MONEY, BasedProrateMinFee MONEY ,ID INT identity(1,1))
	INSERT INTO @AdjustGroupMinFee (GroupMinFeeId, BasedProrateMinFee)
	SELECT DISTINCT GroupMinFeeId, BasedProrateMinFee
	FROM #tmp t
	WHERE GroupMinFeeId > 0 AND IsPrimary = 1

	UPDATE a
	SET a.TotalAdjustAmount = CASE WHEN a.BasedProrateMinFee - pre_promo < 0 THEN 0 ELSE a.BasedProrateMinFee - pre_promo END
	FROM @AdjustGroupMinFee a
		INNER JOIN (
			SELECT GroupMinFeeId, SUM(LicensingFee - saba_promotion - WC_promo) AS pre_promo
			FROM #tmp
			WHERE GroupMinFeeId > 0  AND IsChargedByMinFee =0 AND  IsChargedByGroupMinFee = 0
			GROUP BY GroupMinFeeId 
		) t ON a.GroupMinFeeId = t.GroupMinFeeId 


	DECLARE @j INT = 1, @TotalAdjustAmount MONEY, @GroupMinFeeId INT
	WHILE EXISTS (SELECT TOP 1 1 FROM @AdjustGroupMinFee WHERE ID = @j )
	BEGIN
		SELECT @TotalAdjustAmount = TotalAdjustAmount, @GroupMinFeeId = GroupMinFeeId
		FROM @AdjustGroupMinFee WHERE ID = @j

		IF @TotalAdjustAmount > 0 
		BEGIN
			; WITH t AS
			(
				SELECT t.PartyName, t.WC_promo, t.LicensingFee, t.saba_promotion ,ROW_NUMBER() OVER (ORDER BY t.IsPrimary DESC,  t.WC_promo DESC) rank_
				FROM #tmp t
				WHERE t.GroupMinFeeId = @GroupMinFeeId 
			), u AS
			(
				SELECT t.PartyName, t.WC_promo, CAST ((t.WC_promo - @TotalAdjustAmount) AS MONEY) AS WC_promo_final, rank_  FROM t WHERE  rank_ = 1
				UNION ALL
				SELECT  t.PartyName, t.WC_promo, CAST (t.WC_promo +  u.WC_promo_final AS MONEY), t.rank_
				FROM  u  INNER JOIN t ON u.rank_ + 1 = t.rank_ AND u.WC_promo_final < 0
			)
			UPDATE s
			SET s.WC_promo_final = CASE WHEN u.WC_promo_final < 0 THEN 0 ELSE u.WC_promo_final END
			FROM #tmp s
			INNER JOIN u ON s.PartyName = u.PartyName
		END

		SELECt @j = @j +1
	END

END
-- Final result
SELECT	t.SiteDBGroupID,
		t.PartyName,
		t.BillingCurrency,
		t.LicensingFee,
		t.Discount,
		t.saba_promotion,
		t.FeeTypeId,
		CASE WHEN t.FeeTypeId = 1 AND t.GroupMinFeeId < 0  THEN 'MF'
			 WHEN t.FeeTypeId = 1 AND t.GroupMinFeeId > 0 THEN 'GMF'
			 ELSE 'None' END MF_Setting,
		CASE WHEN t.IsPrimary = 1 THEN 'Primary'
			WHEN t.IsPrimary = 0 THEN 'Secondary' 
			ELSE 'None' END MF_Status,
		t.BasedProrateMinFee AS MF_Value,	
		t.DummyCurrency,
		t.DummyCustID,
		t.WC_promo AS pre_WC_promo_billngCurr,
		ROUND(t.WC_promo_final,2) AS WC_promo_final_billngCurr,
		t.OandaExchange,
		CAST((ROUND(t.WC_promo_final,2) / t.OandaExchange) AS MONEY) WC_promo_final_DummyCurr,
		t.IsSelected

FROM #tmp t
ORDER BY	 t.GroupMinFeeId,
			 t.IsPrimary DESC

DROP TABLE #tmp
DROP TABLE #temp_list
DROP TABLE #tmpMinFee
