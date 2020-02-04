USE bodb_PlaytechCS
GO

/*
	Created: 20200204@Percy
	DB: DB053.bodb_PlaytechCS
*/

-- Manually delete API data due to import wrong server

-- 36 row(s) affected
DELETE dbo.Product3rd_ImportQueue WITH (ROWLOCK, UPDLOCK)
WHERE QueueID >= 521790
GO