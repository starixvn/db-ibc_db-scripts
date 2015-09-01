---- Scenario 6 - WIN Jackpot pool and cash-out < 200000
--6.1. Place bet: new ticket on THE COLOSSUS event
--6.2. Cash out: 30%
--6.3. Cash out: 10%
--6.4. Settlement: member wins JACKPOT (total winning amount < max amount)
--6.5. Member place one more ticket for BONUS prize
--6.7. Settlement BONUS: member loses BONUS
DECLARE @refno	BIGINT
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= 2723431
	,@Bettype 	= 18000
	,@status  	= 'RUNNING'
	,@refno		= @refno OUTPUT

-- add cash out ticket 30%
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= 2723431
	,@Bettype 	= 18002
	,@status  	= 'WON'
	,@winAmount = 15000
	,@soldRate  = 0.3
	,@refno		= @refno

-- add cash out ticket 10%
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= 2723431
	,@Bettype 	= 18002
	,@status  	= 'WON'
	,@winAmount = 10000
	,@soldRate  = 0.1
	,@refno		= @refno

	-- add Jackpot ticket
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= 2723431
	,@Bettype 	= 18005
	,@status  	= 'WON'
	,@winAmount = 100000
	,@refno		= @refno

---settle pool bet
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= 2723431
	,@Bettype 	= 18000
	,@status  	= 'WON'
	,@refno		= @refno
GO
-----------------------------------------------------------