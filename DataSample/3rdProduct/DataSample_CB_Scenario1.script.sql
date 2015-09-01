--Scenario 1 - LOSE pool bet
--1.1. Place bet: new ticket on HDA15 event
--1.2. Settlement: ticket loses

DECLARE @refno	BIGINT
---- Scenario 1 - LOSE pool bet
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= 2723431
	,@Bettype 	= 18000
	,@status  	= 'RUNNING'
	,@refno 	= @refno OUTPUT
	
---settle pool bet
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= 2723431
	,@Bettype 	= 18000
	,@status  	= 'LOSE'
	,@refno 	= @refno
GO
