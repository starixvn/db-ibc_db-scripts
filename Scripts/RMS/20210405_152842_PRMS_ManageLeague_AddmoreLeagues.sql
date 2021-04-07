/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/

use bodb_RMS
go

/*
	Created: 20210405@Danny
	DB: DBRMS.bodb_RMS
	Task: Support PRMS - Add more league
*/

insert into dbo.rmLeagueGroup (GroupId, GroupName, OrderId)
			select 10, 'CUP'			, 64
union all	select 11, 'Corner'		, 66

go


create table #league (leagueid int, leaguename nvarchar(500), groupid tinyint, groupname varchar(30))
insert into #league (leaguename, groupname)
select '*GERMANY SUPER CUP','CUP' union all
select '*UEFA SUPER CUP','CUP' union all
select 'AFRICA CUP OF NATIONS 2021 QUALIFIERS','CUP' union all
select 'ALGERIA SUPER CUP','CUP' union all
select 'ARAB CLUB CHAMPIONS CUP','CUP' union all
select 'ARGENTINA CUP','CUP' union all
select 'ARGENTINA SUPER LIGA CUP','CUP' union all
select 'ARMENIA CUP','CUP' union all
select 'ARMENIA SUPER CUP','CUP' union all
select 'AUSTRALIA TASMANIA LAKOSELJAC CUP','CUP' union all
select 'AUSTRIA CUP','CUP' union all
select 'AUSTRIA TFV TIROL CUP','CUP' union all
select 'AUSTRIA VFV CUP','CUP' union all
select 'BAHRAIN KING CUP','CUP' union all
select 'BANGLADESH FEDERATION CUP','CUP' union all
select 'BELARUS CUP','CUP' union all
select 'BELGIUM CUP','CUP' union all
select 'BOSNIA-HERZEGOVINA CUP','CUP' union all
select 'BOSNIA-HERZEGOVINA REPUBLIKA SRPSKA CUP','CUP' union all
select 'BRAZIL CUP','CUP' union all
select 'BRAZIL CUP U20','CUP' union all
select 'BRAZIL GAUCHO CUP','CUP' union all
select 'BULGARIA CUP','CUP' union all
select 'BULGARIA SUPER CUP','CUP' union all
select 'CAF CONFEDERATION CUP','CUP' union all
select 'CAF CONFEDERATION CUP QUALIFIERS','CUP' union all
select 'CATALUNYA CUP','CUP' union all
select 'CHINA FA CUP','CUP' union all
select 'COLOMBIA CUP','CUP' union all
select 'CROATIA CUP','CUP' union all
select 'CYPRUS CUP','CUP' union all
select 'CZECH REPUBLIC CUP','CUP' union all
select 'DENMARK CUP','CUP' union all
select 'DENMARK WOMEN CUP','CUP' union all
select 'EGYPT CUP','CUP' union all
select 'ENGLISH CENTRAL RESERVE LEAGUE CUP','CUP' union all
select 'ENGLISH FA CUP','CUP' union all
select 'ENGLISH FA CUP QUALIFIERS','CUP' union all
select 'ENGLISH FA WOMEN CUP','CUP' union all
select 'ENGLISH FA WOMEN LEAGUE CUP','CUP' union all
select 'ENGLISH LEAGUE CUP','CUP' union all
select 'ESTONIA CUP','CUP' union all
select 'FIFA WORLD CUP 2022 SOUTH AMERICA QUALIFIERS','CUP' union all
select 'FINLAND CUP','CUP' union all
select 'FINLAND WOMEN CUP','CUP' union all
select 'FRANCE LEAGUE CUP','CUP' union all
select 'GEORGIA CUP','CUP' union all
select 'GERMANY BADEN CUP','CUP' union all
select 'GERMANY BERLIN CUP','CUP' union all
select 'GERMANY BFV TOTO CUP','CUP' union all
select 'GERMANY BRANDENBURG CUP','CUP' union all
select 'GERMANY CUP','CUP' union all
select 'GERMANY HESSEN CUP','CUP' union all
select 'GERMANY NIEDERRHEIN CUP','CUP' union all
select 'GERMANY NIEDERSACHSEN CUP','CUP' union all
select 'GERMANY NIEDERSACHSEN CUP QUALIFIERS','CUP' union all
select 'GERMANY REGIONALLIGA BAYERN LEAGUE CUP','CUP' union all
select 'GERMANY SAARLAND CUP','CUP' union all
select 'GERMANY SAXONY CUP','CUP' union all
select 'GERMANY SOUTHWEST CUP','CUP' union all
select 'GERMANY THURINGEN CUP','CUP' union all
select 'GERMANY U19 CUP','CUP' union all
select 'GERMANY WESTFALEN CUP','CUP' union all
select 'GERMANY WOMEN FOOTBALL CUP','CUP' union all
select 'GRAND EST WOMEN CUP (IN FRANCE)','CUP' union all
select 'GREECE CUP','CUP' union all
select 'HELDEN CUP (IN AUSTRIA)','CUP' union all
select 'HUNGARY CUP','CUP' union all
select 'HUNGARY WOMEN CUP','CUP' union all
select 'ICELAND CUP','CUP' union all
select 'ICELAND WOMEN CUP','CUP' union all
select 'IRAN CUP','CUP' union all
select 'IRELAND FAI CUP','CUP' union all
select 'IRELAND MUNSTER SENIOR CUP','CUP' union all
select 'ISRAEL STATE CUP','CUP' union all
select 'ISRAEL STATE CUP U19','CUP' union all
select 'ISRAEL SUPER CUP','CUP' union all
select 'ISRAEL TOTO CUP','CUP' union all
select 'ISRAEL TOTO CUP LEUMIT','CUP' union all
select 'ITALY CUP','CUP' union all
select 'ITALY PRIMAVERA CUP U19','CUP' union all
select 'JAPAN EMPEROR CUP','CUP' union all
select 'JAPAN EMPRESS WOMEN CUP','CUP' union all
select 'JAPAN LEAGUE CUP','CUP' union all
select 'KOREA FA CUP','CUP' union all
select 'KUWAIT CROWN PRINCE CUP','CUP' union all
select 'KUWAIT CROWN PRINCE CUP QUALIFIERS','CUP' union all
select 'LATVIA CUP','CUP' union all
select 'LITHUANIA CUP','CUP' union all
select 'MEXICO CUP','CUP' union all
select 'MOROCCO CUP','CUP' union all
select 'NETHERLANDS CUP','CUP' union all
select 'NETHERLANDS CUP QUALIFIERS','CUP' union all
select 'NETHERLANDS WOMEN CUP','CUP' union all
select 'NORTHERN IRELAND CUP','CUP' union all
select 'NORWAY WOMEN CUP','CUP' union all
select 'POLAND CUP','CUP' union all
select 'POLAND REGIONAL CUP','CUP' union all
select 'POLAND SUPER CUP','CUP' union all
select 'POLAND WOMEN CUP','CUP' union all
select 'PORTUGAL CUP','CUP' union all
select 'PORTUGAL LEAGUE CUP','CUP' union all
select 'PORTUGAL SUPER CUP','CUP' union all
select 'PORTUGAL WOMEN CUP','CUP' union all
select 'POSTNORD CUP (IN NORWAY)','CUP' union all
select 'PRE SEASON CUP (IN ENGLAND)','CUP' union all
select 'QATAR EMIR CUP','CUP' union all
select 'QATAR STARS LEAGUE CUP','CUP' union all
select 'ROMANIA CUP','CUP' union all
select 'RUSSIA CUP','CUP' union all
select 'RUSSIA SUPER CUP','CUP' union all
select 'RUSSIA WOMEN CUP','CUP' union all
select 'SAUDI KING CUP','CUP' union all
select 'SCOTLAND FA CUP','CUP' union all
select 'SCOTLAND LEAGUE CUP','CUP' union all
select 'SERBIA CUP','CUP' union all
select 'SLOVAKIA CUP','CUP' union all
select 'SLOVENIA CUP','CUP' union all
select 'SLOVENIA WOMEN CUP','CUP' union all
select 'SOUTH AFRICA CUP','CUP' union all
select 'SOUTH AUSTRALIA WOMEN PREMIER CUP','CUP' union all
select 'SPAIN CUP','CUP' union all
select 'SPAIN CUP QUALIFIERS','CUP' union all
select 'SPAIN QUEEN CUP','CUP' union all
select 'SRI LANKA FFSL PRESIDENT CUP','CUP' union all
select 'SWEDEN CUP','CUP' union all
select 'SWEDEN WOMEN CUP','CUP' union all
select 'SWITZERLAND CUP','CUP' union all
select 'SWITZERLAND ERSTE LIGA CUP PROMOTION LEAGUE QUALIFIERS','CUP' union all
select 'TAIWAN WOMEN FOOTBALL LEAGUE CUP','CUP' union all
select 'THAILAND FA CUP','CUP' union all
select 'THAILAND FA CUP QUALIFIERS','CUP' union all
select 'THE LAND OF LEGENDS CUP (IN TURKEY)','CUP' union all
select 'TUNISIAN CUP','CUP' union all
select 'TUNISIAN SUPER CUP','CUP' union all
select 'TURKEY CUP','CUP' union all
select 'UAE LEAGUE CUP','CUP' union all
select 'UAE PRESIDENTS CUP','CUP' union all
select 'UAE PRESIDENTS CUP QUALIFIERS','CUP' union all
select 'UKRAINE CUP','CUP' union all
select 'UKRAINE SUPER CUP','CUP' union all
select 'USA NISA INDEPENDENT CUP','CUP' union all
select 'UZBEKISTAN CUP','CUP' union all
select 'WINTER CUP (IN NORWAY)','CUP' union all
select '*ENGLISH PREMIER LEAGUE - CORNERS','Corner' union all
select '*GERMANY-BUNDESLIGA I - CORNERS','Corner' union all
select '*ITALY SERIE A - CORNERS','Corner' union all
select '*SPAIN PRIMERA LALIGA - CORNERS','Corner' union all
select '*UEFA CHAMPIONS LEAGUE - CORNERS','Corner' 

update t
set t.leagueid = l.leagueid
	,t.groupid = lg.groupid
from #league t
	inner join bodb02.dbo.League l with (nolock) on t.leaguename = l.leaguename
	inner join dbo.rmLeagueGroup lg with (nolock) on t.groupname = lg.groupname
WHERE l.sporttype = 1

insert into dbo.rmLeague (LeagueId, GroupId)
select LeagueId, GroupId from #league
where leagueId is not null
	and leagueId not in (select leagueid from dbo.rmLeague with (nolock))

drop table #league


