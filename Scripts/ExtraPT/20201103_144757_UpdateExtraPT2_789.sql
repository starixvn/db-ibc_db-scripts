/*<info serverAlias="DBCUST-CUSTDB"></info>*/
Use CUSTDB

/*
Create: 20201103@Sophia
DB : DBCUST.CustDB
Task: Script Update ExtraPT2 for 789 [Redmine: #144757]

*/

 DECLARE 
		@GroupId INT, 
		@GroupName VARCHAR(50), 
		@ProductID INT = 1 ,  
		@EffectiveDate DATETIME = '2020-11-23', 
		@EndDate DATETIME ='9999-12-31', 
		@ExtraPT DECIMAL(9,8) = 0.04,
		@i INT = 1 ,
		@Max INT

 ---- #1. End of Old Data with  @EffectiveDate - 1
----------1.1. Acc_GroupExtraPT2_Product 
UPDATE  Acc_GroupExtraPT2_Product
SET		ToDate = DATEADD(DAY, -1, @EffectiveDate) 
WHERE	GroupName IN ('ACCUT','ACCYEN789', 'ACCYEN889' , 'ACCUUS', 'ACCTEST') 
		AND  CONVERT(DATE, GetDate()) BETWEEN FromDate AND Todate
		AND ProductID = 1
		AND ExtraPT = 0.015
		AND ToDate = @EndDate

---------1.2. Acc_GroupExtraPT2Setting
UPDATE  Acc_GroupExtraPT2Setting
SET		ToDate = DATEADD(DAY, -1, @EffectiveDate) 
WHERE	GroupName IN ('ACCUT','ACCYEN789', 'ACCYEN889' , 'ACCUUS', 'ACCTEST') 
		AND  CONVERT(DATE, GetDate()) BETWEEN FromDate AND Todate
		AND ProductID = 1
		AND ExtraPT = 0.015
		AND ToDate = @EndDate

---- #2. Insert New Setting
/*
15	ACCYEN789
16	ACCYEN889
19	ACCUT
44	ACCUUS
67	ACCTEST
*/

CREATE TABLE #Group (ID INT IDENTITY(1,1), GroupID INT, GroupName VARCHAR(50))
INSERT INTO #Group (GroupID, GroupName)
SELECT GroupID, GroupName
FROM DBACC.bodb_ACC.dbo.Acc_DWLList_ExtraPT WITH(NOLOCK) 
WHERE GroupName IN ('ACCUT','ACCYEN789', 'ACCYEN889' , 'ACCUUS', 'ACCTEST') 

SELECT @Max = MAX(ID) FROM #Group

WHILE @i <= @Max
BEGIN 
	--------- 2.1 Acc_GroupExtraPT2_Product
	SELECT 	@GroupId = GroupId, @GroupName = GroupName 
	FROM 	#Group WHERE ID = @i

	INSERT INTO dbo.Acc_GroupExtraPT2_Product (GroupId, GroupName, ProductID, Sporttype, SubProduct, FromDate, ToDate, ExtraPT)
	SELECT @GroupId, @GroupName, @ProductID, Sporttype, SubProduct, @EffectiveDate, @EndDate, @ExtraPT
	FROM (
		SELECT  0 AS Sporttype, ''				AS SubProduct UNION ALL
		SELECT  0 AS Sporttype, 'MG-SuperLive'	AS SubProduct UNION ALL
		SELECT  0 AS Sporttype, 'Bet Builder'	AS SubProduct UNION ALL
		SELECT 44 AS Sporttype, ''				AS SubProduct
	) AS A
      
	
	--------- 2.2 Acc_GroupExtraPT2Setting 
	BEGIN
		;WITH  CurrentSuper AS (
			SELECT SuperId 
			FROM dbo.Acc_GroupExtraPT2Setting WITH(NOLOCK)
			WHERE GroupId = @GroupId
				AND ToDate = DATEADD(DAY, -1, @EffectiveDate) 		
			GROUP BY SuperId
		)		
		INSERT INTO dbo.Acc_GroupExtraPT2Setting (SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT, FromDate, ToDate)
		SELECT cs.SuperId, @GroupId, @GroupName, @ProductId, A.Sporttype, A.SubProduct, @ExtraPT, @EffectiveDate, @EndDate		
		FROM CurrentSuper cs
			CROSS APPLY (
				SELECT  0 AS Sporttype, ''				AS SubProduct UNION ALL
				SELECT  0 AS Sporttype, 'MG-SuperLive'	AS SubProduct UNION ALL
				SELECT  0 AS Sporttype, 'Bet Builder'	AS SubProduct UNION ALL
				SELECT 44 AS Sporttype, ''				AS SubProduct
				) AS A		 
	END
	
	SELECT @i = @i + 1

END 
	
	
	


select * from Acc_GroupExtraPT2Setting (NOLOCK)  where GroupName  IN ('ACCUT','ACCYEN789', 'ACCYEN889' , 'ACCUUS', 'ACCTEST') 
select * from Acc_GroupExtraPT2_product (NOLOCK) where GroupName IN ('ACCUT','ACCYEN789', 'ACCYEN889', 'ACCUUS', 'ACCTEST' ) 
 