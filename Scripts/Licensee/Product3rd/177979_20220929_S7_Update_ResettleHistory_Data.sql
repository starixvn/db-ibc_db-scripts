/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20220919@Sol
	DB: DBLIC-bodb_LicenseeReport
	Task: update data - [Redmine: #177979]
*/

--## RUN IN DB052 ONLY ##--

USE bodb_PlaytechCS

GO 

--- update data in Aug 
--- affected rows = 11 
DECLARE @currTime DATETIME = GETDATE()
UPDATE Product3rd_ResettledBetHistory WITH (ROWLOCK, UPDLOCK)
	SET Status = 'Completed',
		FinishedTime = @currTime
WHERE ProductID = 31
	AND settleddate >= '2022-08-01'
	AND settleddate < '2022-09-01'
	AND Status = 'waiting'