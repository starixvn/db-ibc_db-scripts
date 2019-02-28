EXEC Age_Rpt_PlayForFun_Agent
	@CustId = 1176083,
	@FromDate = '2017-08-30',
	@ToDate = '2017-08-30',
	@ProductId = 6,
	@StatusId = 2

SELECT top 50 *
FROM dbo.custInfo WITH(NOLOCK)
WHERE custid = 3230192
	AND roleid = 1
	AND DisableCasino = 1



	-- SuperTest1201001 -- 3230192 -- 1176070	3230178	3230184
	-- SUPERTEST10101WUK -- 13062644 -- 1176070	1530099	6912699
INSERT INTO dbo.BettransPF (custid, winlostdate, gameID, productID, srecommend, mrecommend, recommend, stake, status, statusid, winlost, username, betcount, ReferenceID)
VALUES
	(1176092, '2017-08-30', 2105, 208, 1176070, 1176083, 1176086, 100, 'WON', 112, 490, 'member01', 1, 12345),
	(1176092, '2017-08-30', 2204, 209, 1176070, 1176083, 1176086, 200, 'LOSE', 113, 0, 'member01', 2, 12345),
	(1176092, '2017-08-30', 2302, 210, 1176070, 1176083, 1176086, 500, 'DRAW', 111, 500, 'member01', 4, 12345)