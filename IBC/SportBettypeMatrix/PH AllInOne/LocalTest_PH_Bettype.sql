Use bodb02
GO

INSERT INTO Bettype (TypeId, typenamee, typedesc, ParentTypeid)
VALUES (401,'Home Team Over/Under','Home Team Over/Under', 401)
,(402,'Away Team Over/Under','Away Team Over/Under', 402)
,(403,'1H Home Team Over/Under','', 403)
,(404,'1H Away Team Over/Under','1H Away Team Over/Under', 404)
,(405,'2H Correct Score','2H Correct Score', 405)
,(406,'Exact Total Goals','Exact Total Goals', 406)
,(407,'Exact Home Team Goals','Exact Home Team Goals', 407)
,(408,'Winning Margin','Winning Margin', 408)
,(409,'Exact Away Team Goals','Exact Away Team Goals', 409)
,(410,'1H Double Chance','1H Double Chance', 410)
,(411,'1H Draw No Bet','1H Draw No Bet', 411)
,(412, 'Exact 1st Half Goal', 'Exact 1st Half Goal', 412)




UPDATE	Bettype WITH (UPDLOCK, ROWLOCK)
SET		typenamee = typenamee + ' (3rd)',
		ParentTypeid =406
WHERE	TypeID = 159


UPDATE	Bettype WITH (UPDLOCK, ROWLOCK)
SET		typenamee = typenamee + ' (3rd)',
		ParentTypeid =407
WHERE	TypeID = 161


UPDATE	Bettype WITH (UPDLOCK, ROWLOCK)
SET		typenamee = typenamee + ' (3rd)',
		ParentTypeid = 408
WHERE	TypeID = 171


UPDATE	Bettype WITH (UPDLOCK, ROWLOCK)
SET		typenamee = typenamee + ' (3rd)',
		ParentTypeid =409
WHERE	TypeID = 162


UPDATE	Bettype WITH (UPDLOCK, ROWLOCK)
SET		typenamee = typenamee + ' (3rd)',
		ParentTypeid = 410
WHERE	TypeID = 151


UPDATE	Bettype WITH (UPDLOCK, ROWLOCK)
SET		typenamee = typenamee + ' (3rd)',
		ParentTypeid =411
WHERE	TypeID = 191

 