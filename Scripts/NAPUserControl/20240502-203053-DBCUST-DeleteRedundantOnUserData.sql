/*<info serverAlias="DBCUST-NAP_UserControl" isFunction="0" isNested=""></info>*/
/*
	Created: 20240502@Kos
	DB: DBCUST.NAP_UserControl
	Task: Delete reduntdant OnUser data [Redmine: #203053]
*/

USE NAP_UserControl

SET NOCOUNT ON

WHILE 1 = 1
BEGIN
	DELETE TOP(3000) FROM NAP_OnUser WITH (ROWLOCK)
	WHERE ReloadTime < DATEADD(DAY, -1, CURRENT_TIMESTAMP)
		OR IsKickedOut = 1

	IF @@ROWCOUNT = 0
		BREAK
END