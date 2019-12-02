/*
	Created by: Kos
	Date: 20191202
	Task: GRANT PERMISSION to support In-House DB replication
	DB: DBOST.bodb02
*/

USE [bodb02]
GO

GRANT	SELECT	ON	outright	TO	bodbDownlineNet
GRANT	SELECT	ON	outright	TO	bodbDownlineNetView

GRANT	EXECUTE	ON	f_CheckSPVersion	TO	bodbDownlineNet
GRANT	EXECUTE	ON	f_CheckSPVersion	TO	bodbDownlineNetView