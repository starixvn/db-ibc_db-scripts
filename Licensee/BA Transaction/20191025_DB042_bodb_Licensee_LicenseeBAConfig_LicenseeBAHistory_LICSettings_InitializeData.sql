USE bodb_Licensee
GO

/*
	Created: 20191025@Percy
	DB: DB042.bodb_Licensee
	Task: Initialize data for LicenseeBAHistory, LicenseeBAConfig and LICSettings tables
*/


-- LicenseeBAHistory (25,283 rows)
SET IDENTITY_INSERT [dbo].[LicenseeBAHistory] ON
INSERT INTO [dbo].[LicenseeBAHistory] ([ID],[LicenseeID],[CustID],[OnDate],[OffDate],[OnBy],[OffBy],[GroupComm],[1x2Comm],[OtherComm],[Status],[Ugroup])
SELECT [ID],[LicenseeID],[CustID],[OnDate],[OffDate],[OnBy],[OffBy],[GroupComm],[1x2Comm],[OtherComm],[Status],[Ugroup]
FROM DBAGE.bodb_Licensee.dbo.LicenseeBAHistory WITH (NOLOCK)
SET IDENTITY_INSERT [dbo].[LicenseeBAHistory] OFF

GO



-- LicenseeBAConfig (387 rows)
INSERT INTO [dbo].[LicenseeBAConfig]([LicenseeID],[1x2Comm],[OtherComm],[EnableBA],[ModifyBy],[ModifyDate],[groupa],[groupb],[groupc],[groupd])
SELECT [LicenseeID],[1x2Comm],[OtherComm],[EnableBA],[ModifyBy],[ModifyDate],[groupa],[groupb],[groupc],[groupd]
FROM DBAGE.bodb_Licensee.dbo.LicenseeBAConfig WITH (NOLOCK)

GO



-- LICSettings
SET IDENTITY_INSERT [dbo].[LICSettings] ON
INSERT INTO [dbo].[LICSettings] ([VID],[VName],[VValue],[VValue2])
SELECT [VID],[VName],[VValue],[VValue2]
FROM DBAGE.bodb_Licensee.dbo.LICSettings WITH (NOLOCK)
SET IDENTITY_INSERT [dbo].[LICSettings] OFF