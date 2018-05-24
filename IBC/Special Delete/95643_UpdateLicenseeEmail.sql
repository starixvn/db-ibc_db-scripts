/*
	Created: Kathy@20180523
	Task: Update email of Licensee to new email address [Redmine:#95643]
	DB: DBACC/bodb_Acc

*/
BEGIN
	SET NOCOUNT ON

	DECLARE @deletedEmail VARCHAR(100)
			,@newEmail VARCHAR(100) 

	DECLARE @tmpEmail TABLE (deletedEmail VARCHAR(100), isFinished BIT DEFAULT(0))

	SET @newEmail = 'lmd@enpine.com'

	INSERT INTO @tmpEmail (deletedEmail)
		VALUES ('licensing@bopingholdings.com'), ('licensing@zelianta.com'), ('licensing@oneworks.com'), ('licensing@onelab.tw')

	WHILE (1 = 1)
	BEGIN
		SELECT TOP 1
				@deletedEmail = deletedEmail
		FROM	@tmpEmail
		WHERE	isFinished = 0

		IF @@ROWCOUNT = 0
		BREAK

		UPDATE	dbo.Acc_MailingList WITH (ROWLOCK, UPDLOCK)
			SET ToList = CASE
							WHEN CHARINDEX(@newEmail, tolist) = 0 THEN REPLACE(tolist, @deletedEmail, @newEmail)
							ELSE REPLACE(Tolist, @deletedEmail, '')
						END
			   ,cclist = CASE
							WHEN CHARINDEX(@newEmail, cclist) = 0 THEN REPLACE(CcList, @deletedEmail, @newEmail)
							ELSE REPLACE(ccList, @deletedEmail, '')
						END
		WHERE	ToList LIKE '%licensing@%'
				OR CcList LIKE '%licensing@%'

		UPDATE	@tmpEmail
			SET isFinished = 1
		WHERE	deletedEmail = @deletedEmail
	END

END

