/*
Created: 20180522@Razor
Task: Remove super QZ1Y [redmine :#95553] in Customer Limite date range
DB: DBAGE/bodb_AGE
*/


USE bodb_Age
DELETE FROM [dbo].Age_CustDateLimit WHERE CustID IN (SELECT CustId FROM [bodb02].[dbo].[custInfo] WITH(NOLOCK) WHERE username = 'QZ1Y')
