USE [bodb_Summary]
GO

ALTER PROCEDURE [dbo].[DBA_CopyData_SumWL_SumWLOld]
	@winlostdate	SMALLDATETIME,
	@srecommend		INT,
	@sporttype		INT = NULL
AS

/*
	Created by Percy
	Date: 2017-06-28
	DB: DBSUM.bodb_Summary
	Task: Balance up process

	Revisions:
		- 20170628@Percy: Create new

	Param's Explanation:
*/

BEGIN
	SET NOCOUNT ON

	DELETE dbo.sum_winloss_old WITH(ROWLOCK, UPDLOCK)
	WHERE srecommend = @srecommend AND winlostdate = @winlostdate AND (@sporttype IS NULL OR sporttype = @sporttype)

	INSERT INTO dbo.sum_winloss_old
	(
		winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
		turnover, winlost, awinlost, mwinlost, swinlost,
		playercomm, comm, acomm, scomm, betcount, grosscomm,
		sporttype, bettype, netTurnover, TunroverNoDraw
	)
	SELECT
		winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
		turnover, winlost, awinlost, mwinlost, swinlost,
		playercomm, comm, acomm, scomm, betcount, grosscomm,
		sporttype, bettype, netTurnover, TunroverNoDraw
	FROM bodb02.dbo.sum_winloss WITH(NOLOCK)
	WHERE srecommend = @srecommend AND winlostdate = @winlostdate
		AND (
			@sporttype IS NULL
			OR sporttype = @sporttype
		)

	IF @@ROWCOUNT = 0 -- may be replication
	BEGIN
		INSERT INTO dbo.sum_winloss_old
		(
			winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
			turnover, winlost, awinlost, mwinlost, swinlost,
			playercomm, comm, acomm, scomm, betcount, grosscomm,
			sporttype, bettype, netTurnover, TunroverNoDraw
		)
		SELECT
			winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
			turnover, winlost, awinlost, mwinlost, swinlost,
			playercomm, comm, acomm, scomm, betcount, grosscomm,
			sporttype, bettype, netTurnover, TunroverNoDraw
		FROM DBTXN.bodb02.dbo.sum_winloss WITH(NOLOCK)
		WHERE srecommend = @srecommend AND winlostdate = @winlostdate
			AND (
				@sporttype IS NULL
				OR sporttype = @sporttype
			)
	END
END