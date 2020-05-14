use bodb02
go

/*
	Created: 20191204@Percy
	DB: DBPRO.bodb02
	Task: Rename bet type 1302 from Match Correct Score to Match Correct Score (3rd) and change DisplayTypeId
*/

update bodb02.dbo.bettype with (rowlock)
set typenamee = 'Match Correct Score (3rd)'
	,DisplayedTypeID = 703
where typeid = 1302