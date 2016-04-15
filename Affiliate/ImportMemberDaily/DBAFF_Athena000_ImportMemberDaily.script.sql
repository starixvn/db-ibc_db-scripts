declare
	@AdminID INT
	,@XmlData XML
	,@WinlostDate SMALLDATETIME
	,@ErrCode INT = 0 
	,@ErrMsg NVARCHAR(500) = ''

BEGIN
	SET NOCOUNT ON

	SELECT @AdminID = 8
		,@XmlData = N'<root><trans username="afftest14" winlostdate="2016-04-14T00:00:00" productid="1" turnover="24450.0000" outstanding="0.0000" winloss="5790.0000" drawgame="2000.0000" betcount="30" playercomm="25.7000" turnovernodraw="22450.0000" betcountnodraw="28" progressiveshare="0.0000" progressivewin="0.0000"/><trans username="afftest14" winlostdate="2016-04-14T00:00:00" productid="6" turnover="158599.2000" outstanding="0.0000" winloss="-14786.0800" drawgame="231.2500" betcount="75" playercomm="0.0700" turnovernodraw="158367.9500" betcountnodraw="71" progressiveshare="0.0000" progressivewin="0.0000"/><trans username="afftest14" winlostdate="2016-04-14T00:00:00" productid="8" turnover="4778.0000" outstanding="0.0000" winloss="-2527.7000" drawgame="0.0000" betcount="24" playercomm="0.0000" turnovernodraw="4778.0000" betcountnodraw="24" progressiveshare="0.0000" progressivewin="0.0000"/><trans username="afftest14" winlostdate="2016-04-14T00:00:00" productid="11" turnover="506000.0000" outstanding="0.0000" winloss="178000.0000" drawgame="0.0000" betcount="2" playercomm="0.0000" turnovernodraw="506000.0000" betcountnodraw="2" progressiveshare="0.0000" progressivewin="0.0000"/></root>'
		,@WinlostDate = '2016-04-14'

	-- import exchange daily
	IF(NOT EXISTS(SELECT 1 FROM [Affiliate_Athena000].[dbo].[ExchangeDaily] WHERE [Date] = @WinlostDate))
	BEGIN
		INSERT INTO [Affiliate_Athena000].[dbo].[ExchangeDaily] (
		 [Date]
		  ,[ExchangeID]
		  ,[USD]
		  ,[USD_Market]
		  ,[EUR]
		  ,[EUR_Market]
		  ,[CNY]
		  ,[CNY_Market]
		  ,[UUS]
		  ,[UUS_Market]
		  ,[MYR]
		  ,[MYR_Market]
		  ,[Code]
		  ,[DepositPercent]
		  ,[WithdrawalPercent]
		  ,[IsAutoRefresh]
		  ,[SGD]
		  ,[SGD_Market]
		  ,[IDR]
		  ,[IDR_Market]
		  ,[AUD]
		  ,[AUD_Market]
		  ,[CHF]
		  ,[CHF_Market]
		  ,[GBP]
		  ,[GBP_Market]
		  ,[THB]
		  ,[THB_Market]
		  ,[VND]
		  ,[VND_Market]
		  ,[KRW]
		  ,[KRW_Market]
		  ,[JPY]
		  ,[JPY_Market]
		)
		SELECT  @winlostdate [Date]
		  ,[ExchangeID]
		  ,[USD]
		  ,[USD_Market]
		  ,[EUR]
		  ,[EUR_Market]
		  ,[CNY]
		  ,[CNY_Market]
		  ,[UUS]
		  ,[UUS_Market]
		  ,[MYR]
		  ,[MYR_Market]
		  ,[Code]
		  ,[DepositPercent]
		  ,[WithdrawalPercent]
		  ,[IsAutoRefresh]
		  ,[SGD]
		  ,[SGD_Market]
		  ,[IDR]
		  ,[IDR_Market]
		  ,[AUD]
		  ,[AUD_Market]
		  ,[CHF]
		  ,[CHF_Market]
		  ,[GBP]
		  ,[GBP_Market]
		  ,[THB]
		  ,[THB_Market]
		  ,[VND]
		  ,[VND_Market]
		  ,[KRW]
		  ,[KRW_Market]
		  ,[JPY]
		  ,[JPY_Market]
	  FROM [Affiliate_Athena000].[dbo].[ExchangeDaily]
	  where [Date] = (select MAX(date) from [Affiliate_Athena000].[dbo].[ExchangeDaily])
	END

	-- check data is calculated for this month?
	IF EXISTS (
			SELECT TOP (1) 1
			FROM AffCommission(NOLOCK)
			WHERE DATEDIFF(m, @WinlostDate, Winlostdate) = 0
			) RETURN

	DECLARE @SystemCurrency SMALLINT

	EXEC Aff_GetSystemCurrency @SystemCurrency = @SystemCurrency OUTPUT

	DECLARE @TmpTable TABLE (
		UserName VARCHAR(30)
		,WinlostDate SMALLDATETIME
		,ProductID TINYINT
		)
	--Import new Data here
	DECLARE @TempTrans TABLE (
		UserName VARCHAR(30)
		,WinlostDate SMALLDATETIME
		,ProductID TINYINT
		,Turnover MONEY
		,Outstanding MONEY
		,Winlost MONEY
		,DrawGame MONEY
		,BetCount INT
		,PlayerComm MONEY
		,TurnoverNoDraw MONEY
		,BetCountNoDraw INT
		,PShare MONEY
		,PWin MONEY
	);

	INSERT INTO @TempTrans (
		UserName
		,WinlostDate
		,ProductID
		,Turnover
		,Outstanding
		,Winlost
		,DrawGame
		,BetCount
		,PlayerComm
		,TurnoverNoDraw
		,BetCountNoDraw
		,PShare
		,PWin
	)
	SELECT [Table].[Column].value('./@username', 'varchar(30)') AS [UserName]
		,[Table].[Column].value('./@winlostdate', 'smalldatetime') AS [WinlostDate]
		,[Table].[Column].value('./@productid', 'tinyint') AS [ProductID]
		,[Table].[Column].value('./@turnover', 'money') AS [Turnover]
		,[Table].[Column].value('./@outstanding', 'money') AS [Outstanding]
		,[Table].[Column].value('./@winloss', 'money') AS [Winlost]
		,[Table].[Column].value('./@drawgame', 'money') AS [DrawGame]
		,[Table].[Column].value('./@betcount', 'int') AS [betcount]
		,[Table].[Column].value('./@playercomm', 'money') AS [PlayerComm]
		,[Table].[Column].value('./@turnovernodraw', 'money') AS [TurnoverNoDraw]
		,[Table].[Column].value('./@betcountnodraw', 'int') AS [BetCountNoDraw]
		,[Table].[Column].value('./@progressiveshare', 'money') AS [PShare]
		,[Table].[Column].value('./@progressivewin', 'money') AS [PWin]
	FROM @XmlData.nodes('/root/trans') AS [Table]([Column]);

	--select * from @TempTrans

	DELETE MemberDaily WITH(ROWLOCK)
	WHERE WinlostDate = @WinlostDate

	INSERT INTO MemberDaily (
		[UserName]
		,[WinlostDate]
		,[ProductID]
		,[Turnover]
		,[Outstanding]
		,[Winlost]
		,[DrawGame]
		,[AffId]
		,[IBCCustId]
		,[Currency]
		,[AffCurrency]
		,[AffExRate]
		,[SysCurrency]
		,[SysExRate]
		,[Deposit]
		,[Withdrawal]
		,[Bonus]
		,[Adjustment]
		,[BetCount]
		,[PlayerComm]
		,[BetCountNoDraw]
		,[TurnoverDraw]
		,[TurnoverNoDraw]
		,[PShare]
		,[PWin]
		)
	SELECT t1.UserName
		,t1.WinlostDate
		,p.ProductID
		,t1.Turnover
		,t1.Outstanding
		,t1.Winlost
		,t1.DrawGame
		,mi.AffId
		,mi.IBCCustId
		,mi.Currency
		,ai.Currency
		,dbo.Aff_GetExchangeRate(mi.Currency, ai.Currency, @WinlostDate) AS AffExRate
		,@SystemCurrency
		,dbo.Aff_GetExchangeRate(mi.Currency, @SystemCurrency, @WinlostDate) AS SystemExRate
		,0 AS Deposit
		,0 AS Withdrawal
		,0 AS Bonus
		,0 AS Adjustment
		,t1.BetCount
		,t1.PlayerComm
		,t1.BetCountNoDraw
		,t1.DrawGame
		,t1.TurnoverNoDraw
		,t1.PShare
		,t1.PWin
	FROM @TempTrans AS t1
		INNER JOIN dbo.MemberInfo AS mi ON t1.UserName = mi.UserName
		INNER JOIN dbo.AffInfo AS ai WITH (NOLOCK) ON mi.AffId = ai.AffId
	-- inner join Exchange as ex with (nolock) on ai.Currency = ex.ExchangeId
		INNER JOIN dbo.Product AS p WITH (NOLOCK) ON t1.ProductID = p.API_ProductId
		AND p.IsEnabled = 1
		AND p.EffectiveDate <= @WinlostDate
	WHERE t1.WinlostDate = @WinlostDate
		AND mi.IsRemoved = 0

	--Delete data and re-import AffDaily, AffDailySummary
	DELETE
	FROM AffDaily
	WHERE WinlostDate = @WinlostDate

	DELETE
	FROM [AffDailySummary]
	WHERE WinlostDate = @WinlostDate

	INSERT INTO AffDaily (
		[AffID]
		,[MemCurrency]
		,[Winlostdate]
		,[ProductID]
		,[AffCurrency]
		,[AffExRate]
		,[SysCurrency]
		,[SysExRate]
		,[MemDeposit]
		,[MemWithdrawal]
		,[MemTurnover]
		,[MemBonus]
		,[MemAdjustment]
		,[MemMarketing]
		,[MemPSP]
		,[MemWinlost]
		,[AffWinlost]
		,[HouseWinlost]
		,[AffNetWinlost]
		,[HouseNetWinlost]
		,[MemWinlostFake]
		,[MemOddsFee]
		,[MemPLayTechFee]
		,[MemAffTransfer]
		,[MemTransfer3rd]
		,[MemBetCount]
		,[MemPlayerComm]
		,[ActivePlayer]
		,[MemTurnoverNoDraw]
		,[MemBetCountNoDraw]
		,[MemTurnoverDraw]
		,[PShare]
		,[PWin]
		)
	SELECT m.[AffID]
		,m.[Currency] AS [MemCurrency]
		,m.[WinlostDate]
		,m.[ProductID]
		,m.[AffCurrency]
		,m.[AffExRate]
		,m.[SysCurrency]
		,m.[SysExRate]
		,Sum(Deposit) AS MemDeposit
		,Sum(Withdrawal) AS MemWithdrawal
		,Sum(Turnover) AS MemTurnover
		,Sum(Bonus) AS MemBonus
		,Sum(Adjustment) AS MemAdjustment
		,Sum(Marketing) AS MemMarketing
		,Sum(PSP) AS MemPSP
		,Sum(Winlost) AS MemWinlost
		,0 AS AffWinlost
		,- Sum(Winlost) AS HouseWinlost
		,0 AS AffNetWinlost
		,0 AS HouseNetWinlost
		,Sum(MemWinlostFake) AS MemWinlostFake
		,Sum(MemOddsFee) AS MemOddsFee
		,Sum(MemPLayTechFee) AS MemPLayTechFee
		,Sum([AffTransfer])
		,Sum([Transfer3rd])
		,Sum([BetCount])
		,Sum([PlayerComm])
		,SUM(CASE 
				WHEN Turnover > 0 THEN 1
				ELSE 0
				END) AS ActivePlayer
		,SUM(TurnoverNoDraw)
		,SUM(BetCountNoDraw)
		,SUM(TurnoverDraw)
		,SUM(ISNULL([PShare],0))
		,SUM(ISNULL([PWin], 0))
	FROM MemberDaily(NOLOCK) AS m
	WHERE m.WinlostDate = @WinlostDate
	GROUP BY m.AffID
		,m.Winlostdate
		,m.ProductID
		,m.Currency
		,m.[AffCurrency]
		,m.[AffExRate]
		,m.[SysCurrency]
		,m.[SysExRate]

	UPDATE AffDaily WITH (ROWLOCK, UPDLOCK)
	SET HouseNetWinLost = HouseWinLost - isnull(MemPSP, 0) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'PSP', Winlostdate), 0)) - isnull(MemBonus, 0) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'Bonus', Winlostdate), 0)) - isnull(MemAdjustment, 0) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'Adjustment', Winlostdate), 0)) - abs(isnull(MemWinlost, 0)) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'Marketing', Winlostdate), 0)) - abs(isnull(MemWinlost, 0)) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'Odds Fee', Winlostdate), 0)) - abs(isnull(MemWinlost, 0)) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'PlayTech Royalties', Winlostdate), 0))
	WHERE WinlostDate = @winlostdate

	--Update [AffDailySummary] table
	INSERT INTO [dbo].[AffDailySummary] (
		[AffID]
		,[Winlostdate]
		,[ProductID]
		,[AffCurrency]
		,[SysCurrency]
		,[MemDeposit]
		,[MemWithdrawal]
		,[MemTurnover]
		,[MemBonus]
		,[MemAdjustment]
		,[MemMarketing]
		,[MemPSP]
		,[MemWinlost]
		,[AffWinlost]
		,[HouseWinlost]
		,[AffNetWinlost]
		,[HouseNetWinlost]
		,[MemOddsFee]
		,[MemPLayTechFee]
		,[MemWinlostFake]
		,[MemAffTransfer]
		,[MemTransfer3rd]
		,[MemBetCount]
		,[MemPlayerComm]
		,[MemDeposit_aff]
		,[MemWithdrawal_aff]
		,[MemTurnover_aff]
		,[MemBonus_aff]
		,[MemAdjustment_aff]
		,[MemMarketing_aff]
		,[MemPSP_aff]
		,[MemWinlost_aff]
		,[AffWinlost_aff]
		,[HouseWinlost_aff]
		,[AffNetWinlost_aff]
		,[HouseNetWinlost_aff]
		,[MemOddsFee_aff]
		,[MemWinlostFake_aff]
		,[MemPLayTechFee_aff]
		,[MemAffTransfer_aff]
		,[MemTransfer3rd_aff]
		,[MemPlayerComm_aff]
		,[MemTurnoverNoDraw]
		,[MemBetCountNoDraw]
		,[MemTurnoverNoDraw_aff]
		,[MemTurnoverDraw]
		,[MemTurnoverDraw_aff]
		,[PShare]
		,[PShare_aff]
		,[PWin]
		,[PWin_aff]
		)
	SELECT [AffID]
		,[Winlostdate]
		,[ProductID]
		,[AffCurrency]
		,[SysCurrency]
		,Sum([MemDeposit] * SysExRate) AS [MemWithdrawal]
		,Sum([MemWithdrawal] * SysExRate) AS [MemWithdrawal]
		,Sum([MemTurnover] * SysExRate) AS [MemTurnover]
		,Sum([MemBonus] * SysExRate) AS [MemBonus]
		,Sum([MemAdjustment] * SysExRate) AS [MemAdjustment]
		,Sum([MemMarketing] * SysExRate) AS [MemMarketing]
		,Sum([MemPSP] * SysExRate) AS [MemPSP]
		,Sum([MemWinlost] * SysExRate) AS [MemWinlost]
		,Sum([AffWinlost] * SysExRate) AS [AffWinlost]
		,- Sum([MemWinlost] * SysExRate) AS [HouseWinlost]
		,0 AS [AffNetWinlost]
		,0 AS [HouseNetWinlost]
		,Sum([MemOddsFee] * SysExRate) AS [MemOddsFee]
		,Sum([MemPLayTechFee] * SysExRate) AS [MemPLayTechFee]
		,0 AS [MemWinlostFake]
		,Sum([MemAffTransfer] * SysExRate)
		,Sum([MemTransfer3rd] * SysExRate)
		,Sum([MemBetCount])
		,Sum([MemPlayerComm] * SysExRate)
		,Sum([MemDeposit] * AffExRate) AS [MemDeposit_aff]
		,Sum([MemWithdrawal] * AffExRate) AS [MemWithdrawal_aff]
		,Sum([MemTurnover] * AffExRate) AS [MemTurnover_aff]
		,Sum([MemBonus] * AffExRate) AS [MemBonus_aff]
		,Sum([MemAdjustment] * AffExRate) AS [MemAdjustment_aff]
		,Sum([MemMarketing] * AffExRate) AS [MemMarketing_aff]
		,Sum([MemPSP] * AffExRate) AS [MemPSP_aff]
		,Sum([MemWinlost] * AffExRate) AS [MemWinlost_aff]
		,0 AS [AffWinlost_aff]
		,- Sum([MemWinlost] * AffExRate) AS [HouseWinlost_aff]
		,0 AS [AffNetWinlost_aff]
		,0 AS [HouseNetWinlost_aff]
		,Sum([MemOddsFee] * AffExRate) AS [MemOddsFee_aff]
		,Sum([MemWinlostFake] * AffExRate) AS [MemWinlostFake_aff]
		,Sum([MemPLayTechFee] * AffExRate) AS [MemPLayTechFee_aff]
		,Sum([MemAffTransfer] * AffExRate)
		,Sum([MemTransfer3rd] * AffExRate)
		,Sum([MemPlayerComm] * AffExRate)
		,SUM([MemTurnoverNoDraw] * SysExRate) AS MemTurnoverNoDraw
		,SUM([MemBetCountNoDraw])
		,SUM([MemTurnoverNoDraw] * AffExRate) AS MemTurnoverNoDraw_aff
		,SUM([MemTurnoverDraw] * SysExRate) AS MemTurnoverDraw
		,SUM([MemTurnoverDraw] * AffExRate) AS MemTurnoverDraw_aff
		,SUM([PShare] * SysExRate) AS PShare
		,SUM([PShare] * AffExRate) AS PShare_aff
		,SUM([PWin] * SysExRate) AS PWin
		,SUM([PWin] * AffExRate) AS PWin_aff
	FROM AffDaily(NOLOCK)
	WHERE WinlostDate = @winlostdate
	GROUP BY AffID
		,Winlostdate
		,ProductID
		,AffCurrency
		,SysCurrency

	UPDATE AffDailySummary WITH (ROWLOCK, UPDLOCK)
	SET HouseNetWinlost = (- MemWinlost - isnull(MemPSP, 0) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'PSP', Winlostdate), 0)) - isnull(MemBonus, 0) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'Bonus', Winlostdate), 0)) - isnull(MemAdjustment, 0) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'Adjustment', Winlostdate), 0)) - abs(isnull(MemWinlost, 0)) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'Marketing', Winlostdate), 0)) - abs(isnull(MemWinlost, 0)) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'Odds Fee', Winlostdate), 0)) - abs(isnull(MemWinlost, 0)) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'PlayTech Royalties', Winlostdate), 0)))
		,HouseNetWinlost_aff = (- MemWinlost_aff - isnull(MemPSP_aff, 0) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'PSP', Winlostdate), 0)) - isnull(MemBonus_aff, 0) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'Bonus', Winlostdate), 0)) - isnull(MemAdjustment_aff, 0) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'Adjustment', Winlostdate), 0)) - abs(isnull(MemWinlost_aff, 0)) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'Marketing', Winlostdate), 0)) - abs(isnull(MemWinlost_aff, 0)) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'Odds Fee', Winlostdate), 0)) - abs(isnull(MemWinlost_aff, 0)) * (1 - isnull(dbo.Aff_GetDeductionPercent(AffID, ProductID, 'PlayTech Royalties', Winlostdate), 0)))
	WHERE WinlostDate = @winlostdate

	-----------Update MemwinlostFake for last date (forex winlost for previous date) of each account
	DECLARE @temp TABLE (
		affid INT
		,ProductID INT
		,totalWinlost MONEY
		,oddsFeePercent FLOAT
		,marketingPercent FLOAT
		,PSPPercent FLOAT
		,PlaytechPercent FLOAT
		,WLFake MONEY
		,totalPSP MONEY
		,maxWinlostDate SMALLDATETIME
		,previousMaxWinlostDate SMALLDATETIME
		,firstday SMALLDATETIME
		)

	INSERT INTO @temp (
		Affid
		,maxWinlostDate
		,ProductID
		)
	SELECT affid
		,max(winlostdate)
		,ProductID
	FROM AffDailySummary(NOLOCK)
	WHERE datediff(m, @winlostdate, WinlostDate) = 0 --  and ProductID = @SportsBookID      
	GROUP BY affid
		,ProductID
		,month(winlostdate)
		,year(winlostdate)

	UPDATE t
	SET t.previousMaxWinlostDate = isnull((
				SELECT max(winlostdate)
				FROM AffDailySummary(NOLOCK)
				WHERE ProductID = t.ProductID
					AND winlostdate < t.maxWinlostDate
					AND datediff(m, winlostdate, t.maxWinlostDate) = 0
					AND affid = t.affid
				), t.maxWinlostDate)
		,t.firstday = [dbo].[Aff_GetFirstDayOfMonth](t.maxWinlostDate)
		,t.oddsFeePercent = dbo.Aff_GetDeductionPercent(AffID, t.ProductID, 'Odds Fee', [dbo].[Aff_GetLastDayOfMonth](t.maxWinlostDate))
		,t.marketingPercent = dbo.Aff_GetDeductionPercent(AffID, t.ProductID, 'Marketing', [dbo].[Aff_GetLastDayOfMonth](t.maxWinlostDate))
		,t.PSPPercent = dbo.Aff_GetDeductionPercent(AffID, t.ProductID, 'PSP', [dbo].[Aff_GetLastDayOfMonth](t.maxWinlostDate))
		,t.PlaytechPercent = dbo.Aff_GetDeductionPercent(AffID, t.ProductID, 'PlayTech Royalties', [dbo].[Aff_GetLastDayOfMonth](t.maxWinlostDate))
	FROM @temp t

	--reupdate WinlostFake of previous MaxWinlostDate for AffDailySummary    
	UPDATE ad
	SET ad.MemWinlostFake = - (- isnull(ad.MemWinlost, 0) - abs(isnull(ad.MemWinlost, 0)) * isnull(dbo.Aff_GetDeductionPercent(ad.AffID, t.ProductID, 'Odds Fee', ad.Winlostdate), 0) - abs(isnull(ad.MemWinlost, 0)) * isnull(dbo.Aff_GetDeductionPercent(ad.AffID, t.ProductID, 'Marketing', ad.Winlostdate), 0) - abs(isnull(ad.MemWinlost, 0)) * isnull(dbo.Aff_GetDeductionPercent(ad.AffID, t.ProductID, 'PlayTech Royalties', ad.Winlostdate), 0) - isnull(ad.MemPSP, 0) * isnull(dbo.Aff_GetDeductionPercent(ad.AffID, t.ProductID, 'PSP', ad.Winlostdate), 0))
	FROM AffDailySummary ad WITH (ROWLOCK, UPDLOCK)
		INNER JOIN @temp t
		ON t.affid = ad.AffID
			AND t.previousMaxWinlostDate = ad.WinlostDate
			AND t.ProductID = ad.ProductID

	--don so tien winlostFake tat ca vao ngay cuoi cung cua thang nay 
	UPDATE d
	SET d.totalWinlost = isnull(c.totalwinlost, 0)
		,d.WLFake = isnull(c.memWinlostFake, 0)
		,d.totalPSP = isnull(c.memPSP, 0)
	FROM @temp d
		LEFT JOIN (
		SELECT t.affid
			,t.ProductID
			,sum(ad.memwinlost) totalwinlost
			,sum(ad.memWinlostFake) memWinlostFake
			,sum(ad.MemPSP) AS memPSP
		FROM AffDailySummary ad(NOLOCK)
			INNER JOIN @temp t
			ON t.AffID = ad.AffID
				AND t.ProductID = ad.ProductID
		WHERE ad.WinlostDate BETWEEN t.firstday AND t.previousMaxWinlostDate
		--and ad.ProductID = @SportsBookID  
		GROUP BY t.Affid
			,t.ProductID
		) c
		ON c.AffID = d.AffID
			AND c.ProductID = d.ProductID

	--Member Winlost - All Fee - Winlost fake from first date of month to yesterday
	UPDATE d
	SET MemWinlostFake = - (- (d1.totalwinlost + d.memwinlost) - abs(d1.totalwinlost + d.memwinlost) * (d1.oddsFeePercent + d1.marketingPercent + d1.PlaytechPercent) - (d1.totalPSP + d.MemPSP) * d1.PSPPercent) - d1.WLFake
	FROM AffDailySummary d WITH (ROWLOCK, UPDLOCK)
		INNER JOIN @temp d1
		ON d1.affid = d.affid
			AND d1.maxWinlostDate = d.winlostdate
			AND d1.ProductID = d.ProductID
	WHERE d1.previousMaxWinlostDate < d1.maxWinlostDate
END
GO


select * from MemberDaily
where WinlostDate = '2016-04-14 00:00:00'

select * from AffDaily
where WinlostDate = '2016-04-14 00:00:00'


select * from AffDailySummary
where WinlostDate = '2016-04-14 00:00:00'