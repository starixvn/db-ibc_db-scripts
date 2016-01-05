-- Scenario 7 - WIN Jackpot pool and BONUS >= 200000
--7.1. Place bet: new ticket on THE COLOSSUS event
--7.2. Settlement: member wins JACKPOT
--7.3. Member place one more ticket for BONUS prize
--7.4. Settlement BONUS: member wins BONUS

DECLARE @refno	BIGINT
	, @CustID	INT
SELECT @CustID  = 1176092

EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18000
	,@status  	= 'RUNNING'
	,@refno		= @refno OUTPUT
	
-- add Jackpot ticket
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18005
	,@status  	= 'WON'
	,@winAmount = 250000
	,@refno 	= @refno
	
---settle pool bet
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18000
	,@status  	= 'WON'
	,@refno 	= @refno
	
---settle BONUS WON
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18006
	,@status  	= 'WON'
	,@winAmount = 50000
	,@refno		= @refno
	
GO
