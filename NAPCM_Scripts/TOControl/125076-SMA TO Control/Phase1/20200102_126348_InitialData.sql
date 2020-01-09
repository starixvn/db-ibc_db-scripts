/*
    Created: 20200108@Malcolm
	Task: Separate setting and notification into Live/Non-Live and bettypes - [Redmine: #126348]
	DB: DBCUST/CustDB
*/
USE CustDB
GO
INSERT INTO TOControl_Profile ([ProfileName],Sporttype)
VALUES ('Live - HDP', 1)
,('Live - OU', 1)
,('Live - 1H HDP', 1)
,('Live - 1H OU', 1)
,('Live - Others', 1)
,('Non Live - HDP', 1)
,('Non Live - OU', 1)
,('Non Live - 1H HDP', 1)
,('Non Live - 1H OU', 1)
,('Non Live - Others', 1)
,('Live - HDP&ML', 99)
,('Live - OU', 99)
,('Live - 1H HDP&ML', 99)
,('Live - 1H OU', 99)
,('Live - Others', 99)
,('Non Live - HDP&ML', 99)
,('Non Live - OU', 99)
,('Non Live - 1H HDP&ML', 99)
,('Non Live - 1H OU', 99)
,('Non Live - Others', 99)
GO

