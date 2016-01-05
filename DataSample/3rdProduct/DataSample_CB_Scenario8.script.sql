--Scenario 8 - WIN Jackpot pool and cash-out < 200000
--8.1. Place bet: new ticket on THE COLOSSUS event
--8.2. Cash out: 30%
--8.3. Cash out: all remaining 70% all stake was cash out, so we do settle for this ticket
--8.4 Settlement WON

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
	,@winAmount = 10000
	,@soldRate  = 0.3
	,@refno		= @refno

-- add cash out ticket 10%
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18002
	,@status  	= 'WON'
	,@winAmount = 20000
	,@soldRate  = 0.7
	,@refno		= @refno
	
---settle pool bet
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18000
	,@status  	= 'WON'
	,@refno 	= @refno
GO
