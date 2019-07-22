/*
	Task: Update valueID and HasSameVR - Redmine: 114830
		Step 1: Update [HasSameVR]
		Step 2: Update ValueID
	Creator: Dominic@20190718
	Run at: CustDB@DBCUST 
*/
USE CustDB
GO
	--Step 1: Update [HasSameVR]
	UPDATE main
	SET  main.HasSameVR = 0
	FROM EsportVR_Temp main
	WHERE NOT (
		main.VRValue_121 = main.VRValue_123
		AND  main.VRValue_121 = main.VRValue_125
		AND  main.VRValue_121 = main.VRValue_127

		AND  main.VRValue_122 = main.VRValue_124	
		AND  main.VRValue_122 = main.VRValue_126	
		AND  main.VRValue_122 = main.VRValue_128
	)

	--Step 2: Update ValueID
	UPDATE main
	SET VRValue_121 = v121.ValueID
		, VRValue_122 = v122.ValueID
		, VRValue_123 = v123.ValueID
		, VRValue_124 = v124.ValueID
		, VRValue_125 = v125.ValueID
		, VRValue_126 = v126.ValueID
		, VRValue_127 = v127.ValueID
		, VRValue_128 = v128.ValueID
	FROM EsportVR_Temp main
		INNER JOIN VRValueMapping v121 ON v121.Value = main.VRValue_121
		INNER JOIN VRValueMapping v122 ON v122.Value = main.VRValue_122
		INNER JOIN VRValueMapping v123 ON v123.Value = main.VRValue_123
		INNER JOIN VRValueMapping v124 ON v124.Value = main.VRValue_124
		INNER JOIN VRValueMapping v125 ON v125.Value = main.VRValue_125
		INNER JOIN VRValueMapping v126 ON v126.Value = main.VRValue_126
		INNER JOIN VRValueMapping v127 ON v127.Value = main.VRValue_127
		INNER JOIN VRValueMapping v128 ON v128.Value = main.VRValue_128