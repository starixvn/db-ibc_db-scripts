-- DB053, DB052 -- bodb_PlaytechCS
DELETE dbo.Product3rd_ImportQueue WITH (ROWLOCK, UPDLOCK)
WHERE QueueId >= 466284
