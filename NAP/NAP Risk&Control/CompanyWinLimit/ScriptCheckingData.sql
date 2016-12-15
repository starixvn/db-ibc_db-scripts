/********This is SIT environment*******/
DECLARE @WinlostDate SMALLDATETIME, @ReachedDate DATETIME
	SELECT @WinlostDate = CAST(GETDATE() AS DATE)

	--INSERT INTO #DataTmp(CustId, WinlostDate, Bettype, TotalWinAmount,IsPrivateSetting)
	SELECT CustId, WinlostDate, BetType, SUM(Winlost),0
	FROM (
		SELECT CustId, WinlostDate, BetType, Winlost
		FROM DBTXN.bodb02.dbo.Winlimit_CreditGame c WITH(NOLOCK)
		WHERE WinlostDate = @WinlostDate and custid = 17068894 and bettype = 2101

		UNION ALL
		
		SELECT CustId, WinlostDate, BetType, - Winlost
		FROM DBTXN.bodb02.dbo.Winlimit_DebitGame c WITH(NOLOCK)
		WHERE WinlostDate = @WinlostDate and  custid = 17068894 and bettype = 2101
			
	)t
	GROUP BY CustId, WinlostDate, BetType

select @WinlostDate

--select transid,transdate,winlost-actual_stake,gameid 
--from DBTXN.bodb02.dbo.bettransRNG with (nolock) 
--where custid=5013852 and winlostdate='2016-12-13' --and gameid = 2101
--order by transid

select * from WinLimit_CustGameMonitoring_uat (nolock) where CustID = 17068894 and bettypeid = 2101
select * from WinLimit_CustGameMonitoring_history_uat (nolock) where CustID = 17068894 and bettypeid = 2101
select * from WinLimit_CustGameStatus_UAT (nolock) where CustID = 17068894 

select * from WinLimit_CustGameSetting_UAT (nolock) where CustID = 5013852 and GroupID = 7 and ProductID = 6

select * from WinLimit_CustGameMonitoring (nolock) where CustID = 5013852 and bettypeid = 2101
select * from WinLimit_CustGameMonitoring_history(nolock) where CustID = 5013852 and bettypeid = 2101
select * from WinLimit_CustGameStatus(nolock) where CustID = 5013852 

select * from WinLimit_CustGameSetting (nolock) where CustID = 5013852 and ProductID = 6
  
select * from Winlimit_GameGroupSetting_UAT where BetTypeID = 2101 
select * from WinLimit_ProductSettingDetail_UAT where GroupID = 7 and Siteid = 1 and exchangeid= 20
--select recommend from custinfo (nolock) where CustID = 5013852 
--select Site from customer (nolock) where custid = 4317260
--select * from Site where site = 'BEST-ODDS'

SELECT 
--T.CustId,T.ProductId,T.BettypeID,
	PSD.IsBlockedPlaceBet
	, PSD.IsBlockedTransfer
	, CASE WHEN PSD.IsBlockedPlaceBet = 1 AND PSD.IsBlockedTransfer = 1 THEN 5
									   WHEN PSD.IsBlockedPlaceBet = 1 THEN 1
									   WHEN PSD.IsBlockedTransfer = 1 THEN 3
								   ELSE 0 END AS ActionID
					--,@ReachedDate AS ModifiedDate
	,cs.CustID				
FROM WinLimit_ProductSettingDetail_UAT psd WITH (NOLOCK)  
	INNER JOIN WinLimit_GameGroupSetting_UAT GS WITH (NOLOCK) ON GS.GroupID = psd.GroupID AND 2101 = GS.BettypeID  
	LEFT JOIN WinLimit_CustGameStatus_UAT CS (NOLOCK) ON 5013852 = CS.CustId AND 6 = CS.ProductID AND 2101 = CS.BettypeID
WHERE psd.ProductId = 6 AND 20 = psd.ExchangeID AND 1 = PSD.SiteID AND 3 = psd.LevelID
	and cs.CustID is null		


exec NAP_WinLimit_CustomerInformationSel_xtest @CustId=5013852			