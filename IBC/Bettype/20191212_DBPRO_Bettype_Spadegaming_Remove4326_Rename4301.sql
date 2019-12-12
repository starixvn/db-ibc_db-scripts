use bodb02
go

/*
	Created: 20191212@Percy
	DB: DBPRO.bodb02
	Task: Spadegaming
		+ Remove bet type 4326
		+ Rename bet type 4301
*/

delete dbo.bettype with (rowlock, updlock)
where typeid = 4326

update bettype with (rowlock)
set typenamee			= N'Tiger Warrior'
	,typenamec			= N'Tiger Warrior'
	,typedesc			= N'Tiger Warrior'
	,typenamec_uni		= N'Tiger Warrior'
	,typenamej			= N'Tiger Warrior'
	,typenamcn			= N'Tiger Warrior'
	,typenamecn			= N'Tiger Warrior'
	,typenameth			= N'Tiger Warrior'
	,typenameit			= N'Tiger Warrior'
	,typenameko			= N'Tiger Warrior'
	,typenameES			= N'Tiger Warrior'
	,typenameVN			= N'Tiger Warrior'
	,typenameEL			= N'Tiger Warrior'
	,typenamee_Eu		= N'Tiger Warrior'
	,typenameRU			= N'Tiger Warrior'
	,typenameID			= N'Tiger Warrior'
	,typenamePT			= N'Tiger Warrior'
	,typenameFR			= N'Tiger Warrior'
	,typenameMMR		= N'Tiger Warrior'
	,typenameHI			= N'Tiger Warrior'
where typeid			= 4301