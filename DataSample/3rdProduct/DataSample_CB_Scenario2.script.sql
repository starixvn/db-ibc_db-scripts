----Scenario 2 - LOSE pool bet and WIN CONSOLATION prize
--2.1. Place bet: new ticket on THE COLOSSUS event
--2.2. Settlement: member wins CONSOLATION pool (total winning amount >= max amount)
DECLARE @refno	BIGINT
	, @CustID	INT
SELECT @CustID  = 1176092
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18000
	,@status  	= 'RUNNING'
	,@refno		= @refno OUTPUT
	
-- add consolation ticket > 200000
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18004
	,@status  	= 'WON'
	,@winAmount = 500000
	,@refno 	= @refno

---settle pool bet
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18000
	,@status  	= 'LOSE'
	,@refno 	= @refno
GO