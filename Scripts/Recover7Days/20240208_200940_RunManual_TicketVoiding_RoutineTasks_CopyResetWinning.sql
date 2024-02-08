/*<info serverAlias="DBACC-bodb02"></info>*/
/*
	Create: 20240208@Sophia
	Task: copy data of reset winning by Run Manual Routine task [Redmine: #200940] 
	DB: DBACC-bodb02
*/ 
 
USE bodb02;
GO

INSERT INTO TRANSFER_BK (
custid,
transdate,
Debit,
Credit,
TransDesc,
winlostdate,
recommend,
mrecommend,
srecommend,
currency,
refno,
creator,
transid,
bettype,
balance)

SELECT 
custid,
transdate,
actual_stake,
winlost,
TransDesc,
winlostdate,
recommend,
mrecommend,
srecommend,
currency,
refno,
creator,
transid,
bettype,
balance 
FROM Transfer WITH (NOLOCK) 
WHERE Bettype IN (21001, 21002)
AND Winlostdate IN ('20240129','20240130','20240131', '20240201')
AND Transdate >= '2024-02-08'
