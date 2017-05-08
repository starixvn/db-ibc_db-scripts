/*
	Created: 20170504@Helen
	Task: Keno - Missing PT setting for some accounts - [Redmine: 76020]

*/

CREATE TABLE #List2 (CustID INT PRIMARY KEY,RoleID INT, isfinished bit default(0))
INSERT INTO #List2 (CustID,roleID)
VALUES 	(20550129,2)

UPDATE CS
	SET apositiontaking = 0.7
FROM CustSettingGame CS WITH (ROWLOCK,UPDLOCK)
WHERE CS.CustID = 20550129 AND Sporttype = 202 

-- 2. Adjust PT for members under these agents

-- Agent correct members
DECLARE @recommend INT
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #List2
	SET isfinished = 1
		,@recommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1501

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1503

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1504

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1505

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1507

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1508

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1509

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1511

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1513
	
	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1514
	
	--EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1515
	
	--EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1516
	
END	

