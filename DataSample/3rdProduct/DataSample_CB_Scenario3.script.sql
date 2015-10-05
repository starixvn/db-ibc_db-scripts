--Scenario 3 - WIN CONSOLATION prize < 200000
--3.1. Place bet: new ticket on THE COLOSSUS event
--3.2. Settlement: member wins CONSOLATION pool (total winning amount < max amount)
DECLARE @refno	BIGINT
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= 2723431
	,@Bettype 	= 18000
	,@status  	= 'RUNNING'
	,@refno		= @refno OUTPUT
	
-- add consolation ticket < 200000
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= 2723431
	,@Bettype 	= 18004
	,@status  	= 'WON'
	,@winAmount = 15000
	,@refno		= @refno

---settle pool bet
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= 2723431
	,@Bettype 	= 18000
	,@status  	= 'LOSE'
	,@refno		= @refno
GO