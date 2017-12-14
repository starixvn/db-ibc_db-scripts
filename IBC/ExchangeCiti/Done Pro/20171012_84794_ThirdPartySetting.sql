use bodb02

/*


Creator: Sophia
Date: 20171017
DB: DBTXN.bodb02
Description: Add [ThirdPartySetting] for CitiBet [redmine :#84794]

Product name: Exchange
Product ID: 31
Sport name: Exchange
Sport type ID: 221
Transfer bet type: 22030: DTRABX (Exchange Transfer); 22031:DCANBX (Exchange Cancel Transfer)

*/



INSERT INTO [dbo].[ThirdPartySetting](ThirdPartyType, ThirdPartyName, TransferBettype, CancelBettype)
SELECT 12, 'Exchange', 22030, 22031