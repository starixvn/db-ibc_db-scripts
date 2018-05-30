/*
Created: 20180523@Razor
Task: Remove super QZ0J [redmine :#95706] in Customer Limite date range
DB: DBAGE/bodb_AGE
*/


USE bodb_Age
DELETE FROM [dbo].Age_CustDateLimit WHERE CustID IN (SELECT CustId FROM [bodb02].[dbo].[custInfo] WITH(NOLOCK) WHERE username = 'QZ0J')
