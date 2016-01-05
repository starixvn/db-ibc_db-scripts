/*
9.1. Place bet: new ticket on THE COLOSSUS event
9.2. Cash out: 30%
9.3. Cash out: all remaining 70% (total winning amount >= max amount)
9.4. Settlement ticket 
9.5. CSD confirm the disbursement
*/

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
	,@winAmount = 150000
	,@soldRate  = 0.3
	,@refno		= @refno

-- add cash out ticket 70%
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18002
	,@status  	= 'WON'
	,@winAmount = 200000
	,@soldRate  = 0.7
	,@refno		= @refno
	
---settle pool bet
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18000
	,@status  	= 'WON'
	,@refno 	= @refno
GO
