
/*
 Created: 20160905Winnie
 Task : ColossusBet
 DB: DBCUST/CUSTDB
*/


INSERT INTO AgentCommRate
           ([CustID]
           ,[SportType]
           ,[BetType]
           ,[CommRate])
SELECT DISTINCT custid,204,18001,0.1215 FROM custInfo WITH(NOLOCK) WHERE srecommend IN(
select Custid from Dep_CustSuper WITH(NOLOCK)
where site in ('spondemo','12bet'))
AND roleid IN(2,3,4)
UNION ALL
SELECT DISTINCT custid,204,18002,0.45 FROM custInfo WITH(NOLOCK) WHERE srecommend IN(
select Custid from Dep_CustSuper WITH(NOLOCK)
where site in ('spondemo','12bet'))
AND roleid IN(2,3,4)

INSERT INTO [CustDB].[dbo].[CustCommRate]
           ([CustId]
           ,[Sporttype]
           ,[Bettype]
           ,[sdiscount]
           ,[adiscount]
           ,[discount]
           ,[playerdiscount])    
SELECT DISTINCT a.custid,204,18001,0.1215,0.1215,0.1215,0 FROM custInfo a WITH(NOLOCK) 
WHERE a.srecommend IN(
select Custid from Dep_CustSuper WITH(NOLOCK)
where site in ('spondemo','12bet'))
AND a.roleid =1
UNION ALL
SELECT DISTINCT a.custid,204,18002,0.45,0.45,0.45,0 FROM custInfo a WITH(NOLOCK) 
WHERE a.srecommend IN(
select Custid from Dep_CustSuper WITH(NOLOCK)
where site in ('spondemo','12bet'))
AND a.roleid =1
