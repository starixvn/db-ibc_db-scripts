 /*
Created: Helen
Date: 2015-08-31
Task: Copy MO settings for dummy account - [Redmine: #41264]
DB: DBCUST.CustDB
*/

 INSERT INTO AgentCommRate (CustId,Sporttype,Bettype,CommRate)
 SELECT custid,1,301,0.01
 FROM Acc_CustDirect WITH (NOLOCK)
 WHERE roleid = 4
 
 INSERT INTO AgentCommRate (CustId,Sporttype,Bettype,CommRate)
 SELECT custid,1,301,0.01
 FROM Acc_CustDirect WITH (NOLOCK)
 WHERE roleid = 3
 
 INSERT INTO AgentCommRate (CustId,Sporttype,Bettype,CommRate)
 SELECT custid,1,301,0.01
 FROM Acc_CustDirect WITH (NOLOCK)
 WHERE roleid = 2
 
 