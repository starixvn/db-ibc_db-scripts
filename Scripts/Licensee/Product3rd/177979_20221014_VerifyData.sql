/*<info serverAlias="DBPTCS-bodb_PlaytechCS"></info>*/
/*
	Created: 20221014@Sol
	DB: DBPTCS-bodb_PlaytechCS
	Task: Verify data - [Redmine: #177979]
*/

--## RUN IN DB052 AND DB053 respectively ##--
--###########################################

GO

--## For table [Product3rd_ImportQueue] ##--
BEGIN 

	USE bodb_PlaytechCS;

	DECLARE 
		@CheckInFrom DATETIME = '2022-08-01', 
		@CheckInTo DATETIME = '2022-09-01',
		@FromQueueId BIGINT = 825339

	SELECT 'DB052' -- or DB053
		,QueueID
		,CHECKSUM_AGG(CHECKSUM(QueueID, CheckInTime, LicenseeName, ProductID, Winlostdate, LogDesc, isSummarized, JobType, StartDate, EndDate, IsForceUpdate))
	FROM bodb_PlaytechCS.dbo.Product3rd_ImportQueue WITH (NOLOCK)
	WHERE ProductID = 31  
		AND CheckInTime >= @CheckInFrom
		AND CheckInTime < @CheckInTo
		AND QueueID >= @FromQueueId
	GROUP BY QueueID
	ORDER BY QueueID

END

GO

--## For table [Sum_winloss_Exchange] ##--
BEGIN 

	USE bodb_3rdProduct;

	DECLARE 
		@settledDateFrom DATETIME = '2022-08-01', 
		@settledDateTo DATETIME = '2022-09-01'

	SELECT 'DB052',
		s.eventID,
		CHECKSUM_AGG(CHECKSUM(s.marketID, s.Currency, profitLoss, marketTotal, commission, agentCommission, stakeTotal, s.CustID, s.userId, s.agentId, s.settledDate)),
		COUNT(1)
	FROM bodb_3rdProduct.dbo.Sum_winloss_Exchange s WITH (NOLOCK)
	WHERE s.settledDate >= @settledDateFrom
		AND s.settledDate < @settledDateTo
	GROUP BY s.eventID
	ORDER BY s.eventID

END

GO


--## For table [Bettrans_Exchange] ##--
BEGIN 

	USE bodb_3rdProduct;

	DECLARE 
		@betPlacedFrom DATETIME = '2022-08-01', 
		@betPlacedTo DATETIME = '2022-09-01'

	SELECT 'DB052',
		s.eventID,
		CHECKSUM_AGG(CHECKSUM(site
							,currencyType
							,eventType
							,eventTypeName
							,eventName
							,eventID
							,marketName
							,marketID
							,selectionName
							,selectionID
							,matchType
							,betID
							,betPlaced
							,ip
							,matchOddsReq
							,unMatchAmount
							,reduction
							,userId
							,extension1
							,matchStake
							,matchAvgOdds
							,profitLoss
							,dateMatched
							,betstatus
							,fancyBetRuns
							,categoryType)),
		COUNT(1)
	FROM bodb_3rdProduct.dbo.Bettrans_Exchange s WITH (NOLOCK)
	WHERE s.betPlaced >= @betPlacedFrom
		AND s.betPlaced < @betPlacedTo
	GROUP BY s.eventID
	ORDER BY s.eventID

END

GO

--## For table [BettransM_Exchange] ##--
BEGIN 

	USE bodb_3rdProduct;

	DECLARE 
		@betTakenFrom DATETIME = '2022-08-01', 
		@betTakenTo DATETIME = '2022-09-01'

	SELECT 'DB052',
		CHECKSUM_AGG(CHECKSUM(BetID
							,betTaken
							,txStake
							,txOddsMatched
							,actualOdds
							,txFancyBetRuns)),
		COUNT(1)
	FROM bodb_3rdProduct.dbo.BettransM_Exchange s WITH (NOLOCK)
	WHERE s.betTaken >= @betTakenFrom
		AND s.betTaken < @betTakenTo

END

GO


--## For table [Product3rd_SummarizedDateHistory] ##--
BEGIN 

	USE bodb_3rdProduct;

	DECLARE 
		@WinlostDateFrom DATETIME = '2022-08-01', 
		@WinlostDateTo DATETIME = '2022-09-01'

	SELECT 'DB052',
		CHECKSUM_AGG(CHECKSUM(ProductID
							,WinlostDate
							)),
		COUNT(1)
	FROM bodb_3rdProduct.dbo.Product3rd_SummarizedDateHistory s WITH (NOLOCK)
	WHERE s.WinlostDate >= @WinlostDateFrom
		AND s.WinlostDate < @WinlostDateTo

END

GO


--## For table [rptDepWinlost_ThirdParty] ##--
BEGIN 

	USE bodb_LicenseeReport;

	DECLARE 
		@WinlostDateFrom DATETIME = '2022-08-01', 
		@WinlostDateTo DATETIME = '2022-09-01'

	SELECT 'DB052',
		CHECKSUM_AGG(CHECKSUM(Winlostdate
							,Custid
							,ProductId
							,Turnover
							,Winlost
							,BetCount
							,Currency
							,DrawTO
							,DrawBetCount
							,ValidBetAmount
							,CommissionP
							,CommissionA
							,WinLostA
							,Bettype
							)),
		COUNT(1)
	FROM bodb_LicenseeReport.dbo.rptDepWinlost_ThirdParty s WITH (NOLOCK)
	WHERE s.WinlostDate >= @WinlostDateFrom
		AND s.WinlostDate < @WinlostDateTo

END

GO


--## For table [rpt_BettingByProduct] ##--
BEGIN 

	USE bodb_LicenseeReport;

	DECLARE 
		@rptDateFrom DATETIME = '2022-08-01', 
		@rptDateTo DATETIME = '2022-09-01'

	SELECT 'DB052',
		CHECKSUM_AGG(CHECKSUM(rptDate
							,SiteID
							,ProductID
							,Bettype
							,CurrencyId
							,StatusId
							,CustomerCategory
							,GrossWL
							,MemberWL
							,Turnover
							,BetCount
							,CommissionA
							,CommissionP
							,BuyBackAmount
							,WinPrizeAmount
							,CashOutAmount
							,ValidBetAmount
							,TicketType
							,ExtraAmount
							)),
		COUNT(1)
	FROM bodb_LicenseeReport.dbo.rpt_BettingByProduct s WITH (NOLOCK)
	WHERE s.rptDate >= @rptDateFrom
		AND s.rptDate < @rptDateTo

END

GO