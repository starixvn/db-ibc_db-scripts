/*<info serverAlias="DBCUST-CUSTDB"></info>*/
Use CUSTDB

/*
Create: 20201029@Sophia
DB : DBCUST.CustDB
Task: Script Update ExtraPT for CN88 [Redmine: #144284]

*/

CREATE TABLE #SuperList (ID INT IDENTITY (1,1), SuperID INT, GroupName VARCHAR(50)) 
DECLARE @Max INT = 0, @i INT= 1, @SuperID INT, @GroupName VARCHAR(50), @ExtraPTSetting VARCHAR(2000), @Rate INT = 5
DECLARE @P6 INT 
DECLARE @P7 NVARCHAR(1000) 


INSERT INTO #SuperList (SuperID, GroupName)
SELECT DISTINCT SuperID, GroupName 
FROM Acc_GroupExtraPTSetting WITH (NOLOCK)
WHERE ISNULL(UplineID, '') <> ''
AND GETDATE() BETWEEN FromDate AND ToDate 
AND GroupName LIKE 'CN88_3%'    ---- find group which has SB = 3%


SELECT @Max = MAX(ID) FROM #SuperList 

WHILE @i <= @Max
BEGIN 

	SELECT @SuperID = SuperID, @GroupName = GroupName, @Rate = RIGHT(@GroupName, 1) FROM #SuperList WHERE ID = @i
	
	SELECT @ExtraPTSetting = '<ROOT><ExtraPT ProductId="1" ExtraPT="0.05" /><ExtraPT ProductId="3" ExtraPT="0.0'+ CONVERT(CHAR(1),@Rate)+'" /></ROOT>'

	EXEC CS_GroupExtraPT_Upd 
		@CustID = @SuperID,
		@ExtraPTSetting = @ExtraPTSetting,
		@EffectiveDate = '2020-11-02',
		@UserID=10278938,  --- StrarixIT
		@IP='',
		@ErrCode=@p6 OUTPUT,
		@ErrMsg=@p7 OUTPUT
	
	SELECT @SuperID, @Rate, @GroupName, @ExtraPTSetting, @P6, @P7
	  
	SELECT @i = @i +1
END


DROP TABLE  #SuperList 

GO