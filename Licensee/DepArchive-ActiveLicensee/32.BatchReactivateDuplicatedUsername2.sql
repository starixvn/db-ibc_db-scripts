/*
	Task: Reactivate dormant members with duplicated [username2] - https://nexdev.net/issues/109761
	Creator: Dominic@20190306
	Run at: CustDB@DBCUST
*/
USE CustDB

CREATE TABLE #CustID(CustID INT, IsExecuted BIT)

--12 rows
INSERT INTO #CustID(CustID,IsExecuted) 
SELECT CustID,0
FROM [dbo].[Dep_Customer_Archived] (NOLOCK)
WHERE Username2 IN (
	'Mayayule$yang1981my',
	'Mayayule$zhengsheng9dc',
	'Mayayule$zwl3088qx',
	'Mayayule$aa441188yly',
	'Mayayule$huangjinmayly',
	'Mayayule$L1357410066ysh',
	'Mayayule$jl18682071598lb',
	'Mayayule$hyc121my',
	'Mayayule$aA15817660817yly',
	'Mayayule$zhw1234569dc',
	'Mayayule$qtd2523yly',
	'Mayayule$BBQ123yly'
)
AND status='completed'

CREATE UNIQUE CLUSTERED INDEX IX_Cust ON #CustID(CustID)

DECLARE @CustID INT

WHILE EXISTS(SELECT 1 FROM #CustID WHERE IsExecuted=0)
BEGIN
	UPDATE TOP(1) t
	SET IsExecuted=1
		,@CustID=CustID
	FROM #CustID t
	WHERE IsExecuted=0

	IF NOT EXISTS(SELECT 1 FROM Customer (NOLOCK) WHERE CustID=@CustID)
	BEGIN
		EXEC [Dot_Dep_Customer_Archive_ReactiveCustomer] @CustID  = @CustID, @CheckUniqueUsername2 = 0
		WAITFOR DELAY '00:00:00.030'
	END
	
END

DROP TABLE #CustID
 
