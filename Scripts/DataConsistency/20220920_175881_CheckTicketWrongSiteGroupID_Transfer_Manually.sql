/*<info serverAlias="DBTP-bodb02"></info>*/
/*
	Created: 20220920@Sol
	DB : DBTP-bodb02
	Task: Check data - [Redmine: #175881]
*/

USE bodb02;

GO

/*

--Get min/max trans id from sitedb => copy and run from sitedb
SELECT MIN(t.transid) AS MinTransID, MAX(t.transid) AS MaxTransID 
FROM Transfer t WITH (NOLOCK) 
WHERE WinlostDate = '20220922'

*/

DECLARE
	@SiteDBGroupID SMALLINT = 1,
	@TransferLastTransId BIGINT = 30539807344033792,
	@NewTransferLastTransId BIGINT = 30539807344033793,
	@BatchSize INT = 1000


BEGIN
	SET NOCOUNT ON

	SELECT TOP(@BatchSize)
		t.TransId
		,t.CustId
		,s.SiteDBGroupID AS CustomerSiteGroupId
		,r.SiteDBGroupID AS TicketSiteGroupId
	FROM bodb02.dbo.Transfer t WITH (NOLOCK)
		INNER JOIN bodb02.dbo.vw_Customer c WITH (NOLOCK)
			ON t.CustId = c.custid
		INNER JOIN bodb02.dbo.Site s WITH (NOLOCK)
			ON s.site = c.site
		CROSS APPLY 
		(
			SELECT f.SiteDBGroupID
			FROM bodb02.dbo.f_dba_transid_revert(t.TransId, 0) f
		) r
	WHERE 
		t.TransId > @TransferLastTransId 
		AND t.TransId <= @NewTransferLastTransId 
		AND t.Bettype NOT IN (19999, 20000)
		--AND s.SiteDBGroupID = @SiteDBGroupID 
		AND 1 = CASE WHEN r.SiteDBGroupID <> s.SiteDBGroupID THEN 1 ELSE 0 END
	ORDER BY t.TransId

END
GO