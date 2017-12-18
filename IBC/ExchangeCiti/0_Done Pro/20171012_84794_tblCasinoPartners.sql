Use bodb_report
GO 

/*

Creator: Sophia
Date: 20171017
DB: DBRPT.bodb_report
Description: Add sporttype & bettype for CitiBet [redmine :#84794]

Product name: Exchange
Product ID: 31
Sport name: Exchange
Sport type ID: 221
Transfer bet type: 22030: DTRABX (Exchange Transfer); 22031:DCANBX (Exchange Cancel Transfer)
 */

 

INSERT INTO tblCasinoPartners (PartnerId, PartnerName, TransferId, CancelTransferId)
VALUES (12, 'Exchange',22030, 22031 )