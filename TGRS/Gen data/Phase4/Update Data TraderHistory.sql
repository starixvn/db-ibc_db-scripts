---DBTGRS/bodb_TGRS

--------------------------- GRADE -------------------------

SELECT CustID
INTO #CustList 
FROM TraderGrade_History WITH (NOLOCK)
GROUP BY  CustID, Enddate 
HAVING Count (*) > 1

CREATE TABLE #Grade_History (ID SMALLINT Identity (1,1),  CustId INT , Grade Tinyint , BeginDate Date, EndDate Date)

INSERT INTO #Grade_History  ( CustId, Grade, BeginDate , EndDate)
SELECT  CustId, Grade, BeginDate , EndDate
FROM TraderGrade_History WITH (NOLOCK)
WHERE CustID IN (Select * from #CustList)
ORDER BY CustID, BeginDate 

 
 --SELECT B.* , DATEADD (DAY, -1, A.BeginDate  )  
 --FROM #Grade_History A
 --INNER JOIN #Grade_History B ON A.ID = B.ID +1 AND A.CustID = B.CustID 

 UPDATE B
 SET B.EndDate = DATEADD (DAY, -1, A.BeginDate  )  
 FROM #Grade_History A
 INNER JOIN #Grade_History B 
	ON A.ID = B.ID +1 AND A.CustID = B.CustID 


 --SELECT * FROM #Grade_History

 --SELECT G.*, H.EndDate
	-- FROM TraderGrade_History G
 --INNER JOIN #Grade_History H
	--ON G.CustID = H.CustID
	--AND G.Grade = H.Grade
	--AND G.BeginDate = H.BeginDate



 UPDATE G
 SET G.EndDate = H.EndDate
 FROM TraderGrade_History G
 INNER JOIN #Grade_History H
	ON G.CustID = H.CustID
	AND G.Grade = H.Grade
	AND G.BeginDate = H.BeginDate
 


 -------------------------------TEAM -------------------------------

 
SELECT CustID
INTO #CustTeamList 
FROM TraderTeam_History WITH (NOLOCK)
GROUP BY  CustID, Enddate 
HAVING Count (*) > 1

CREATE TABLE #Team_History (ID SMALLINT Identity (1,1),  CustId INT , TeamId Tinyint , BeginDate Date, EndDate Date)

INSERT INTO #Team_History  ( CustId, TeamId, BeginDate , EndDate)
SELECT  CustId, TeamId, BeginDate , EndDate
FROM TraderTeam_History WITH (NOLOCK)
WHERE CustID IN (Select * from #CustList)
ORDER BY CustID, BeginDate 

 
 --SELECT B.* , DATEADD (DAY, -1, A.BeginDate  )  
 --FROM #Team_History A
 --INNER JOIN #Team_History B ON A.ID = B.ID +1 AND A.CustID = B.CustID 

 UPDATE B
 SET B.EndDate = DATEADD (DAY, -1, A.BeginDate  )  
 FROM #Team_History A
 INNER JOIN #Team_History B 
	ON A.ID = B.ID +1 AND A.CustID = B.CustID 


 --SELECT * FROM #Team_History

 --SELECT G.*, H.EndDate
	-- FROM TraderTeam_History G
 --INNER JOIN #Team_History H
	--ON G.CustID = H.CustID
	--AND G.TeamId = H.TeamId
	--AND G.BeginDate = H.BeginDate
 

 UPDATE G
 SET G.EndDate = H.EndDate
 FROM TraderTeam_History G
 INNER JOIN #Team_History H
	ON G.CustID = H.CustID
	AND G.TeamId = H.TeamId
	AND G.BeginDate = H.BeginDate
 