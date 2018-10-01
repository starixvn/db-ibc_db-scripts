USE [Affiliate_12BET]
GO

/*
	Created: 20181001@Percy
	DB: DBAFF12BET-Affiliate_12BET
	Task: Reset calculate data commission due to reset testing data
*/

--- Refer SP: Task_Aff_MonthlyTransfer

DECLARE
	@FirstDay							SMALLDATETIME = '2018-08-01',
	@LastDay							SMALLDATETIME = '2018-08-31',
	@TransType							INT = 201,
	@SportsBookID						INT = 1,
	@CasinoID							INT = 3,
	@MinimumNegativeCommission			FLOAT = 0.1,
	@MinimumNegativeCasinoCommission	FLOAT = 0.05

-- Calculate data 
CREATE TABLE #AffSummary  
(
	AffID						INT,  
	Currency					INT,     
	GroupID						INT,  
	SportID						INT,  
	MemWinlost					MONEY,  
	MemBonus					MONEY,  
	MemAdjustment				MONEY,  
	MemPSP						MONEY,  
	Marketing					MONEY,  
	MemDeposit					MONEY,  
	MemWithdrawal				MONEY,  
	MemTurnover					MONEY,  
	Commission					DECIMAL(9,8),  
	TotalQM						INT,    
	ActivePlayer				INT,    
	NetWinlost					MONEY,   
	BonusPercent				FLOAT,  
	MarketingPercent			FLOAT,  
	AdjustmentPercent			FLOAT,  
	PSPPercent					FLOAT,  
	OddsFeePercent				FLOAT,  
	PlayTechRoyaltiesPercent	FLOAT,
	IsPSPIncluded				INT
)  
  
INSERT INTO #AffSummary
(
	AffID,Currency,GroupID,SportID,
	MemWinlost,MemBonus,MemAdjustment,MemPSP,Marketing,MemDeposit,MemWithdrawal,MemTurnover,
	TotalQM,ActivePlayer,BonusPercent,AdjustmentPercent,MarketingPercent,PSPPercent,OddsFeePercent,PlayTechRoyaltiesPercent,IsPSPIncluded
)
SELECT
	t.AffId, t.Currency, t.GroupID, t.SportType AS SportID
	,SUM(ISNULL(r.Winlost,0))		AS MemWinlost
	,SUM(ISNULL(r.Bonus,0))			AS MemBonus
	,SUM(ISNULL(r.Adjustment,0))	AS MemAdjustment
	,SUM(ISNULL(r.PSP,0))			AS MemPSP
	,SUM(ISNULL(r.Marketing,0))		AS Marketing
	,SUM(ISNULL(r.Deposit,0))		AS MemDeposit
	,SUM(ISNULL(r.Withdrawal,0))	AS MemWithdrawal
	,SUM(ISNULL(r.Turnover,0))		AS MemTurnover
	,SUM(CASE WHEN r.TurnOver >= s.QMTurnOver AND r.Deposit >= s.QMDeposit THEN 1 ELSE 0 END) AS TotalQM
	,SUM(CASE WHEN r.TurnOver > 0 OR r.Deposit > 0 THEN 1 ELSE 0 END)				AS ActivePlayer
	,dbo.Aff_GetDeductionPercent(t.AffID,t.SportType,'Bonus',@LastDay)				AS BonusPercent
	,dbo.Aff_GetDeductionPercent(t.AffID,t.SportType,'Adjustment',@LastDay)			AS AdjustmentPercent
	,dbo.Aff_GetDeductionPercent(t.AffID,t.SportType,'Marketing',@LastDay)			AS MarketingPercent
	,dbo.Aff_GetDeductionPercent(t.AffID,t.SportType,'PSP',@LastDay)				AS PercentPSP
	,dbo.Aff_GetDeductionPercent(t.AffID,t.SportType,'Odds Fee',@LastDay)			AS OddsFeePercent
	,dbo.Aff_GetDeductionPercent(t.AffID,t.SportType,'PlayTech Royalties',@LastDay) AS PlayTechRoyaltiesPercent
	,0 AS IsPSPIncluded  
FROM
(
	SELECT DISTINCT ai.AffId, gh.GroupID, ai.Currency, g.SportType
	FROM dbo.AffInfo ai WITH (NOLOCK)
		INNER JOIN dbo.AffGroupHistory gh WITH (NOLOCK) ON gh.AffID = ai.AffID AND gh.MonthDate = @LastDay  
		INNER JOIN dbo.GroupSettingHistory g WITH (NOLOCK) ON gh.GroupId = g.GroupId AND g.MonthDate = @LastDay  
	WHERE ai.AffId IN (927841,92039950,92040664,92040667)
) AS t
	LEFT JOIN
	(
		SELECT
			IBCCustID, SportType, AffID  
			,SUM(ISNULL(Winlost,0)		* ISNULL(AffExRate,1)) AS Winlost  
			,SUM(ISNULL(Bonus,0)		* ISNULL(AffExRate,1)) AS Bonus  
			,SUM(ISNULL(Adjustment,0)	* ISNULL(AffExRate,1)) AS Adjustment  
			,SUM(ISNULL(PSP,0)			* ISNULL(AffExRate,1)) AS PSP  
			,SUM(ISNULL(Marketing,0)	* ISNULL(AffExRate,1)) AS Marketing  
			,SUM(ISNULL(TurnOver,0)		* ISNULL(AffExRate,1)) AS TurnOver  
			,SUM(ISNULL(Deposit,0)		* ISNULL(AffExRate,1)) AS Deposit  
			,SUM(ISNULL(Withdrawal,0)	* ISNULL(AffExRate,1)) AS Withdrawal  
		FROM dbo.MemberDaily md WITH (NOLOCK)
		WHERE WinlostDate BETWEEN @FirstDay AND @LastDay
			AND md.AffId IN (927841,92039950,92040664,92040667)
			AND md.IBCCustID NOT IN (
				SELECT mi.IBCCustID
				FROM dbo.MemberInfo mi WITH (NOLOCK)
					LEFT JOIN dbo.MemberRemoval mr WITH (NOLOCK) ON mi.IBCCustID = mr.IBCCustID
				WHERE mi.IsRemoved = 1
					AND (
						DATEDIFF(mm, RemovedDate, @LastDay) >= 0 
						OR mr.IBCCustID IS NULL
					)
			)
		GROUP BY IBCCustID, SportType, AffID
	) AS r ON r.AffID = t.AffID AND t.SportType = r.SportType  
	LEFT JOIN dbo.SportType s WITH (NOLOCK) ON s.SportID = r.SportType  
GROUP BY t.AffID, t.GroupID, t.SportType, t.Currency

-- Reset SportId value
UPDATE #AffSummary
SET SportID = @SportsBookID
WHERE SportID IS NULL
	AND MemTurnover = 0
	AND MemWinlost = 0
	AND MemBonus = 0
	AND MemAdjustment = 0
	AND MemPSP = 0
	AND Marketing = 0  

-- Decide which SportID should include PSP
DECLARE @AffSummary TABLE
(
	AffId				INT,
	MaxWinlost			MONEY,
	PSP					MONEY,
	PSPPercent			FLOAT,
	MaxWinlostSportID	INT
)
INSERT INTO @AffSummary (AffId, PSP, PSPPercent)
SELECT AffId, ISNULL(MemPSP, 0), PSPPercent
FROM #AffSummary
WHERE SportID = @SportsBookID

UPDATE a
SET a.MaxWinlost = (SELECT MAX(ABS(a1.MemWinlost)) FROM #AffSummary a1 WHERE a1.AffId = a.AffId)
FROM @AffSummary a

UPDATE a
SET a.MaxWinlostSportID = COALESCE((SELECT TOP 1 a1.SportId FROM #AffSummary a1
															WHERE a1.AffId = a.AffId
																AND abs(a1.MemWinlost) = a.MaxWinlost
																AND a1.SportID <> @SportsBookID
									),@SportsBookID)
FROM @AffSummary a

-- Reupdate PSP for which sport has maximum abs(winlost)
UPDATE a
SET a.IsPSPIncluded = 1,
	a.MemPSP		= a1.PSP,
	a.PSPPercent	= a1.PSPPercent
FROM #AffSummary a
	INNER JOIN @AffSummary a1 ON a1.AffId = a.AffId
WHERE a.SportId = a1.MaxWinlostSportID
  
--Choose commission value and calculate Total Balance after deduction for each Affiliate and SportID  
UPDATE a 
SET a.NetWinlost = (
		-ISNULL(a.MemWinlost,0)   
		- ISNULL(a.MemPSP,0)*ISNULL(a.PSPPercent,0)  * a.IsPSPIncluded 
		- ABS(ISNULL(a.MemWinlost,0)) * ISNULL(a.OddsFeePercent,0)   
		- ABS(ISNULL(a.MemWinlost,0)) * ISNULL(a.MarketingPercent,0)   
		- ABS(ISNULL(a.MemWinlost,0)) * ISNULL(a.PlayTechRoyaltiesPercent,0)   
		),  
	a.commission = ISNULL((
		SELECT TOP(1) Commission  
		FROM   
		(  
			SELECT ISNULL((
				SELECT Commission  
				FROM GroupSettingHistory(nolock)  
				WHERE GroupID=a.GroupID   
					AND SportType=a.SportID  
					AND MonthDate=@LastDay  
					AND floor(ABS(
								-ISNULL(a.MemWinlost,0)   
								- ISNULL(a.MemPSP,0)*ISNULL(a.PSPPercent,0)  * a.IsPSPIncluded  
								- ABS(ISNULL(a.MemWinlost,0)) * ISNULL(a.OddsFeePercent,0)   
								- ABS(ISNULL(a.MemWinlost,0)) * ISNULL(a.MarketingPercent,0)   
								- ABS(ISNULL(a.MemWinlost,0)) * ISNULL(a.PlayTechRoyaltiesPercent,0)                   
							))  
						BETWEEN MinAmount AND MaxAmount),0) AS Commission  
			UNION ALL                               
			SELECT ISNULL((
				SELECT TOP(1) Commission   
				FROM GroupSettingHistory(nolock)  
				WHERE GroupID=a.GroupID   
					AND SportType=a.SportID   
					AND MonthDate=@LastDay  
					AND a.TotalQM BETWEEN MinQM AND MaxQM  
				),0) AS Commission  
	   ) t    
	   ORDER BY t.Commission ASC  
	 ),0)  
FROM #AffSummary a  
  
UPDATE a
SET a.Commission = (CASE WHEN a.SportID = @CasinoID THEN @MinimumNegativeCasinoCommission ELSE @MinimumNegativeCommission END)  
FROM #AffSummary a  
WHERE
	a.NetWinlost < 0
	AND a.Commission = 0
	AND [dbo].[IsZeroCommissionGroup](a.GroupID,@LastDay)=0    
	AND a.SportID IN (SELECT DISTINCT SportID FROM GroupSettingHistory (NOLOCK) WHERE GroupID=a.GroupID AND DATEDIFF(m,MonthDate,@LastDay)=0)    

-- Insert transaction
DECLARE @WinlostDate SMALLDATETIME  
SELECT  @WinlostDate = CURRENT_TIMESTAMP  
  
-- Remove old data
 BEGIN
	DELETE dbo.AffCommission WITH (ROWLOCK, UPDLOCK)
	WHERE WinlostDate = @LastDay AND AffId IN (927841,92039950,92040664,92040667)

	DELETE dbo.AffTrans WITH (ROWLOCK, UPDLOCK)
	WHERE TransDate = @LastDay
		AND TransType = @TransType
		AND Description = 'Monthly Earning'
		AND AffId IN (927841,92039950,92040664,92040667)
 END

-- insert new data
DECLARE @Temp TABLE (RefID INT, AffID INT, SportID TINYINT)

INSERT INTO dbo.AffCommission
(
	AffID,GroupID,SportID,WinlostDate,QualifiedMember,ActivePlayer,Commission,AffWinlost,  
	Status,MemberWinlost,MemberBonus,MemberAdjustment,MemberPSP,MemberSum,
	Marketing,HasBonus,HasAdjustment,HasMarketing,HasPSP,MemberDeposit,MemberWITHdrawal,MemberTurnover,
	HasOddsFee,MemOddsFee,HasPlayTechFee,MemPlayTechFee
)  
OUTPUT inserted.RefID, inserted.AffID, inserted.SportID INTO @Temp
SELECT
	AffID,GroupID,SportID,@LastDay,TotalQM,ActivePlayer,Commission ,(NetWinlost- ISNULL(a.MemBonus,0)*ISNULL(a.BonusPercent,0))* ISNULL(Commission,0),   
	'Approved',MemWinlost,MemBonus,MemAdjustment,MemPSP,-NetWinlost, 
	ABS(ISNULL(MemWinlost,0)) * ISNULL(MarketingPercent,0),
	(CASE WHEN ISNULL(a.BonusPercent,0)<>0					THEN 1 ELSE 0 END),
	(CASE WHEN ISNULL(a.AdjustmentPercent,0)<>0				THEN 1 ELSE 0 END),
	(CASE WHEN ISNULL(a.MarketingPercent,0)<>0				THEN 1 ELSE 0 END),
	(CASE WHEN ISNULL(a.PSPPercent,0)<>0					THEN 1 ELSE 0 END),
	MemDeposit, 
	MemWITHdrawal,
	MemTurnover,
	(CASE WHEN ISNULL(a.OddsFeePercent,0)<>0				THEN 1 ELSE 0 END),
	ABS(ISNULL(MemWinlost,0)) * ISNULL(OddsFeePercent,0),
	(CASE WHEN ISNULL(a.PlayTechRoyaltiesPercent,0)<>0		THEN 1 ELSE 0 END),
	ABS(ISNULL(MemWinlost,0)) * ISNULL(a.PlayTechRoyaltiesPercent,0)
FROM #AffSummary a

UPDATE d  
SET d.RelNo=(SELECT TOP 1 RefID FROM @Temp d1 WHERE d1.AffID=d.AffID AND d1.SportID=d1.SportID)  
FROM dbo.AffCommission d WITH (ROWLOCK, UPDLOCK)
WHERE d.WinlostDate = @LastDay  
	AND d.AffId IN (927841,92039950,92040664,92040667)
  
INSERT INTO dbo.AffTrans (AffID,TransDate,CompletedDate,Amount,Status,Description,Creator,Currency,TransType)  
SELECT a.AffID,@LastDay,@WinlostDate, SUM((NetWinlost-ISNULL(a.MemBonus,0)*ISNULL(a.BonusPercent,1)) * ISNULL(Commission,0)),'Approved', 'Monthly Earning', 148,a.Currency,@TransType  
FROM #AffSummary a
GROUP BY a.AffID,a.Currency  
   
UPDATE d  
SET d.RefID=(SELECT TOP 1 RefID FROM @Temp d1 WHERE d1.AffID=d.AffID AND d1.SportID = @SportsBookID)  
FROM dbo.AffTrans d WITH (ROWLOCK, UPDLOCK)
WHERE d.TransDate = @LastDay AND d.TransType = @TransType 
	AND d.AffId IN (927841,92039950,92040664,92040667)
	  
UPDATE ad   
SET
	ad.AffWinlost		= -ISNULL(ad.MemWinlost,0) *  ISNULL(a.commission,0),  
	ad.HouseWinlost		= -ISNULL(ad.MemWinlost,0) * (1-ISNULL(a.commission,0)),  
	ad.AffNetWinlost	= (
		- ISNULL(ad.MemWinlost,0)   
		- ISNULL(ad.MemPSP,0) * ISNULL(a.PSPPercent,0)  
		- ABS(ISNULL(ad.MemWinlost,0)) * ISNULL(a.OddsFeePercent,0)   
		- ABS(ISNULL(ad.MemWinlost,0)) * ISNULL(a.MarketingPercent,0)   
		- ABS(ISNULL(ad.MemWinlost,0)) * ISNULL(a.PlayTechRoyaltiesPercent,0)         
		) * ISNULL(a.commission,0),  
	ad.HouseNetWinlost	= (
		- ISNULL(ad.MemWinlost,0)   
		- ISNULL(ad.MemPSP,0)*ISNULL(a.PSPPercent,0)  
		- ABS(ISNULL(ad.MemWinlost,0)) * ISNULL(a.OddsFeePercent,0)   
		- ABS(ISNULL(ad.MemWinlost,0)) * ISNULL(a.MarketingPercent,0)   
		- ABS(ISNULL(ad.MemWinlost,0)) * ISNULL(a.PlayTechRoyaltiesPercent,0)          
		) * (1-ISNULL(a.commission,0))   
FROM dbo.AffDaily ad WITH (ROWLOCK, UPDLOCK)
	LEFT JOIN #AffSummary a ON a.AffID=ad.AffID AND a.SportID=ad.SportID       
WHERE DATEDIFF(mm, ad.Winlostdate, @FirstDay)=0    
	AND ad.AffId IN (927841,92039950,92040664,92040667)
	 
UPDATE ad   
SET
	ad.AffWinlost		= -ISNULL(ad.MemWinlost,0) *  ISNULL(a.commission,0),  
	ad.HouseWinlost		= -ISNULL(ad.MemWinlost,0) * (1-ISNULL(a.commission,0)),  
	ad.AffNetWinlost	= (
		- ISNULL(ad.MemWinlost,0)   
		- ISNULL(ad.MemPSP,0) * ISNULL(a.PSPPercent,0)  
		- ABS(ISNULL(ad.MemWinlost,0)) * ISNULL(a.OddsFeePercent,0)   
		- ABS(ISNULL(ad.MemWinlost,0)) * ISNULL(a.MarketingPercent,0)   
		- ABS(ISNULL(ad.MemWinlost,0)) * ISNULL(a.PlayTechRoyaltiesPercent,0)          
		) * ISNULL(a.commission,0),  
	ad.HouseNetWinlost	= (
		-ISNULL(ad.MemWinlost,0)   
		- ISNULL(ad.MemPSP,0)*ISNULL(a.PSPPercent,0)  
		- ABS(ISNULL(ad.MemWinlost,0)) * ISNULL(a.OddsFeePercent,0)   
		- ABS(ISNULL(ad.MemWinlost,0)) * ISNULL(a.MarketingPercent,0)   
		- ABS(ISNULL(ad.MemWinlost,0)) * ISNULL(a.PlayTechRoyaltiesPercent,0)          
		) * (1-ISNULL(a.commission,0))   
FROM dbo.AffDailySummary ad WITH (ROWLOCK, UPDLOCK)
	LEFT JOIN #AffSummary a ON a.AffID=ad.AffID AND a.SportID=ad.SportID       
WHERE DATEDIFF (mm,ad.Winlostdate, @FirstDay)=0    
	AND ad.AffId IN (927841,92039950,92040664,92040667)

DROP TABLE #AffSummary