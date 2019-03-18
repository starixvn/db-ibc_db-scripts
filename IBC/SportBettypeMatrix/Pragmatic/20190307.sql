insert into bodb02.dbo.bettype (typeid, typenamee, typedesc, ParentTypeid, DisplayedTypeID)
values (4300, 'Promotion Prize Win', 'Promotion Prize Win', 4300, 4300)

insert into bodb02.dbo.bettype_Local (typeid, typenamee, typedesc, ParentTypeid, DisplayedTypeID)
values (4300, 'Promotion Prize Win', 'Promotion Prize Win', 4300, 4300)

insert into bodb02.dbo.SportBettypeMatrix (SportType, BetType, IsLive, IsTest, Enabled, EventType, ProductID, SubProduct, RefTable)
values (248, 4300, 0, 0, 1, 0, 32, '', 1)

insert into bodb02.dbo.SportBettypeMatrix_Local (SportType, BetType, IsLive, IsTest, Enabled, EventType, ProductID, SubProduct, RefTable)
values (248, 4300, 0, 0, 1, 0, 32, '', 1)