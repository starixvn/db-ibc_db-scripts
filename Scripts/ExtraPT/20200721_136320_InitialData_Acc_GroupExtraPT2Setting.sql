/*<info serverAlias="DBCUST-CUSTDB" step="2"></info>*/
/*
	Create: 20200721@Sol
	DB : DBCUST.CustDB
	Task: Initial data for table Acc_GroupExtraPT2Setting [redmine: #136320]
*/

USE [CustDB]

GO 

INSERT INTO Acc_GroupExtraPT2Setting (SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT, FromDate, ToDate)
SELECT ageps.SuperId, ageps.GroupId, ageps.GroupName, ageps.ProductId, ageps.Sporttype, ageps.SubProduct, 0.015 AS ExtraPT, '2020-08-01 00:00:00.000' AS FromDate,
		ageps.ToDate
FROM Acc_GroupExtraPTSetting ageps WITH(NOLOCK)
WHERE ageps.GroupName IN ('ACCYEN789', 'ACCYEN889', 'ACCUT')
	AND CAST(GETDATE() AS DATE) BETWEEN ageps.FromDate AND ageps.ToDate 
	AND ageps.ProductID = 1

GO