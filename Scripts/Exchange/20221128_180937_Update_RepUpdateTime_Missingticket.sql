/*<info serverAlias="DBGRP02L-bodb02"></info>*/
/*
	Created: 20221128@Evan
	DB: DBGRP02L-bodb02
	Task : Tickets of bettype=999 are not replicated from SiteDB to CentralDB (SitegroupId = 2)
	https://nexdev.net/issues/180937
*/
USE [bodb02]

GO
	UPDATE bettrans WITH(ROWLOCK)
	SET RepUpdateTime = SYSDATETIME()
	WHERE TransId = 54986426189611020 
GO


