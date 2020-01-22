use bodb_RMS
go

/*
	Created: 20200120@Percy
	DB: DBRMS.bodb_RMS
	Task: Support PRMS - Manage League - Add more league
*/

create table #league (leagueid int, leaguename nvarchar(500), groupid tinyint, groupname varchar(30))
insert into #league (leaguename, groupname)
select 'PORTUGAL SUPER LIGA', 'M1' union all
select 'ARGENTINA SUPER LIGA', 'M2' union all
select 'MEXICO PRIMERA DIVISION', 'M2' union all
select 'HOLLAND EERSTE DIVISIE', 'M3' union all
select 'ITALY SERIE C', 'M3' union all
select 'QATAR STARS LEAGUE', 'M4 (a)' union all
select 'SAUDI PRO LEAGUE', 'M4 (a)' union all
select 'ANDORRA PRIMERA DIVISION', 'M4 (x)' union all
select 'ARGENTINA NACIONAL B DIVISION', 'M4 (b)' union all
select 'AUSTRALIA W-LEAGUE', 'M4 (b)' union all
select 'AUSTRIA REGIONAL LEAGUE EAST', 'M4 (x)' union all
select 'BRAZIL CAMPEONATO GAUCHO 1ST DIVISION', 'Blacklist' union all
select 'BRAZIL COPA DO NORDESTE', 'Blacklist' union all
select 'BRAZIL CAMPEONATO PERNAMBUCANO', 'Blacklist' union all
select 'BULGARIA SECOND PROFESSIONAL LEAGUE', 'M4 (x)' union all
select 'COSTA RICA PRIMERA DIVISION', 'M4 (x)' union all
select 'CROATIA 1ST DIVISION', 'M4 (x)' union all
select 'ENGLISH FA WOMEN SUPER LEAGUE', 'M4 (x)' union all
select 'ENGLISH LANCASHIRE FA CHALLENGE TROPHY', 'M4 (x)' union all
select 'ENGLISH PREMIER LEAGUE 2 DIVISION 1', 'M4 (x)' union all
select 'ENGLISH U23 PROFESSIONAL DEVELOPMENT LEAGUE', 'M4 (x)' union all
select 'ESTONIA MEISTRILIIGA', 'M4 (x)' union all
select 'NORTH MACEDONIA 1ST LEAGUE', 'Blacklist' union all
select 'GEORGIA EROVNULI LIGA', 'Blacklist' union all
select 'HUNGARY NB I', 'Blacklist' union all
select 'HUNGARY WOMEN NB I', 'Blacklist' union all
select 'INDONESIA LIGA 1', 'M4 (b)' union all
select 'MALTA PREMIER LEAGUE', 'Blacklist' union all
select 'MOROCCO BOTOLA 2', 'M4 (b)' union all
select 'MOROCCO U20 LEAGUE', 'M4 (b)' union all
select 'RUSSIA CHAMPIONSHIP U20', 'M4 (x)' union all
select 'Saudi 1st Division', 'Blacklist' union all
select 'SERBIA FIRST LEAGUE', 'M4 (x)' union all
select 'SOUTH AFRICA PREMIERSHIP', 'M4 (b)' union all
select 'SWEDEN ALLSVENSKAN U19', 'M4 (x)' union all
select 'UEFA U17 CHAMPIONSHIP QUALIFIERS', 'M4 (x)' union all
select 'UEFA U19 CHAMPIONSHIP QUALIFIERS', 'M4 (x)' union all
select 'UKRAINE 1ST LEAGUE', 'Blacklist' union all
select 'UKRAINE YOUTH CHAMPIONSHIP U21', 'Blacklist' union all
select 'UZBEKISTAN PRO LEAGUE A', 'Blacklist' union all
select 'UZBEKISTAN SUPER LEAGUE', 'M4 (x)' union all
select 'Uzbekistan Women Championship', 'M4 (x)' union all
select 'VENEZUELA TERCERA DIVISION', 'Blacklist' union all
select 'TURKEY ELITE SUPER LEAGUE U19', 'M4 (x)'

update t
set t.leagueid = l.leagueid
	,t.groupid = lg.groupid
from #league t
	inner join bodb02.dbo.League l with (nolock) on t.leaguename = l.leaguename
	inner join dbo.rmLeagueGroup lg with (nolock) on t.groupname = lg.groupname

insert into dbo.rmLeague (LeagueId, GroupId)
select LeagueId, GroupId from #league
where leagueId is not null
	and leagueId not in (select leagueid from dbo.rmLeague with (nolock))

drop table #league