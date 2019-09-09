/*	
	Created: 20190909@Sol
	Task: check existing of running tickets of bettype 22 - [Redmine:#115232]
	DB: DBTXN/bodb02
*/

USE bodb02;

GO 

SELECT COUNT(*) 
FROM bettrans b WITH(NOLOCK)
	INNER JOIN match m WITH(NOLOCK)
		on b.matchid = m.matchid
WHERE m.eventstatus = 'running'
		ANd bettype = 22 
		AND [statusId] = 0 
		ANd winlostdate >= Dateadd(d, -1, Getdate())

GO 

SELECT COUNT(*) 
FROM bettransm b WITH(NOLOCK)
	INNER JOIN match m WITH(NOLOCK)
		on b.matchid = m.matchid
WHERE m.eventstatus = 'running'
		ANd bettype = 22 
		AND [statusId] = 0 

GO