USE [bodb_Report]
GO

ALTER PROCEDURE [dbo].[DBA_RptStatement_Old]
	@Winlostdate	SMALLDATETIME,
	@Custid			INT,
	@recommend		INT,
	@mrecommend		INT,
	@srecommend		INT
AS

/*
	Created by Percy
	Date: 2017-06-28
	DB: DBTXN.bodb02
	Task: Insert into rpt Statement Old

	Revisions:
		- 20170628@Percy: Create new

	Param's Explanation:
*/

BEGIN

	SET NOCOUNT ON
		
	IF EXISTS(SELECT TOP 1 * FROM rptStatement_Old WITH(NOLOCK) WHERE winlostdate = @Winlostdate AND custid IN (@Custid, @recommend, @mrecommend, @srecommend))
	BEGIN
		DELETE dbo.rptStatement_Old WITH (ROWLOCK, UPDLOCK) WHERE  winlostdate = @Winlostdate AND custid IN (@Custid, @recommend, @mrecommend, @srecommend)
	END

	INSERT INTO dbo.rptStatement_Old
	(
		winlostdate
		,custid
		,openingbalance
		,voidamt
		,turnover
		,netturnover
		,transferamt
		,winlost
		,comm
		,closingbalance
		,GrandPrize
	)
	SELECT 
		winlostdate
		,custid
		,openingbalance
		,voidamt
		,turnover
		,netturnover
		,transferamt
		,winlost
		,comm
		,closingbalance
		,GrandPrize
	FROM 
		dbo.rptStatement WITH(NOLOCK)
	WHERE
		winlostdate = @winlostdate
		AND custid IN (@Custid, @recommend, @mrecommend, @srecommend)

	DELETE dbo.rptStatement WITH(ROWLOCK, UPDLOCK)
	WHERE
		winlostdate = @winlostdate
		AND custid IN (@Custid, @recommend, @mrecommend, @srecommend)
END
