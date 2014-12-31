USE [bodb_TGRS]
GO

SET NOCOUNT ON 

DECLARE @fromdate datetime,@todate datetime

SELECT @fromdate ='2014-01-01 00:00:00'
	,@todate =CONVERT(NVARCHAR(20),GETDATE(),101)

IF OBJECT_ID('tempdb..#Trader') IS NOT NULL    DROP TABLE #Trader
IF OBJECT_ID('tempdb..#tmpTrader') IS NOT NULL    DROP TABLE #tmpTrader

SELECT DISTINCT OperatorID [CustId] 
INTO #tmpTrader
FROM bodb_archive.[dbo].[Dot_Admin_Assignment_Operator_bk] op WITH(nolock) 
LEFT JOIN  DBDW2.bodb_Staging.dbo.match m WITH (NOLOCK)
	ON op.matchid = m.matchid	
WHERE OperatorType <3 AND m.sporttype = 1
	AND m.EventDate BETWEEN @fromdate AND @todate


INSERT INTO #tmpTrader
SELECT DISTINCT OperatorID [CustId] 
FROM [bodb02].[dbo].[Dot_Admin_Assignment_Operator] op WITH(NOLOCK) 
LEFT JOIN [bodb02].[dbo].match m WITH(NOLOCK) ON op.matchid = m.matchid	
LEFT JOIN #tmpTrader td ON op.OperatorID = td.CustId
WHERE OperatorType <3 AND m.sporttype = 1 AND td.CustId IS NULL
	AND m.EventDate BETWEEN @fromdate AND @todate

SELECT td.[CustId]
	  ,ci.[Username]
      ,'-'  [EmployeeId]
      ,1 [TeamId]
      ,10 [Grade]
      ,ISNULL(ci.[creatdate],'2011-01-01') [CreatedDate]
      ,8 AS [CreatedBy]
      ,NULL [ModifiedDate]
      ,NULL [ModifiedBy]
      ,0 [Disabled]
      ,CONVERT(NVARCHAR(10),ISNULL(ci.[creatdate],'2011-01-01'),20) [TeamEffectiveDate]
      ,CONVERT(NVARCHAR(10),ISNULL(ci.[creatdate],'2011-01-01'),20) [GradeEffectiveDate]
INTO #Trader
  FROM #tmpTrader td
  INNER JOIN  bodb02.dbo.Customer ci WITH (NOLOCK)			ON td.CustId = ci.custid 
  LEFT JOIN  [bodb_TGRS].dbo.[Trader] tr_h WITH (NOLOCK) 	ON tr_h.CustId = ci.custid   
  WHERE tr_h.CustId IS NULL 		
 
 IF @@ROWCOUNT = 0
	BEGIN
		IF OBJECT_ID('tempdb..#Trader') IS NOT NULL    DROP TABLE #Trader
		RETURN
	END

INSERT INTO [dbo].[Trader]
           ([CustId]
           ,[Username]
           ,[EmployeeId]
           ,[TeamId]
           ,[Grade]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[Disabled]
           ,[TeamEffectiveDate]
           ,[GradeEffectiveDate])
SELECT [CustId]
           ,[Username]
           ,[EmployeeId]
           ,[TeamId]
           ,[Grade]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[Disabled]
           ,[TeamEffectiveDate]
           ,[GradeEffectiveDate] 
FROM #Trader

INSERT INTO [bodb_TGRS].[dbo].[TraderGrade_History]
           ([CustId]
           ,[Grade]
           ,[BeginDate]
           ,[EndDate])
	SELECT td.[CustId]
		  ,td.[Grade] [Grade]
		  ,td.[GradeEffectiveDate] [BeginDate]
		  ,NULL [EndDate]
	FROM #Trader td
		LEFT JOIN  [bodb_TGRS].dbo.[TraderGrade_History] trg_h WITH (NOLOCK) 	ON trg_h.CustId = td.custid 
	  WHERE trg_h.CustId IS NULL

INSERT INTO [bodb_TGRS].[dbo].[TraderTeam_History]
           ([CustId]
           ,[TeamId]
           ,[BeginDate]
           ,[EndDate])
	SELECT td.[CustId]
		  ,td.TeamId
		  ,td.[TeamEffectiveDate] [BeginDate]
		  ,NULL [EndDate]
	  FROM #Trader td
	  LEFT JOIN  [bodb_TGRS].dbo.[TraderTeam_History] trt_h WITH (NOLOCK) 		ON trt_h.CustId = td.custid
	  WHERE trt_h.CustId IS NULL 
 
--IF OBJECT_ID('tempdb..#Trader') IS NOT NULL    DROP TABLE #Trader
 