/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20240821@Kelvin
	DB: DBLIC-bodb_3rdProduct
	Task: LAP - Exchange - Support Running ticket [RedmineID: #208108]		
*/


USE [bodb_3rdProduct]
GO

ALTER TABLE Bettrans_Exchange
ADD CustID INT NULL

CREATE NONCLUSTERED INDEX [IX_CustId] ON [dbo].[Bettrans_Exchange]
(
	[CustID] ASC
)WITH (ONLINE = ON, DROP_EXISTING = ON) ON [3rdProduct_Data]
GO