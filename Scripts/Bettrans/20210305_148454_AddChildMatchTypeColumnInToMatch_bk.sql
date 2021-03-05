/*<info serverAlias="DBARC-bodb_Archive"></info>*/

/*
	Created: 20210305@Malcolm
	DB: DBARC.bodb_Archive
	Task:  Add ChildMatchType column into Match_bk
*/
ALTER TABLE dbo.match_bk
ADD ChildMatchType TINYINT NULL
