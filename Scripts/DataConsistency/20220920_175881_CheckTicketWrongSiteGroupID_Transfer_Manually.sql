/*<info serverAlias="DBSIG-bodb02"></info>*/
/*
	Created: 20220920@Sol
	DB : DBSIG-bodb02
	Task: Check data - [Redmine: #175881]
*/

USE bodb_Consistency;

GO

DECLARE
	@SiteDBGroupID SMALLINT,
	@TransferLastTransId BIGINT,
	@NewTransferLastTransId BIGINT,
	@BatchSize INT = 1000

BEGIN
	SET NOCOUNT ON

	SELECT TOP(@BatchSize)
		t.TransId
		,t.CustId
		,@SiteDBGroupID AS CustomerSiteGroupId
		,r.SiteDBGroupID AS TicketSiteGroupId
	FROM bodb02.dbo.Transfer t WITH (NOLOCK)
		INNER JOIN bodb02.dbo.Customer c WITH (NOLOCK)
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
		AND s.SiteDBGroupID = @SiteDBGroupID 
		AND 1 = CASE WHEN r.SiteDBGroupID <> @SiteDBGroupID THEN 1 ELSE 0 END
	ORDER BY t.TransId

END
GO