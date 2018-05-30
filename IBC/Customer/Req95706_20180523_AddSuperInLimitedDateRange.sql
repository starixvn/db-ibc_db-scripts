/*
Created: 20180523@Razor
Task: Add super QZ0J [redmine :#95706] in Customer Limite date range
DB: DBAGE/bodb_AGE
*/


USE bodb_Age

INSERT INTO [dbo].Age_CustDateLimit(CustId, MinDate, LimitDays)
SELECT CustId, NULL, 33
FROM [bodb02].[dbo].[custInfo] WITH(NOLOCK)
WHERE username = 'QZ0J' 
AND custid NOT IN(SELECT CustId FROM [bodb_Age].[dbo].[Age_CustDateLimit] WITH(NOLOCK))