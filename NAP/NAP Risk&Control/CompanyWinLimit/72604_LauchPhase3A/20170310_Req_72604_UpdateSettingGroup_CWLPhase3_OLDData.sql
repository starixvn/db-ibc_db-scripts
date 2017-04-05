/*
	Created: 20170324@Helen
	Task: CWL - phase 3a
	DB: DBCUST/CUSTDB
*/
USE CustDB

GO
UPDATE PSD
	SET GroupID = GGS.GroupID
FROM WinLimit_CustGameMonitoring PSD WITH (ROWLOCK,UPDLOCK)
	INNER JOIN Winlimit_GameGroupSetting GGS WITH (NOLOCK) ON PSD.BettypeID = GGS.BetTypeID
WHERE PSD.GroupID IS NULL	

UPDATE PSD
	SET GroupID = GGS.GroupID
FROM WinLimit_CustGameMonitoring_History PSD WITH (ROWLOCK,UPDLOCK)
	INNER JOIN Winlimit_GameGroupSetting GGS WITH (NOLOCK) ON PSD.BettypeID = GGS.BetTypeID
WHERE PSD.GroupID IS NULL	

GO