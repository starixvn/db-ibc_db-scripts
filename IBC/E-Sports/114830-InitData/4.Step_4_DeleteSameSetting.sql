/*
	Task: Delete data for accounts having same settings as direct upline's - Redmine: 114830
		Step 1: Delete agent's setting
		Step 2: Delete master's setting
		Step 3: Insert global setting
		Step 4: Delete super's setting
	Creator: Dominic@20190718
	Run at: CustDB@DBCUST 
*/
USE CustDB
GO

	--Step 1: Delete agent's setting
	WHILE (1=1)
	BEGIN
		DELETE TOP (20000)  c
		FROM EsportVR_Temp c
		INNER JOIN EsportVR_Temp m ON c.mrecommend = m.CustID AND m.RoleID = 3
		WHERE c.RoleID=2
			AND c.VRValue_121 = m.VRValue_121
			AND c.VRValue_122 = m.VRValue_122
			AND c.VRValue_123 = m.VRValue_123
			AND c.VRValue_124 = m.VRValue_124
			AND c.VRValue_125 = m.VRValue_125
			AND c.VRValue_126 = m.VRValue_126
			AND c.VRValue_127 = m.VRValue_127
			AND c.VRValue_128 = m.VRValue_128

		IF @@ROWCOUNT < 20000
			BREAK
	END

	--Step 2: Delete master's setting
	WHILE (1=1)
	BEGIN
		DELETE TOP (20000)  c
		FROM EsportVR_Temp c
		INNER JOIN EsportVR_Temp m ON c.srecommend = m.CustID AND m.RoleID = 4
		WHERE c.RoleID=3
			AND c.VRValue_121 = m.VRValue_121
			AND c.VRValue_122 = m.VRValue_122
			AND c.VRValue_123 = m.VRValue_123
			AND c.VRValue_124 = m.VRValue_124
			AND c.VRValue_125 = m.VRValue_125
			AND c.VRValue_126 = m.VRValue_126
			AND c.VRValue_127 = m.VRValue_127
			AND c.VRValue_128 = m.VRValue_128

		IF @@ROWCOUNT < 20000
			BREAK
	END

	--Step 3: Insert global setting
	INSERT INTO EsportVR_Temp(VRValue_121,VRValue_122,VRValue_123,VRValue_124,VRValue_125
							,VRValue_126,VRValue_127,VRValue_128
							,HasSameVR
							,CustID
							,RoleID
					)	
	SELECT VRValue_121,VRValue_122,VRValue_123,VRValue_124,VRValue_125
							,VRValue_126,VRValue_127,VRValue_128
							,HasSameVR
							,0 CustID
							,5 RoleID
	FROM (
		SELECT VRValue_121,VRValue_122,VRValue_123,VRValue_124,VRValue_125,VRValue_126	
					,VRValue_127,VRValue_128, HasSameVR, ROW_NUMBER() OVER(ORDER BY COUNT(1) desc) OrderNo
		FROM EsportVR_Temp
		WHERE RoleID=4
		GROUP BY VRValue_121,VRValue_122,VRValue_123,VRValue_124,VRValue_125,VRValue_126	
					,VRValue_127,VRValue_128,HasSameVR
	) tmp
	WHERE OrderNo = 1

	--Step 4: Delete super's setting
	DELETE main
	FROM EsportVR_Temp main
	INNER JOIN EsportVR_Temp g ON g.CustID = 0
		AND main.VRValue_121 = g.VRValue_121
		AND main.VRValue_122 = g.VRValue_122
		AND  main.VRValue_123 = g.VRValue_123
		AND  main.VRValue_124 = g.VRValue_124
		AND  main.VRValue_125 = g.VRValue_125
		AND  main.VRValue_126 = g.VRValue_126
		AND  main.VRValue_127 = g.VRValue_127
		AND  main.VRValue_128 = g.VRValue_128
	WHERE main.RoleID=4