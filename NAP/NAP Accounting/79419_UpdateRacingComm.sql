--- DBPRO
USE bodb02
GO 

/*

	Created: 20170705@Sophia: Change of Acqua's commission 
	Redmine: #79419
	DB: DBPRO.bodb02
*/

SELECT distinct r.meetingID, p.programDate
INTO #Meeting
 FROM outright o WITH (NOLOCK)
   INNER JOIN LeagueDetail p WITH (NOLOCK) ON o.LeagueId = p.LeagueId AND p.programDate = o.programDate
   INNER JOIN RacingMeeting r WITH(NOLOCK) ON r.meetingID = p.LeagueId
   INNER JOIN league l with(nolock) on l.leagueid=p.leagueid
   INNER JOIN RacingPartner ra WITH (NOLOCK) ON ra .partnerID = r.partnerID
WHERE r.PartnerID=2
	and o.eventdate >='20170629'


INSERT INTO #Meeting 
SELECT distinct r.meetingID,   p.programDate
 FROM outright14 o WITH (NOLOCK)
   INNER JOIN LeagueDetail p WITH (NOLOCK) ON o.LeagueId = p.LeagueId AND p.programDate = o.programDate
   INNER JOIN RacingMeeting r WITH(NOLOCK) ON r.meetingID = p.LeagueId
   INNER JOIN league l with(nolock) on l.leagueid=p.leagueid
   INNER JOIN RacingPartner ra WITH (NOLOCK) ON ra .partnerID = r.partnerID
WHERE r.PartnerID=2
	and o.eventdate >='20170629'

	 
-----------

--Select * from RacingMeeting R (NOLOCK) 
--WHERE PartnerID = 2 

UPDATE R 
SET	  ToteCommWin = 0.1155, ToteCommPlace = 0.12
FROM  RacingMeeting R  
WHERE PartnerID = 2 

-----------


--Select * from LeagueDetail L (NOLOCK) 
--INNER JOIN #Meeting M 
--ON M.MeetingID = L.LeagueID
--AND M.programDate = L.programDate

UPDATE	L 
SET		ToteCommWin = 0.1155, ToteCommPlace = 0.12
FROM LeagueDetail L  
INNER JOIN #Meeting M 
	ON M.MeetingID = L.LeagueID
	AND M.programDate = L.programDate 




 DROP TABLE #Meeting