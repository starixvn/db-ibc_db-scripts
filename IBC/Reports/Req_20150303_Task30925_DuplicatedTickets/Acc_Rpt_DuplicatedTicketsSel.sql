ALTER PROCEDURE [dbo].[Acc_Rpt_DuplicatedTicketsSel]
	@Date datetime
AS
/*
Created: 20150212@Sophia
Task :	Get Duplicated ticket report
DB:		DBRPT/bodb_report
Original: [Acc_CheckDuplicateTickets]

Revisions:
	 
Param's Explanation:

*/
BEGIN
	SET NOCOUNT ON
	
	DECLARE @DateFrom DATETIME
	SELECT @DateFrom = DATEADD(dd, 0, DATEDIFF(dd, 0, @Date) ) -- get begin of the day (just in case param input time also)
		 

	SELECT	b.custid, b.odds, b.stake, b.balance, b.status, b.statusID, b.bettype, b.winlostdate, b.username, b.transid, b.transdate, bt.typenamee as typename 
	FROM	dbo.DuplicatedTicket t WITH (NOLOCK)	
		INNER JOIN bodb02.dbo.Bettrans b WITH (NOLOCK)	
				ON b.TransID = t.TransID
		INNER JOIN bodb02.dbo.bettype bt WITH (NOLOCK) 
				ON bt.typeid = b.bettype
	WHERE	t.Transdate >= @DateFrom 
		AND t.Transdate < DATEADD(dd, 1, DATEDIFF(dd, 0, @DateFrom))
	ORDER BY b.custid, b.odds, b.stake, b.balance, b.bettype, b.winlostdate, b.Username, b.transid, b.transdate, b.status, b.statusID	  

		
END

GO
GRANT EXECUTE ON [dbo].[Acc_Rpt_DuplicatedTicketsSel] TO [bodbAdminNet]
GO