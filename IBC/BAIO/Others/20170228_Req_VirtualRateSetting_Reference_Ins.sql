 /*
	Created: 2017@Helen
	Task : BAIO - [Redmine: 71609]
	DB: DBTXN/bodb02
	
	/*
	(1,1),
(3,3),
(2,2),
(20,20),
(601,0),
(602,0),
(401,3),
(402,3),
(603,20),
(604,20),
(605,20),
(,),
(7,7),
(8,8),
(12,12),
(21,21),
(606,21),
(607,21),
(608,),
(403,8),
(404,8),
(,),
(609,1),
(610,3),
(611,2),
(612,20),
(613,20),
(614,),
(615,3),
(616,3),
(617,20),

	*/		
*/
USE bodb02
go

CREATE TABLE #VirtualRateSetting (BetTypeID INT, BetTypeRefID INT)
INSERT INTO #VirtualRateSetting (BetTypeID,BetTypeRefID)
VALUES (1,1),
(3,3),
(2,2),
(20,20),

(401,3),
(402,3),
(603,20),
(604,20),
(605,20),
(7,7),
(8,8),
(12,12),
(21,21),
(606,21),
(607,21),

(403,8),
(404,8),

(609,1),
(610,3),
(611,2),
(612,20),
(613,20),

(615,3),
(616,3),
(617,20)

-- 17 bettypes refer to another
INSERT INTO Sport_Bettype_Reference_VirtualRate (SportType,BetType,SportTypeRefVirtualRate,BetTypeRefVirtualRate,isActive)
SELECT 2 AS SportType,BetTypeID,2,BetTypeRefID,0
FROM #VirtualRateSetting
WHERE BetTypeID <> BetTypeRefID

DROP TABLE #VirtualRateSetting

