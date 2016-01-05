--Scenario 1 - LOSE pool bet
--1.1. Place bet: new ticket on HDA15 event
--1.2. Settlement: ticket loses

DECLARE @refno	BIGINT
	, @CustID	INT
SELECT @CustID  = 1176092

---- Scenario 1 - LOSE pool bet
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18000
	,@status  	= 'RUNNING'
	,@refno 	= @refno OUTPUT
	
---settle pool bet
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= @CustID
	,@Bettype 	= 18000
	,@status  	= 'LOSE'
	,@refno 	= @refno
GO
