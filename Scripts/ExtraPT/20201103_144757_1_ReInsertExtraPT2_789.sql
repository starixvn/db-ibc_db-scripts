/*<info serverAlias="DBCUST-CUSTDB" step="0"></info>*/
/*
	Create: 20201105@Sophia
	DB : DBCUST.CustDB
	Task: Initial data for table Acc_GroupExtraPT2Setting who is missing on 23 Aug 2020 [redmine: #144757]
*/

INSERT INTO Acc_GroupExtraPT2Setting (
	SuperId
	,GroupId
	,GroupName
	,ProductId
	,Sporttype
	,SubProduct
	,ExtraPT
	,FromDate
	,ToDate)
SELECT 
	a.SuperId
	,a.GroupId
	,a.GroupName
	,a.ProductId
	,a.Sporttype
	,a.SubProduct
	,a.ExtraPT
	,a.FromDate
	,a.ToDate 
FROM Acc_GroupExtraPTSetting a WITH (NOLOCK) 
LEFT JOIN Acc_GroupExtraPT2Setting a2 WITH (NOLOCK) ON a2.superid = a.superid
WHERE a.GroupName  IN ('ACCUT','ACCYEN789', 'ACCYEN889')
AND CONVERT(DATE,GETDATE()) BETWEEN a.FromDate AND a.ToDate 
AND a.productid = 1
AND a2.SuperId IS NULL