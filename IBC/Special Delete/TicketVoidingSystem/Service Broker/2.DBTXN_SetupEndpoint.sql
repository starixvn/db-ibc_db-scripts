/*
	Created:20190128@Kathy
	DB: DBTXN/master
	Task: Ticket Voiding System - Setup service broker on DBTXN [Redmine:#90155]
*/
USE master

CREATE MASTER KEY ENCRYPTION BY PASSWORD = N'!i@b#ssb#mlogin$9)';
GO


--Creating certificate that will be used for encrypting messages. 
CREATE CERTIFICATE [SSBS_DBTXN_Cert]
       WITH SUBJECT = N'Certificate For DBTXN',
       EXPIRY_DATE = N'12/31/2080';
GO

BACKUP CERTIFICATE [SSBS_DBTXN_Cert]
       TO FILE = N'D:\SSBSQLCertificates\SSBS_DBTXN_Cert.cer';
GO

CREATE ENDPOINT [EndPoint_SSB_DBTXN] 
	AUTHORIZATION [sa]
	STATE=STARTED
	AS TCP (LISTENER_PORT = 4741, LISTENER_IP = ALL)
	FOR SERVICE_BROKER (MESSAGE_FORWARDING = DISABLED
, MESSAGE_FORWARD_SIZE = 10
, AUTHENTICATION = CERTIFICATE [SSBS_DBTXN_Cert]
, ENCRYPTION = REQUIRED ALGORITHM RC4)
GO


CREATE LOGIN dba_cert_User WITH PASSWORD = N'!i@b#ssb#login$8)'
CREATE USER dba_cert_User FOR LOGIN dba_cert_User
GO


GRANT CONNECT ON ENDPOINT::[EndPoint_SSB_DBTXN] TO dba_cert_User
GO

-- Copy cetificate from DBLOG, resotring target certificates so that message received from target can be decrypted
CREATE CERTIFICATE [SSBS_DBLOG_Cert] 
   AUTHORIZATION dba_cert_User
   FROM FILE = N'D:\SSBSQLCertificates\SSBS_LOG_Cert.cer'
GO

