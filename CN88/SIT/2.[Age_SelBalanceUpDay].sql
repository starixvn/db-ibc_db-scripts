USE [bodb02]
GO
/****** Object:  StoredProcedure [dbo].[Age_SelBalanceUpDay]    Script Date: 04/01/2019 02:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[Age_SelBalanceUpDay]		
		
AS	
/*
Created: 
Task : Get move bet day, balanceup day
DB: DBAGE.bodb02
Original:

Revisions:
    - 20090311@Daniel: grant permission to [bodbAdminNet] 
    - 20090324@Thien: modify to retrieve balanceUpDay by bettype 100 and matchID 0
	- 20090730@Viet: Hardcode CustID for better performance
	- 20101224@Johnson: Apply new arrange of bettype

Param's Explanation:
*/

SET NOCOUNT ON
BEGIN
	declare @BalanceUpDay smalldatetime, @MoveBetsDay smalldatetime
	SELECT 
		TOP 1 @BalanceUpDay = winlostdate
	FROM Bettrans WITH(NOLOCK)
	WHERE bettype = 20000 and matchid = 0 and custid = 3
	
	SELECT 		
		@MoveBetsDay = max(eventdate) 
		FROM match14 WITH(NOLOCK)

	select '2019-03-27 00:00:00'  as BalanceUpDay, '2019-03-30 00:00:00' as MoveBetsDay
END




 