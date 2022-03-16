/*<info serverAlias="DBTRANS-bodb02"></info>*/
/*
	Create: 20211230@Sol
	DB : DBTRANS-bodb02
	Task: copy data to new table transfer and transferinfo - [Redmine: #162264]
*/

USE bodb02;

GO  

--- insert missing row 
DECLARE @TransIdList VARCHAR(MAX) = '108711260621'
EXEC bodb02.dbo.Transfer_ExecRep_01 @TransIdList = @TransIdList, @IsDelete = 0

GO

--- update transfer winlost due to bettrans update
UPDATE t
	SET Winlost = b.winlost
		,Actual_Stake = b.actual_stake
		,Stake = b.stake
		,Comm = b.comm
		,AComm = b.acomm
		,SComm = b.scomm
FROM dbo.Transfer t
	INNER JOIN dbo.bettrans b 
		ON t.TransId = b.transid
WHERE t.TransId = 108711260251