--Scenario 5 - LOSE pool and cash-out >= 200000
--5.1. Place bet: new ticket on THE COLOSSUS event
--5.2. Cash out: 30%
--5.3. Cash out: 10%
--5.4. Settlement: ticket loses (total cash out amount >= max amount)
DECLARE @refno	BIGINT
	, @CustID	INT
SELECT @CustID  = 1176092

EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18000
	,@status  	= 'RUNNING'
	,@refno		= @refno OUTPUT

-- add cash out ticket 30%
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18002
	,@status  	= 'WON'
	,@winAmount = 200000
	,@soldRate  = 0.3
	,@refno		= @refno

-- add cash out ticket 10%
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18002
	,@status  	= 'WON'
	,@winAmount = 100000
	,@soldRate  = 0.1
	,@refno 	= @refno

---settle pool bet
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18000
	,@status  	= 'WON'
	,@refno 	= @refno
GO