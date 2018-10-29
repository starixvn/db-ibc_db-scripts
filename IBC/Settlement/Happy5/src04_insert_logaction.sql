/*
	Created: Vicky
	Task: create execrep fn
	DB: DBTXN/bodb02, DBACC/bodb02, DBAGE/bodb02, DBEXT/bodb02, DB042/bodb02
	Date: 20180912
	
*/
USE [bodb_CustomerLog]
GO

DELETE LogAction WHERE ActionID IN (81000,81001)


INSERT INTO LogAction(ActionID,ActionTypeID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameIT,ActionNameTH,ActionNameKO,XsltContent,IsInternal,ActionNameVI)
VALUES 
 (81000,NULL,'NAP_Admin_Settlement_s164','Calculate','Calculate',NULL,'Calculate','Calculate','Calculate','Calculate',NULL,0,'Calculate')
,(81001,NULL,'NAP_Admin_Settlement_s164','Refund','Refund',NULL,'Refund','Refund','Refund','Refund',NULL,0,'Refund')
