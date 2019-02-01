-- run on DB052

/*
	Created: 20190201@Percy
	DB: DB052, DB053, DB054
	Task: Manually regen data for GD on 2019 Jan 02
	RedmineID: #108659
*/

DELETE bodb_PlaytechCS.dbo.Product3rd_ImportQueue WITH (ROWLOCK)
WHERE QueueID >= 347482