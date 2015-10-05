-- Scenario 7 - WIN Jackpot pool and cash-out < 200000
--7.1. Place bet: new ticket on THE COLOSSUS event
--7.2. Settlement: member wins JACKPOT
--7.3. Member place one more ticket for BONUS prize
--7.4. Settlement BONUS: member wins BONUS

DECLARE @refno	BIGINT
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= 2723431
	,@Bettype 	= 18000
	,@status  	= 'RUNNING'
	,@refno		= @refno OUTPUT
	
-- add Jackpot ticket
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= 2723431
	,@Bettype 	= 18005
	,@status  	= 'WON'
	,@winAmount = 150000
	,@refno 	= @refno
	
---settle pool bet
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= 2723431
	,@Bettype 	= 18000
	,@status  	= 'WON'
	,@refno 	= @refno
GO
