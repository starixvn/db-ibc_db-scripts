use bodb_RMS
go

/*
	Created: 20200120@Percy
	DB: DBRMS.bodb_RMS
	Task: PRMS - Initialize data for League Management
*/

insert into dbo.rmLeagueGroup (GroupId, GroupName, OrderId)
			select 1, 'mj'			, 1
union all	select 2, 'm1'			, 11
union all	select 3, 'm2'			, 21
union all	select 4, 'm3'			, 31
union all	select 5, 'm4 (a)'		, 41
union all	select 6, 'm4 (b)'		, 51
union all	select 7, 'm4 (x)'		, 61
union all	select 8, 'blacklist'	, 71
go


create table #league (leagueid int, leaguename nvarchar(500), groupid tinyint, groupname varchar(30))
insert into #league (leaguename, groupname)
select N'*ENGLISH PREMIER LEAGUE', 'MJ' union all
select N'*GERMANY-BUNDESLIGA I', 'MJ' union all
select N'*ITALY SERIE A', 'MJ' union all
select N'*SPAIN PRIMERA LALIGA', 'MJ' union all
select N'DENMARK SUPER LEAGUE', 'M1' union all
select N'ENGLISH LEAGUE CHAMPIONSHIP', 'M1' union all
select N'FRANCE LIGUE 1', 'M1' union all
select N'GERMANY BUNDESLIGA 2', 'M1' union all
select N'HOLLAND EREDIVISIE', 'M1' union all
select N'JAPAN J-LEAGUE DIVISION 1', 'M1' union all
select N'NORWAY ELITESERIEN', 'M1' union all
select N'PORTUGAL SUPER LIGA / PORTUGAL LIGA NOS (sbo)', 'M1' union all
select N'SCOTLAND PREMIERSHIP', 'M1' union all
select N'SWEDEN ALLSVENSKAN', 'M1' union all
select N'SWITZERLAND SUPER LEAGUE', 'M1' union all
select N'FRANCE LIGUE 2', 'M1' union all
select N'FINLAND VEIKKAUSLIIGA', 'M1' union all
select N'AUSTRALIA A-LEAGUE', 'M1' union all
select N'BELGIUM FIRST DIVISION A', 'M1' union all
select N'BRAZIL SERIE A', 'M1' union all
select N'ITALY SERIE B', 'M1' union all
select N'JAPAN J-LEAGUE DIVISION 2', 'M1' union all
select N'SPAIN SEGUNDA DIVISION', 'M1' union all
select N'AUSTRIA BUNDESLIGA', 'M2' union all
select N'SWEDEN SUPERETTAN', 'M2' union all
select N'RUSSIA PREMIER LEAGUE', 'M2' union all
select N'USA MAJOR LEAGUE SOCCER', 'M2' union all
select N'ENGLISH LEAGUE ONE', 'M2' union all
select N'JAPAN SATELLITE LEAGUE U23', 'M2' union all
select N'TURKEY SUPER LEAGUE', 'M2' union all
select N'ARGENTINA PRIMERA DIVISION / ARGENTINA SUPER LIGA', 'M2' union all
select N'COPA LIBERTADORES', 'M2' union all
select N'COPA SUDAMERICANA', 'M2' union all
select N'MEXICO PRIMERA DIVISION / MEXICO LIGA MX', 'M2' union all
select N'BRAZIL CAMPEONATO CARIOCA', 'M3' union all
select N'BRAZIL CAMPEONATO PAULISTA', 'M3' union all
select N'BRAZIL SERIE B', 'M3' union all
select N'CHINA FOOTBALL SUPER LEAGUE', 'M3' union all
select N'ICELAND PREMIER LEAGUE', 'M3' union all
select N'POLAND EKSTRAKLASA', 'M3' union all
select N'AUSTRIA 2ND LEAGUE', 'M3' union all
select N'CHILE PRIMERA DIVISION', 'M3' union all
select N'DENMARK 1ST DIVISION', 'M3' union all
select N'HOLLAND EERSTE DIVISIE / NETHERLANDS EERSTE DIVISIE', 'M3' union all
select N'IRELAND PREMIER DIVISION', 'M3' union all
select N'KOREA K LEAGUE 1', 'M3' union all
select N'POLAND 1ST DIVISION', 'M3' union all
select N'PORTUGAL LIGA PRO', 'M3' union all
select N'ENGLISH LEAGUE TWO', 'M3' union all
select N'GERMANY 3RD LIGA', 'M3' union all
select N'GREECE SUPER LEAGUE 1', 'Blacklist' union all
select N'EGYPT PREMIER LEAGUE', 'M3' union all
select N'IRELAND 1ST DIVISION', 'M3' union all
select N'CZECH REPUBLIC 1ST DIVISION', 'M3' union all
select N'NORWAY 1ST DIVISION', 'M3' union all
select N'ROMANIA LIGA I', 'M3' union all
select N'SCOTLAND CHAMPIONSHIP', 'M3' union all
select N'SWEDEN 1ST DIVISION NORTH', 'M3' union all
select N'SWEDEN 1ST DIVISION SOUTH', 'M3' union all
select N'WESTERN AUSTRALIA NATIONAL PREMIER LEAGUE', 'M3' union all
select N'ENGLISH NATIONAL LEAGUE', 'M3' union all
select N'FINLAND YKKONEN', 'Blacklist' union all
select N'AUSTRALIA VICTORIA PREMIER LEAGUE', 'M3' union all
select N'ITALY SERIE C (ITALY LEGA PRO 1A, 1B) ', 'M3' union all
select N'RUSSIA NATIONAL FOOTBALL LEAGUE', 'M3' union all
select N'BELGIUM FIRST DIVISION B', 'M3' union all
select N'SCOTLAND LEAGUE 1', 'M3' union all
select N'SCOTLAND LEAGUE 2', 'M3' union all
select N'SWITZERLAND CHALLENGE LEAGUE', 'M3' union all
select N'BRAZIL PRIMEIRA LIGA', 'M3' union all
select N'BAHRAIN PREMIER LEAGUE', 'M4 (a)' union all
select N'QATAR STARS LEAGUE / Qatar QNB Stars League', 'M4 (a)' union all
select N'SAUDI PRO LEAGUE / Saudi Arabia Pro League (sbo)', 'M4 (a)' union all
select N'UAE ARABIAN GULF LEAGUE', 'M4 (a)' union all
select N'PERU LIGA 1', 'M4 (a)' union all
select N'AUSTRALIA BRISBANE PRESEASON TOURNAMENT', 'M4 (a)' union all
select N'AUSTRALIA NEW SOUTH WALES PREMIER LEAGUE', 'M4 (a)' union all
select N'BELARUS PREMIER LEAGUE', 'M4 (a)' union all
select N'COLOMBIA PRIMERA A', 'M4 (a)' union all
select N'ENGLISH NATIONAL LEAGUE NORTH', 'M4 (a)' union all
select N'ENGLISH NATIONAL LEAGUE SOUTH', 'M4 (a)' union all
select N'FRANCE NATIONAL', 'M4 (a)' union all
select N'GERMANY REGIONAL LEAGUE BAVARIA', 'M4 (a)' union all
select N'GERMANY REGIONAL LEAGUE NORTH', 'M4 (a)' union all
select N'GERMANY REGIONAL LEAGUE NORTHEAST', 'M4 (a)' union all
select N'GERMANY REGIONAL LEAGUE SOUTH', 'M4 (a)' union all
select N'GERMANY REGIONAL LEAGUE SOUTHWEST', 'M4 (a)' union all
select N'GERMANY REGIONAL LEAGUE WEST', 'M4 (a)' union all
select N'ICELAND 1ST DIVISION', 'M4 (a)' union all
select N'KOREA NATIONAL LEAGUE', 'M4 (a)' union all
select N'NORWAY 2ND DIVISION', 'M4 (a)' union all
select N'SWEDEN 2ND DIVISION', 'M4 (a)' union all
select N'USA NATIONAL PREMIER SOCCER LEAGUE', 'M4 (a)' union all
select N'OMAN PROFESSIONAL LEAGUE', 'M4 (a)' union all
select N'INDIAN SUPER LEAGUE', 'M4 (a)' union all
select N'BRAZIL CAMPEONATO CATARINENSE', 'M4 (a)' union all
select N'BRAZIL CAMPEONATO MINEIRO', 'M4 (a)' union all
select N'BRAZIL CAMPEONATO PARANAENSE', 'M4 (a)' union all
select N'BRAZIL CAMPEONATO PERNAMBUCANO', 'M4 (a)' union all
select N'BRAZIL CAMPEONATO POTIGUAR', 'M4 (a)' union all
select N'CYPRUS 1ST DIVISION', 'M4 (a)' union all
select N'DENMARK 2ND DIVISION', 'M4 (a)' union all
select N'ALBANIA SUPER LEAGUE', 'Blacklist' union all
select N'ALGERIA 1ST DIVISION', 'Blacklist' union all
select N'ALGERIA 2ND DIVISION', 'Blacklist' union all
select N'ALGERIA RESERVE LEAGUE 1', 'Blacklist' union all
select N'ALGERIA RESERVE LEAGUE 2', 'Blacklist' union all
select N'ALGERIA U20 DIVISION 1', 'Blacklist' union all
select N'ANDORRA PRIMERA DIVISION / ANDORRA PRIMERA LEAGUE', 'M4 (x)' union all
select N'ARAB CHAMPIONS LEAGUE', 'M4 (x)' union all
select N'ARAB CLUB CHAMPIONSHIP QUALIFIERS', 'M4 (x)' union all
select N'ARAB U20 CHAMPIONSHIP', 'M4 (x)' union all
select N'ARGENTINA COPA DE ORO MAR DEL PLATA', 'M4 (x)' union all
select N'ARGENTINA COPA DESAFIO MAR DEL PLATA', 'M4 (x)' union all
select N'ARGENTINA NACIONAL B DIVISION / Argentina Primera B Nacional', 'M4 (b)' union all
select N'ARGENTINA PRIMERA B METROPOLITANA', 'M4 (b)' union all
select N'ARGENTINA PRIMERA C', 'M4 (x)' union all
select N'ARGENTINA PRIMERA D', 'M4 (x)' union all
select N'ARGENTINA RESERVE LEAGUE', 'M4 (x)' union all
select N'ARGENTINA TORNEO FEDERAL A', 'M4 (x)' union all
select N'ARGENTINA TORNEO FEDERAL B', 'M4 (x)' union all
select N'ARGENTINA TORNEO REGIONAL FEDERAL AMATEUR', 'M4 (x)' union all
select N'ARMENIA FIRST LEAGUE', 'Blacklist' union all
select N'ARMENIA PREMIER LEAGUE', 'M4 (b)' union all
select N'AUSTRALIA BRISBANE CAPITAL LEAGUE 1', 'M4 (x)' union all
select N'AUSTRALIA BRISBANE CAPITAL LEAGUE 1 RESERVE', 'M4 (x)' union all
select N'AUSTRALIA BRISBANE CAPITAL LEAGUE 2', 'M4 (x)' union all
select N'AUSTRALIA BRISBANE PREMIER DIVISION 1', 'M4 (x)' union all
select N'AUSTRALIA BRISBANE PREMIER LEAGUE', 'M4 (b)' union all
select N'AUSTRALIA BRISBANE PREMIER LEAGUE RESERVE', 'M4 (x)' union all
select N'AUSTRALIA BRISBANE WOMEN CAPITAL LEAGUE 1', 'M4 (x)' union all
select N'AUSTRALIA BRISBANE WOMEN PREMIER LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA CAPITAL TERRITORY PREMIER LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA CAPITAL TERRITORY PREMIER LEAGUE 2', 'M4 (x)' union all
select N'AUSTRALIA CAPITAL TERRITORY PREMIER LEAGUE U20', 'M4 (x)' union all
select N'AUSTRALIA CAPITAL TERRITORY STATE LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA CAPITAL TERRITORY WOMEN PREMIER LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA FOOTBALL QUEENSLAND PREMIER LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA GOLD COAST DIVISION 1', 'M4 (x)' union all
select N'AUSTRALIA GOLD COAST PREMIER LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA GOLD COAST PREMIER LEAGUE RESERVE', 'M4 (x)' union all
select N'AUSTRALIA MCINERNEY FORD NIGHT SERIES 1ST DIVISION', 'M4 (x)' union all
select N'AUSTRALIA MCINERNEY FORD NIGHT SERIES PREMIER', 'M4 (x)' union all
select N'AUSTRALIA NATIONAL PREMIER LEAGUE', 'M4 (b)' union all
select N'AUSTRALIA NATIONAL YOUTH LEAGUE', 'M4 (b)' union all
select N'AUSTRALIA NEW SOUTH WALES PREMIER LEAGUE 2', 'M4 (x)' union all
select N'AUSTRALIA NEW SOUTH WALES PREMIER LEAGUE 2 U20', 'M4 (x)' union all
select N'AUSTRALIA NEW SOUTH WALES PREMIER LEAGUE U20', 'M4 (x)' union all
select N'AUSTRALIA NEW SOUTH WALES SUPER LEAGUE', 'M4 (b)' union all
select N'AUSTRALIA NEW SOUTH WALES WOMEN PREMIER LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA NORTHERN NEW SOUTH WALES PREMIER LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA NORTHERN NEW SOUTH WALES PREMIER LEAGUE U20 (2X40 MINS)', 'M4 (x)' union all
select N'AUSTRALIA NORTHERN NEW SOUTH WALES PREMIER LEAGUE U22 (2X40 MINS)', 'M4 (x)' union all
select N'AUSTRALIA NORTHERN NEW SOUTH WALES STATE LEAGUE DIVISION 1', 'M4 (x)' union all
select N'AUSTRALIA NORTHERN TERRITORY PREMIER LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA QUEENSLAND LIONS SILVER BOOT', 'M4 (x)' union all
select N'AUSTRALIA QUEENSLAND NATIONAL PREMIER LEAGUE', 'M4 (b)' union all
select N'AUSTRALIA QUEENSLAND NATIONAL PREMIER LEAGUE U20', 'M4 (x)' union all
select N'AUSTRALIA QUEENSLAND NATIONAL WOMENS PREMIER LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA QUEENSLAND NATIONAL YOUTH PREMIER LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA QUEENSLAND STATE LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA SMARTER THAN SMOKING WOMEN LEAGUE NIGHT SERIES', 'M4 (x)' union all
select N'AUSTRALIA STATE LEAGUE CHARITY SHIELD', 'M4 (x)' union all
select N'AUSTRALIA SUNSHINE COAST PREMIER LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA SUNSHINE COAST PREMIER LEAGUE RESERVE', 'M4 (x)' union all
select N'AUSTRALIA TASMANIA NORTHERN CHAMPIONSHIP', 'Blacklist' union all
select N'AUSTRALIA TASMANIA NORTHERN CHAMPIONSHIP 1', 'M4 (x)' union all
select N'AUSTRALIA TASMANIA PREMIER LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA TASMANIA SOUTHERN CHAMPIONSHIP', 'Blacklist' union all
select N'AUSTRALIA TASMANIA SOUTHERN CHAMPIONSHIP 1', 'M4 (x)' union all
select N'AUSTRALIA TASMANIA SOUTHERN SUMMER SERIES', 'M4 (x)' union all
select N'AUSTRALIA TASMANIA WOMEN SUPER LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA TASMANIA WOMEN''S NORTHERN CHAMPIONSHIP', 'M4 (x)' union all
select N'AUSTRALIA TASMANIA WOMEN''S SOUTHERN CHAMPIONSHIP', 'M4 (x)' union all
select N'AUSTRALIA TASMANIAN VICTORY LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA VICTORIA COMMUNITY SHIELD', 'M4 (x)' union all
select N'AUSTRALIA VICTORIA PREMIER LEAGUE 2', 'M4 (x)' union all
select N'AUSTRALIA VICTORIA PREMIER LEAGUE 2 U20', 'M4 (x)' union all
select N'AUSTRALIA VICTORIA PREMIER LEAGUE RESERVE', 'M4 (x)' union all
select N'AUSTRALIA VICTORIA PREMIER LEAGUE U20', 'M4 (x)' union all
select N'AUSTRALIA VICTORIA PREMIER LEAGUE U21', 'M4 (x)' union all
select N'AUSTRALIA VICTORIA STATE LEAGUE DIVISION 1', 'M4 (x)' union all
select N'AUSTRALIA VICTORIA WOMENS COMMUNITY SHIELD', 'M4 (x)' union all
select N'AUSTRALIA VICTORIA WOMENS PREMIER LEAGUE', 'M4 (x)' union all
select N'AUSTRALIA VICTORIA WOMENS STATE LEAGUE DIVISION 1', 'M4 (x)' union all
select N'AUSTRALIA W-LEAGUE / Australia Westfield W-League (SBO)', 'M4 (b)' union all
select N'AUSTRIA JUGENDLIGA U18', 'M4 (x)' union all
select N'AUSTRIA LANDESLIGA', 'M4 (x)' union all
select N'AUSTRIA REGIONAL LEAGUE MITTE', 'M4 (x)' union all
select N'AUSTRIA REGIONAL LEAGUE OST / AUSTRIA REGIONAL LEAGUE EAST', 'M4 (x)' union all
select N'AUSTRIA REGIONAL LEAGUE SALZBURG', 'M4 (x)' union all
select N'AUSTRIA REGIONAL LEAGUE TIROL', 'LGL/New' union all
select N'AUSTRIA REGIONAL LEAGUE VORARLBERG', 'M4 (x)' union all
select N'AUSTRIA REGIONAL LEAGUE WEST', 'M4 (x)' union all
select N'AUSTRIA WOMEN BUNDESLIGA', 'M4 (x)' union all
select N'AUSTRIA WOMEN LEAGUE 1', 'M4 (x)' union all
select N'AZERBAIJAN DIVISION 1', 'Blacklist' union all
select N'AZERBAIJAN LEAGUE U19', 'Blacklist' union all
select N'AZERBAIJAN PREMIER LEAGUE', 'M4 (x)' union all
select N'AZERBAIJAN RESERVE LEAGUE', 'M4 (x)' union all
select N'BAHRAIN 2ND DIVISION', 'Blacklist' union all
select N'BAHRAIN U17 LEAGUE', 'M4 (x)' union all
select N'BAHRAIN YOUTH LEAGUE', 'Blacklist' union all
select N'BALTIC LEAGUE', 'M4 (x)' union all
select N'BALTIC WOMEN LEAGUE', 'M4 (x)' union all
select N'BANGLADESH CHAMPIONSHIP LEAGUE', 'Blacklist' union all
select N'BANGLADESH PREMIER LEAGUE', 'Blacklist' union all
select N'BELARUS DIVISION 1', 'M4 (x)' union all
select N'BELARUS RESERVE LEAGUE', 'M4 (x)' union all
select N'BELARUS WOMEN PREMIER LEAGUE', 'M4 (x)' union all
select N'BELGIUM BELOFTEN DIVISION', 'M4 (x)' union all
select N'BELGIUM BELOFTEN PRO LEAGUE', 'M4 (b)' union all
select N'BELGIUM ELITE LEAGUE U19', 'M4 (x)' union all
select N'BELGIUM FIRST AMATEUR DIVISION', 'M4 (x)' union all
select N'BELGIUM RESERVE LEAGUE', 'M4 (x)' union all
select N'BELGIUM WOMEN 1ST NATIONAL', 'M4 (x)' union all
select N'BELGIUM WOMEN SUPER LEAGUE', 'M4 (x)' union all
select N'BLK SILVER BOOT (IN AUSTRALIA)', 'M4 (x)' union all
select N'BOLIVIA LIGA NACIONAL B', 'Blacklist' union all
select N'BOLIVIA PROFESSIONAL FOOTBALL LEAGUE', 'M4 (b)' union all
select N'BOSNIA-HERZEGOVINA FIRST LEAGUE', 'Blacklist' union all
select N'BOSNIA-HERZEGOVINA PREMIER LEAGUE', 'M4 (b)' union all
select N'BRAZIL CAMPEONATO ACREANO DIVISION 1', 'Blacklist' union all
select N'BRAZIL CAMPEONATO ACRIANO', 'Blacklist' union all
select N'BRAZIL CAMPEONATO ACRIANO U20', 'Blacklist' union all
select N'BRAZIL CAMPEONATO ALAGOANO', 'Blacklist' union all
select N'BRAZIL CAMPEONATO AMAPAENSE', 'Blacklist' union all
select N'BRAZIL CAMPEONATO AMAZONENSE U19 ', 'Blacklist' union all
select N'BRAZIL CAMPEONATO ASPIRANTES U23', 'Blacklist' union all
select N'BRAZIL CAMPEONATO BAIANO', 'Blacklist' union all
select N'BRAZIL CAMPEONATO BAIANO SERIE B', 'Blacklist' union all
select N'BRAZIL CAMPEONATO BAIANO U20', 'Blacklist' union all
select N'BRAZIL CAMPEONATO BRASILIENSE U20', 'Blacklist' union all
select N'BRAZIL CAMPEONATO CAPIXABA SERIE A', 'Blacklist' union all
select N'BRAZIL CAMPEONATO CARIOCA SERIE B1', 'Blacklist' union all
select N'BRAZIL CAMPEONATO CARIOCA SERIE B1 U20', 'Blacklist' union all
select N'BRAZIL CAMPEONATO CARIOCA SERIE B2', 'Blacklist' union all
select N'BRAZIL CAMPEONATO CARIOCA SERIE B2 U20', 'Blacklist' union all
select N'BRAZIL CAMPEONATO CARIOCA SERIE C', 'Blacklist' union all
select N'BRAZIL CAMPEONATO CARIOCA U20', 'Blacklist' union all
select N'BRAZIL CAMPEONATO CATARINENSE SERIE B', 'Blacklist' union all
select N'BRAZIL CAMPEONATO CATARINENSE U20', 'Blacklist' union all
select N'BRAZIL CAMPEONATO CEARENSE', 'Blacklist' union all
select N'BRAZIL CAMPEONATO CEARENSE SERIE B', 'Blacklist' union all
select N'BRAZIL CAMPEONATO CEARENSE U20', 'Blacklist' union all
select N'BRAZIL CAMPEONATO GAUCHO', 'Blacklist' union all
select N'BRAZIL CAMPEONATO GAUCHO 1ST DIVISION', 'Blacklist' union all
select N'BRAZIL CAMPEONATO GAUCHO 2ND DIVISION', 'Blacklist' union all
select N'BRAZIL CAMPEONATO GAUCHO SEGUNDA DIVISION', 'Blacklist' union all
select N'BRAZIL CAMPEONATO GAUCHO U20', 'Blacklist' union all
select N'BRAZIL CAMPEONATO GOIANO', 'Blacklist' union all
select N'BRAZIL CAMPEONATO GOIANO DIVISION 2', 'Blacklist' union all
select N'BRAZIL CAMPEONATO GOIANO U20', 'Blacklist' union all
select N'BRAZIL CAMPEONATO MARANHENSE', 'Blacklist' union all
select N'BRAZIL CAMPEONATO MATOGROSSENSE', 'Blacklist' union all
select N'BRAZIL CAMPEONATO MATOGROSSENSE U19', 'Blacklist' union all
select N'BRAZIL CAMPEONATO MINEIRO DIVISION 2', 'Blacklist' union all
select N'BRAZIL CAMPEONATO MINEIRO U20', 'Blacklist' union all
select N'BRAZIL CAMPEONATO PARAENSE', 'Blacklist' union all
select N'BRAZIL CAMPEONATO PARAIBANO', 'Blacklist' union all
select N'BRAZIL CAMPEONATO PARANAENSE DIVISION 2', 'Blacklist' union all
select N'BRAZIL CAMPEONATO PARANAENSE U19', 'Blacklist' union all
select N'BRAZIL CAMPEONATO PAULISTA SERIE A2', 'Blacklist' union all
select N'BRAZIL CAMPEONATO PAULISTA SERIE A3', 'Blacklist' union all
select N'BRAZIL CAMPEONATO PAULISTA SERIE B', 'Blacklist' union all
select N'BRAZIL CAMPEONATO PAULISTA U20', 'Blacklist' union all
select N'BRAZIL CAMPEONATO PAULISTA U23 SEGUNDA DIVISION', 'Blacklist' union all
select N'BRAZIL CAMPEONATO PAULISTA WOMEN', 'Blacklist' union all
select N'BRAZIL CAMPEONATO PERNAMBUCANO SERIE A2', 'Blacklist' union all
select N'BRAZIL CAMPEONATO PERNAMBUCANO U20', 'Blacklist' union all
select N'BRAZIL CAMPEONATO PERNAMBUCANO WOMEN', 'Blacklist' union all
select N'BRAZIL CAMPEONATO PIAUIENSE', 'Blacklist' union all
select N'BRAZIL CAMPEONATO RONDONIESE', 'Blacklist' union all
select N'BRAZIL CAMPEONATO RORAIMENSE', 'Blacklist' union all
select N'BRAZIL CAMPEONATO SERGIPANO SERIE A1', 'Blacklist' union all
select N'BRAZIL CAMPEONATO TOCANTINENSE', 'Blacklist' union all
select N'BRAZIL CAMPEONATO U17', 'Blacklist' union all
select N'BRAZIL CAMPEONATO U20', 'Blacklist' union all
select N'BRAZIL CAMPEONATO WOMEN', 'Blacklist' union all
select N'BRAZIL CAPIXAPA', 'Blacklist' union all
select N'BRAZIL COPA DO NORDESTE U20', 'Blacklist' union all
select N'BRAZIL COPA FARES LOPES', 'M4 (x)' union all
select N'BRAZIL COPA GOVERNADOR DO ESTADO', 'Blacklist' union all
select N'BRAZIL COPA PAULISTA', 'Blacklist' union all
select N'BRAZIL COPA SAO PAULO JUNIOR', 'Blacklist' union all
select N'BRAZIL COPA U23', 'Blacklist' union all
select N'BRAZIL COPA VERDE', 'Blacklist' union all
select N'BRAZIL LIGA DO NORDESTE', 'Blacklist' union all
select N'BRAZIL PERNAMBUCANO', 'Blacklist' union all
select N'BRAZIL SERIE C', 'Blacklist' union all
select N'BRAZIL SERIE D', 'Blacklist' union all
select N'BRAZIL TORNEIO OTAVIO PINTO GUIMARAES', 'M4 (x)' union all
select N'BRAZIL WOMEN CAMPEONATO CARIOCA', 'Blacklist' union all
select N'BULGARIA FIRST PROFESSIONAL LEAGUE', 'M4 (x)' union all
select N'BULGARIA RESERVE LEAGUE', 'M4 (x)' union all
select N'BULGARIA SECOND PROFESSIONAL LEAGUE / BULGARIA B PFG', 'M4 (x)' union all
select N'BULGARIA U19 LEAGUE', 'M4 (x)' union all
select N'BULGARIA U21 LEAGUE', 'Blacklist' union all
select N'BULGARIA-THIRD LEAGUE', 'Blacklist' union all
select N'CAFA U19 CHAMPIONSHIP (IN TAJIKISTAN)', 'M4 (x)' union all
select N'CAMBODIAN PREMIER LEAGUE', 'Blacklist' union all
select N'CANADA SOCCER LEAGUE', 'Blacklist' union all
select N'CANADIAN PREMIER LEAGUE', 'M4 (x)' union all
select N'CHILE PRIMERA B', 'M4 (b)' union all
select N'CHILE SEGUNDA DIVISION', 'M4 (x)' union all
select N'CHINA 1ST DIVISION', 'Blacklist' union all
select N'CHINA 2ND DIVISION', 'Blacklist' union all
select N'CHINA CHAMPIONS LEAGUE', 'Blacklist' union all
select N'CHINA LEAGUE U23', 'Blacklist' union all
select N'CHINA NATIONAL GAMES 2017 - WOMEN SOCCER (IN TIANJIN)', 'Blacklist' union all
select N'CHINA RESERVE LEAGUE', 'Blacklist' union all
select N'CHINA WOMEN FOOTBALL CHAMPIONSHIP', 'Blacklist' union all
select N'CHINA WOMEN SUPER LEAGUE', 'Blacklist' union all
select N'COLOMBIA COPA DEL SOL', 'M4 (x)' union all
select N'COLOMBIA CUADRANGULARES DE ASCENSO', 'M4 (x)' union all
select N'COLOMBIA PRIMERA B', 'M4 (b)' union all
select N'COLOMBIA WOMEN LEAGUE', 'M4 (x)' union all
select N'CONCACAF NATIONS LEAGUE A', 'M4 (x)' union all
select N'CONCACAF NATIONS LEAGUE B', 'M4 (x)' union all
select N'CONCACAF NATIONS LEAGUE C', 'M4 (x)' union all
select N'CONCACAF NATIONS LEAGUE QUALIFIERS', 'M4 (x)' union all
select N'COSAFA U20 CHAMPIONSHIP', 'M4 (b)' union all
select N'COSAFA WOMEN CHAMPIONSHIP U20 (IN SOUTH AFRICA)', 'M4 (x)' union all
select N'COSTA RICA LIGA DE ASCENSO', 'M4 (x)' union all
select N'COSTA RICA PRIMERA DIVISION / Costa Rica Campeonato Primera Division (sbo)', 'M4 (x)' union all
select N'CROATIA 1ST DIVISION /Croatia Prva Liga (sbo)', 'M4 (x)' union all
select N'CROATIA 2ND DIVISION', 'M4 (x)' union all
select N'CROATIA 3RD DIVISION', 'Blacklist' union all
select N'CROATIA U19 DIVISION', 'M4 (x)' union all
select N'CYPRUS 2ND DIVISION', 'M4 (x)' union all
select N'CYPRUS LEAGUE U19', 'Blacklist' union all
select N'CYPRUS U21 LEAGUE', 'Blacklist' union all
select N'CYPRUS WOMEN CHAMPIONSHIP', 'M4 (x)' union all
select N'CZECH REPUBLIC 1ST LIGA WOMEN', 'M4 (x)' union all
select N'CZECH REPUBLIC 3RD DIVISION CFL', 'Blacklist' union all
select N'CZECH REPUBLIC 3RD DIVISION MSFL', 'Blacklist' union all
select N'CZECH REPUBLIC NATIONAL FOOTBALL LEAGUE', 'Blacklist' union all
select N'CZECH REPUBLIC U19 LEAGUE', 'Blacklist' union all
select N'CZECH REPUBLIC U21 LEAGUE', 'Blacklist' union all
select N'DENMARK RESERVE LEAGUE', 'M4 (x)' union all
select N'DENMARK SERIES', 'M4 (x)' union all
select N'DENMARK U17 LEAGUE', 'M4 (x)' union all
select N'DENMARK U19 DIVISION', 'M4 (x)' union all
select N'DENMARK U19 LEAGUE', 'M4 (x)' union all
select N'DENMARK U21 TOURNAMENT', 'M4 (x)' union all
select N'DENMARK WOMEN 1ST DIVISION', 'M4 (x)' union all
select N'DENMARK WOMEN ELITEDIVISIONEN', 'M4 (x)' union all
select N'DENMARK WOMEN U18 LEAGUE', 'M4 (x)' union all
select N'ECUADOR APERTURA / CLAUSURA', 'M4 (x)' union all
select N'ECUADOR LEAGUE U19 A', 'M4 (x)' union all
select N'ECUADOR RESERVE LEAGUE', 'M4 (x)' union all
select N'ECUADOR SEGUNDA CATEGORIA', 'M4 (x)' union all
select N'ECUADOR SERIE A', 'M4 (b)' union all
select N'ECUADOR SERIE B', 'M4 (x)' union all
select N'EGYPT SECOND LEAGUE', 'M4 (x)' union all
select N'EGYPT U20', 'M4 (x)' union all
select N'EL SALVADOR PRIMERA DIVISION', 'M4 (x)' union all
select N'EL SALVADOR PRIMERA RESERVE LEAGUE', 'M4 (x)' union all
select N'EL SALVADOR U20 LEAGUE', 'M4 (x)' union all
select N'ENGLISH CENTRAL RESERVE LEAGUE', 'M4 (x)' union all
select N'ENGLISH FA WOMEN CHAMPIONSHIP', 'M4 (x)' union all
select N'ENGLISH FA WOMEN NATIONAL LEAGUE NORTHERN PREMIER DIVISION', 'M4 (x)' union all
select N'ENGLISH FA WOMEN NATIONAL LEAGUE SOUTHERN PREMIER DIVISION', 'M4 (x)' union all
select N'ENGLISH FA WOMEN SUPER LEAGUE / English Women Super League (sbo)', 'M4 (x)' union all
select N'ENGLISH FOOTBALL COMBINATION RESERVE LEAGUE', 'M4 (x)' union all
select N'ENGLISH ISTHMIAN CHARITY SHIELD', 'M4 (x)' union all
select N'ENGLISH ISTHMIAN LEAGUE DIVISION ONE NORTH', 'M4 (x)' union all
select N'ENGLISH ISTHMIAN LEAGUE DIVISION ONE SOUTH', 'M4 (x)' union all
select N'ENGLISH ISTHMIAN LEAGUE PREMIER DIVISION', 'M4 (b)' union all
select N'ENGLISH LANCASHIRE FA CHALLENGE TROPHY / ENGLISH LANCASHIRE CHALLENGE TROPHY', 'M4 (x)' union all
select N'ENGLISH NORTHERN DIVISION ONE NORTH', 'M4 (x)' union all
select N'ENGLISH NORTHERN DIVISION ONE SOUTH', 'M4 (x)' union all
select N'ENGLISH NORTHERN PREMIER DIVISION', 'M4 (x)' union all
select N'ENGLISH PREMIER LEAGUE 2 DIVISION 1 / ENGLISH BARCLAYS U21 PREMIER LEAGUE DIVISION 1', 'M4 (x)' union all
select N'ENGLISH PREMIER LEAGUE 2 DIVISION 2', 'M4 (x)' union all
select N'ENGLISH RESERVE LEAGUE', 'M4 (b)' union all
select N'ENGLISH SOUTHERN FOOTBALL LEAGUE DIVISION ONE', 'M4 (x)' union all
select N'ENGLISH SOUTHERN PREMIER DIVISION CENTRAL', 'M4 (b)' union all
select N'ENGLISH SOUTHERN PREMIER DIVISION SOUTH', 'M4 (b)' union all
select N'ENGLISH THE ALAN TURVEY TROPHY', 'M4 (x)' union all
select N'ENGLISH U23 PROFESSIONAL DEVELOPMENT LEAGUE / ENGLISH U21 PROFESSIONAL DEVELOPMENT LEAGUE TWO', 'M4 (x)' union all
select N'ESTONIA II LIIGA', 'Blacklist' union all
select N'ESTONIA MEISTRILIIGA / Estonia Premium Liga', 'M4 (x)' union all
select N'FIJI NATIONAL FOOTBALL LEAGUE', 'M4 (x)' union all
select N'FINLAND CHAMPIONSHIP U20', 'M4 (x)' union all
select N'FINLAND KAKKONEN', 'Blacklist' union all
select N'FINLAND KOLMONEN HELSINKI & UUSIMAA', 'M4 (x)' union all
select N'FINLAND KOLMONEN ITA & KESKI-SUOMI', 'M4 (x)' union all
select N'FINLAND KOLMONEN KAAKKOIS & SUOMEN', 'M4 (x)' union all
select N'FINLAND KOLMONEN KESKI POHJANMAA & VAASA', 'M4 (x)' union all
select N'FINLAND KOLMONEN LANSI - SUOMI', 'M4 (x)' union all
select N'FINLAND KOLMONEN POHJOIS & SUOMEN', 'M4 (x)' union all
select N'FINLAND KOLMONEN TAMPERE & SATAKUNTA', 'M4 (x)' union all
select N'FINLAND WOMEN LEAGUE', 'Blacklist' union all
select N'FINLAND WOMEN YKKONEN', 'M4 (x)' union all
select N'FINLAND YKKONEN U20', 'Blacklist' union all
select N'FOUR NATIONS TOURNAMENT U16 (IN SWEDEN)', 'Blacklist' union all
select N'FOUR NATIONS TOURNAMENT U17 (IN USA)', 'M4 (x)' union all
select N'FOUR NATIONS WOMEN TOURNAMENT (IN ROMANIA)', 'M4 (x)' union all
select N'FOUR NATIONS WOMEN TOURNAMENT U20 (IN CHINA)', 'M4 (x)' union all
select N'FRANCE U17 LEAGUE', 'M4 (b)' union all
select N'FRANCE U19 LEAGUE', 'M4 (b)' union all
select N'FRANCE WOMEN 1ST DIVISION', 'M4 (x)' union all
select N'FRANCE WOMEN LIGUE 1', 'M4 (b)' union all
select N'FYR MACEDONIA 1ST LEAGUE / NORTH MACEDONIA 1ST LEAGUE', 'Blacklist' union all
select N'GEORGIA EROVNULI LIGA / GEORGIA NATIONAL LEAGUE', 'Blacklist' union all
select N'GEORGIA RESERVE LEAGUE', 'Blacklist' union all
select N'GERMANY BUNDESLIGA U17 (2X40 MINS)', 'Blacklist' union all
select N'GERMANY BUNDESLIGA U19', 'M4 (x)' union all
select N'GERMANY OBERLIGA', 'M4 (b)' union all
select N'GERMANY OBERLIGA MITTELRHEIN', 'M4 (x)' union all
select N'GERMANY WOMEN BUNDESLIGA', 'M4 (b)' union all
select N'GERMANY WOMEN BUNDESLIGA 2', 'M4 (x)' union all
select N'GREECE 3RD DIVISION', 'Blacklist' union all
select N'GREECE FOOTBALL LEAGUE ', 'Blacklist' union all
select N'GREECE FOOTBALL LEAGUE U19', 'Blacklist' union all
select N'GREECE SUPER LEAGUE U19', 'Blacklist' union all
select N'GREECE SUPER LEAGUE U20', 'Blacklist' union all
select N'GREECE U21 DIVISION', 'M4 (x)' union all
select N'GREECE WOMEN FIRST LEAGUE', 'M4 (x)' union all
select N'GUATEMALA CAMPEON DE CAMPEONES', 'M4 (x)' union all
select N'GUATEMALA LIGA NATIONAL', 'M4 (x)' union all
select N'GUATEMALA LIGA PRIMERA DIVISION', 'M4 (x)' union all
select N'HOLLAND BELOFTEN LEAGUE', 'M4 (b)' union all
select N'HOLLAND EERSTE DIVISIE U19', 'M4 (x)' union all
select N'HOLLAND EREDIVISIE U19', 'M4 (x)' union all
select N'HOLLAND JOHAN CRUIJFF SHIELD', 'M4 (x)' union all
select N'HOLLAND RESERVE LEAGUE', 'M4 (x)' union all
select N'HOLLAND TWEEDE DIVISIE', 'M4 (x)' union all
select N'HOLLAND WOMEN EREDIVISIE', 'M4 (b)' union all
select N'HONDURAS LIGA NACIONAL', 'M4 (x)' union all
select N'HONG KONG 1ST DIVISION', 'Blacklist' union all
select N'HONG KONG PREMIER LEAGUE', 'Blacklist' union all
select N'HONG KONG RESERVE LEAGUE', 'Blacklist' union all
select N'HUNGARY NB II', 'Blacklist' union all
select N'HUNGARY OTP BANK LIGA NB I / HUNGARY NB I', 'Blacklist' union all
select N'HUNGARY U19 I. OSZTALY', 'Blacklist' union all
select N'HUNGARY U19 II. OSZTALY', 'M4 (x)' union all
select N'HUNGARY U21 I. OSZTALY', 'Blacklist' union all
select N'HUNGARY WOMEN 1ST DIVISION / HUNGARY WOMEN NB I', 'Blacklist' union all
select N'ICELAND 2ND DIVISION', 'M4 (b)' union all
select N'ICELAND 3RD DIVISION', 'M4 (x)' union all
select N'ICELAND 4TH DIVISION', 'M4 (x)' union all
select N'ICELAND FAXAFLOAMOT WOMEN TOURNAMENT', 'M4 (x)' union all
select N'ICELAND FOOTBALL TOURNAMENT', 'M4 (x)' union all
select N'ICELAND REYKJAVIK PRESEASON TOURNAMENT', 'M4 (b)' union all
select N'ICELAND REYKJAVIK U19', 'M4 (x)' union all
select N'ICELAND REYKJAVIK WOMEN PRESEASON TOURNAMENT', 'M4 (x)' union all
select N'ICELAND U19 LEAGUE', 'M4 (x)' union all
select N'ICELAND WOMEN 1ST DIVISION', 'M4 (x)' union all
select N'ICELAND WOMEN PREMIER LEAGUE', 'M4 (x)' union all
select N'INDIA MUMBAI ELITE DIVISION', 'Blacklist' union all
select N'INDIAN I LEAGUE', 'Blacklist' union all
select N'INDONESIA LIGA 1 / INDONESIA SUPER LIGA', 'M4 (b)' union all
select N'INDONESIA LIGA 2', 'Blacklist' union all
select N'INDONESIA PREMIER LEAGUE / INDONESIA LIGA 1', 'M4 (x)' union all
select N'INTER DISTRICT CHAMPIONSHIP', 'M4 (x)' union all
select N'INTERNATIONAL FOOTBALL CHAMPIONSHIP U17 (IN CHINA)', 'M4 (x)' union all
select N'INTERNATIONAL FRIENDLY U16', 'M4 (x)' union all
select N'INTERNATIONAL FRIENDLY U17', 'M4 (x)' union all
select N'INTERNATIONAL FRIENDLY U20', 'M4 (x)' union all
select N'INTERNATIONAL FRIENDLY WOMEN', 'Women' union all
select N'INTERNATIONAL FRIENDLY WOMEN U16', 'M4 (x)' union all
select N'INTERNATIONAL FRIENDLY WOMEN U17', 'M4 (x)' union all
select N'INTERNATIONAL FRIENDLY WOMEN U18', 'M4 (x)' union all
select N'INTERNATIONAL FRIENDLY WOMEN U19', 'M4 (x)' union all
select N'INTERNATIONAL FRIENDLY WOMEN U20', 'M4 (x)' union all
select N'INTERNATIONAL FRIENDLY WOMEN U23', 'M4 (x)' union all
select N'INTERNATIONAL WOMEN TOURNAMENT (IN CROATIA)', 'M4 (x)' union all
select N'INTERNATIONAL YOUTH FOOTBALL TOURNAMENT (IN VIETNAM)', 'M4 (x)' union all
select N'IRAN AZADEGAN LEAGUE', 'Blacklist' union all
select N'IRAN PRO LEAGUE', 'M4 (b)' union all
select N'IRAN U23 LEAGUE', 'Blacklist' union all
select N'IRAQ LEAGUE', 'M4 (x)' union all
select N'IRELAND DIVISION U19', 'M4 (x)' union all
select N'IRELAND LEINSTER SENIOR LEAGUE SENIOR DIVISION', 'M4 (x)' union all
select N'IRELAND WOMEN NATIONAL LEAGUE', 'M4 (x)' union all
select N'ISRAEL LEUMIT LEAGUE', 'M4 (x)' union all
select N'ISRAEL LIGA ALEF', 'M4 (x)' union all
select N'ISRAEL LIGA BET', 'M4 (x)' union all
select N'ISRAEL NATIONAL LEAGUE NORTH U19', 'M4 (x)' union all
select N'ISRAEL NATIONAL LEAGUE SOUTH U19', 'M4 (x)' union all
select N'ISRAEL PREMIER LEAGUE', 'M4 (x)' union all
select N'ISRAEL U19 LEAGUE', 'M4 (x)' union all
select N'ISRAEL WOMEN 1ST LEAGUE', 'M4 (x)' union all
select N'ITALY CAMPIONATO NAZIONALE DANTE BERRETTI', 'M4 (x)' union all
select N'ITALY CAMPIONATO PRIMAVERA 1 U19', 'M4 (x)' union all
select N'ITALY CAMPIONATO PRIMAVERA 2 U19', 'M4 (x)' union all
select N'ITALY SERIE D', 'M4 (x)' union all
select N'ITALY WOMEN SERIE A', 'M4 (x)' union all
select N'JAMAICA PREMIER LEAGUE', 'Blacklist' union all
select N'JAPAN FOOTBALL LEAGUE', 'M4 (b)' union all
select N'JAPAN J-LEAGUE DIVISION 3', 'M4 (x)' union all
select N'JAPAN REGIONAL FOOTBALL LEAGUE', 'M4 (x)' union all
select N'JAPAN UNIVERSITY FOOTBALL CHAMPIONSHIP', 'M4 (x)' union all
select N'JAPAN UNIVERSITY WOMEN FOOTBALL CHAMPIONSHIP', 'M4 (x)' union all
select N'JAPAN WOMEN CHALLENGE LEAGUE', 'M4 (x)' union all
select N'JAPAN WOMEN FOOTBALL DIVISION 1', 'M4 (x)' union all
select N'JAPAN WOMEN FOOTBALL DIVISION 2', 'M4 (x)' union all
select N'JORDAN 1ST DIVISION', 'M4 (x)' union all
select N'JORDAN LEAGUE U19', 'M4 (x)' union all
select N'JORDAN PRO LEAGUE', 'M4 (b)' union all
select N'KAZAKHSTAN - WOMEN''S FOOTBALL CHAMPIONSHIP', 'M4 (x)' union all
select N'KAZAKHSTAN 1ST DIVISION', 'M4 (x)' union all
select N'KAZAKHSTAN 2ND DIVISION', 'Blacklist' union all
select N'KAZAKHSTAN PREMIER LEAGUE', 'Blacklist' union all
select N'KENYA NATIONAL SUPER LEAGUE', 'M4 (x)' union all
select N'KENYA PREMIER LEAGUE', 'M4 (x)' union all
select N'KOREA CHALLENGERS LEAGUE', 'M4 (x)' union all
select N'KOREA K LEAGUE 2', 'M4 (b)' union all
select N'KOREA K3 LEAGUE ADVANCED', 'M4 (x)' union all
select N'KOREA K3 LEAGUE BASIC', 'M4 (x)' union all
select N'KOREA RESERVE LEAGUE', 'M4 (x)' union all
select N'KOREA U18 K LEAGUE', 'M4 (x)' union all
select N'KOREA U18 LEAGUE', 'M4 (x)' union all
select N'KOREA WOMEN K-LEAGUE', 'M4 (b)' union all
select N'KUWAIT DIVISION 1', 'Blacklist' union all
select N'KUWAIT PREMIER LEAGUE', 'Blacklist' union all
select N'KUWAIT U17 LEAGUE', 'Blacklist' union all
select N'LA MANGA INTERNATIONAL TOURNAMENT WOMEN U19 (IN SPAIN)', 'M4 (x)' union all
select N'LATVIA 1ST DIVISION', 'Blacklist' union all
select N'LATVIA VIRSLIGA', 'Blacklist' union all
select N'LITHUANIA 1 LYGA', 'Blacklist' union all
select N'LITHUANIA A LYGA', 'M4 (x)' union all
select N'LITHUANIA WOMEN A LYGA', 'M4 (x)' union all
select N'MALAYSIA PREMIER LEAGUE ', 'Blacklist' union all
select N'MALAYSIA SUPER LEAGUE', 'Blacklist' union all
select N'MALTA PREMIER LEAGUE / Malta BOV Premier League (sbo)', 'Blacklist' union all
select N'MEXICO LIGA DE ASCENSO', 'M4 (b)' union all
select N'MEXICO LIGA PREMIER SERIE A', 'M4 (x)' union all
select N'MEXICO LIGA PREMIER SERIE B', 'M4 (x)' union all
select N'MEXICO U20 LEAGUE', 'Blacklist' union all
select N'MEXICO WOMEN PRIMERA DIVISION', 'M4 (x)' union all
select N'MOLDOVA A DIVISION', 'Blacklist' union all
select N'MOLDOVA NATIONAL DIVISION', 'Blacklist' union all
select N'MOROCCO BOTOLA PRO', 'M4 (b)' union all
select N'MOROCCO GNF 2', 'M4 (b)' union all
select N'MOROCCO U20', 'M4 (b)' union all
select N'MYANMAR NATIONAL LEAGUE', 'Blacklist' union all
select N'MYANMAR NATIONAL LEAGUE 2', 'Blacklist' union all
select N'MYANMAR NATIONAL LEAGUE U19', 'Blacklist' union all
select N'MYANMAR NATIONAL LEAGUE U20', 'Blacklist' union all
select N'MYANMAR NATIONAL LEAGUE U21', 'Blacklist' union all
select N'NEW ZEALAND CANTERBURY CHAMPIONSHIP LEAGUE', 'M4 (x)' union all
select N'NEW ZEALAND CENTRAL LEAGUE', 'M4 (x)' union all
select N'NEW ZEALAND CHAMPIONSHIP LEAGUE', 'M4 (x)' union all
select N'NEW ZEALAND FOOTBALL SOUTH PREMIER LEAGUE', 'M4 (x)' union all
select N'NEW ZEALAND FOOTBALL SOUTH WOMEN PREMIER LEAGUE', 'M4 (x)' union all
select N'NEW ZEALAND MAINLAND PREMIER LEAGUE', 'M4 (x)' union all
select N'NEW ZEALAND MAINLAND PREMIER LEAGUE RESERVES', 'M4 (x)' union all
select N'NEW ZEALAND MAINLAND PREMIER QUALIFYING LEAGUE', 'M4 (x)' union all
select N'NEW ZEALAND MAINLAND WOMENS PREMIER LEAGUE', 'M4 (x)' union all
select N'NEW ZEALAND NORTHERN REGIONAL FOOTBALL LEAGUE', 'M4 (x)' union all
select N'NEW ZEALAND NRFL PREMIER RESERVES', 'M4 (x)' union all
select N'NEW ZEALAND NRFL WOMENS PREMIER DIVISION', 'M4 (x)' union all
select N'NEW ZEALAND PREMIERSHIP', 'M4 (x)' union all
select N'NEW ZEALAND SOUTHERN REGIONAL FOOTBALL LEAGUE', 'M4 (x)' union all
select N'NEW ZEALAND W-LEAGUE', 'M4 (x)' union all
select N'NEW ZEALAND WOMEN CANTERBURY CHAMPIONSHIP LEAGUE', 'M4 (x)' union all
select N'NEW ZEALAND WOMEN LEAGUE', 'M4 (x)' union all
select N'NEW ZEALAND YOUTH LEAGUE', 'M4 (x)' union all
select N'NIGERIA PREMIER LEAGUE', 'M4 (b)' union all
select N'NORTH AMERICAN SOCCER LEAGUE', 'M4 (b)' union all
select N'NORTHERN IRELAND CHAMPIONSHIP', 'Blacklist' union all
select N'NORTHERN IRELAND COUNTY ANTRIM SHIELD', 'Blacklist' union all
select N'NORTHERN IRELAND PREMIERSHIP', 'Blacklist' union all
select N'NORTHERN IRELAND PREMIERSHIP DEVELOPMENT LEAGUE', 'Blacklist' union all
select N'NORTHERN IRELAND WOMEN PREMIER LEAGUE', 'Blacklist' union all
select N'NORWAY 3RD DIVISION', 'M4 (x)' union all
select N'NORWAY NATIONAL CHAMPIONS LEAGUE U19', 'M4 (x)' union all
select N'NORWAY NATIONAL LEAGUE U19', 'M4 (x)' union all
select N'NORWAY TOPPSERIEN WOMEN', 'M4 (x)' union all
select N'NORWAY U19 DIVISION', 'M4 (x)' union all
select N'NORWAY U19 ELITE', 'M4 (x)' union all
select N'NORWAY U19 INTERKRETS A', 'M4 (x)' union all
select N'NORWAY U19 INTERKRETS B', 'M4 (x)' union all
select N'NORWAY U19 REGIONAL LIGA', 'M4 (x)' union all
select N'NORWAY WOMEN DIVISION 1', 'M4 (x)' union all
select N'PAN AMERICAN GAMES MEN SOCCER U22 (IN PERU)', 'M4 (x)' union all
select N'PAN AMERICAN GAMES WOMEN SOCCER (IN PERU)', 'M4 (x)' union all
select N'PAN ARAB GAME', 'M4 (b)' union all
select N'PARAGUAY CAMPEONATO WOMEN', 'M4 (x)' union all
select N'PARAGUAY DIVISION INTERMEDIA', 'M4 (x)' union all
select N'PARAGUAY LEAGUE U20', 'M4 (x)' union all
select N'PARAGUAY PRIMERA DIVISION', 'M4 (b)' union all
select N'PARAGUAY PRIMERA DIVISION RESERVE LEAGUE', 'M4 (x)' union all
select N'PERU COPA BICENTENARIO', 'M4 (x)' union all
select N'PERU COPA FEDERACION', 'M4 (x)' union all
select N'PERU CUADRANGULAR DE ASCENSO', 'M4 (x)' union all
select N'PERU LIGA 2', 'M4 (x)' union all
select N'PHILIPPINES FOOTBALL LEAGUE', 'Blacklist' union all
select N'PINK BOOT WOMEN (IN AUSTRALIA)', 'M4 (x)' union all
select N'POLAND 2ND DIVISION', 'M4 (x)' union all
select N'POLAND 3RD DIVISION', 'M4 (b)' union all
select N'POLAND CENTRAL JUNIOR LEAGUE', 'M4 (x)' union all
select N'POLAND MLODA EKSTRAKLASA U21', 'M4 (b)' union all
select N'POLAND WOMEN EKSTRALIGA', 'M4 (x)' union all
select N'PORTUGAL CAMPEONATO NACIONAL', 'M4 (x)' union all
select N'PORTUGAL CAMPEONATO NACIONAL WOMEN', 'M4 (x)' union all
select N'PORTUGAL CHAMPIONSHIP U17', 'M4 (x)' union all
select N'PORTUGAL CHAMPIONSHIP U19', 'M4 (b)' union all
select N'PORTUGAL LIGA REVELACAO U23', 'M4 (x)' union all
select N'PORTUGAL RESERVE LEAGUE', 'M4 (b)' union all
select N'PRESEASON TOURNAMENT (IN COLOMBIA)', 'M4 (x)' union all
select N'QATAR 2ND DIVISION', 'M4 (x)' union all
select N'QATAR LEAGUE U19', 'M4 (x)' union all
select N'QATAR LEAGUE U23', 'M4 (x)' union all
select N'QATAR RESERVE LEAGUE', 'M4 (x)' union all
select N'ROMANIA 2ND DIVISION', 'M4 (x)' union all
select N'ROMANIA 3RD DIVISION', 'M4 (x)' union all
select N'ROMANIA CHAMPIONSHIP U19', 'M4 (x)' union all
select N'ROMANIA WOMEN LIGA 1', 'M4 (x)' union all
select N'RUSSIA 2ND DIVISION', 'M4 (x)' union all
select N'RUSSIA CHAMPIONSHIP U20/ RUSSIA LEAGUE U20 (SB)/Russia Youth Championship (SBO)', 'M4 (x)' union all
select N'RUSSIA RESERVE LEAGUE', 'M4 (x)' union all
select N'RUSSIA WOMEN CHAMPIONSHIP', 'M4 (x)' union all
select N'SAUDI 1ST DIVISION', 'Blacklist' union all
select N'Saudi 1st Division /SAUDI RAKAA PROFESSIONAL LEAGUE', 'Blacklist' union all
select N'SAUDI 2ND DIVISION', 'Blacklist' union all
select N'SAUDI ARABIA YOUTH LEAGUE', 'Blacklist' union all
select N'SAUDI U17 LEAGUE', 'Blacklist' union all
select N'SCOTLAND DEVELOPMENT LEAGUE / SCOTLAND CLYDESDALE BANK U20 LEAGUE', 'M4 (b)' union all
select N'SCOTLAND DEVELOPMENT LEAGUE EAST', 'M4 (x)' union all
select N'SCOTLAND DEVELOPMENT LEAGUE WEST', 'M4 (x)' union all
select N'SCOTLAND HIGHLAND FOOTBALL LEAGUE', 'M4 (x)' union all
select N'SCOTLAND LOWLAND FOOTBALL LEAGUE', 'M4 (x)' union all
select N'SCOTLAND RESERVE LEAGUE', 'M4 (x)' union all
select N'SCOTLAND RESERVE LEAGUE 2', 'M4 (x)' union all
select N'SCOTLAND WOMENS PREMIER LEAGUE', 'M4 (x)' union all
select N'SCOTLAND WOMENS PREMIER LEAGUE 1', 'M4 (x)' union all
select N'SCOTLAND WOMENS PREMIER LEAGUE 2', 'M4 (x)' union all
select N'SERBIA FIRST LEAGUE / SERBIA PRVA LIGA', 'M4 (x)' union all
select N'SERBIA LEAGUE U19', 'M4 (x)' union all
select N'SERBIA SUPER LEAGUE', 'M4 (b)' union all
select N'SINGAPORE NATIONAL FOOTBALL LEAGUE DIVISION 1', 'Blacklist' union all
select N'SINGAPORE PREMIER LEAGUE', 'Blacklist' union all
select N'SINGAPORE RESERVE PRIME LEAGUE', 'Blacklist' union all
select N'SLOVAKIA 2ND DIVISION', 'M4 (x)' union all
select N'SLOVAKIA II LIGA SD U19 SK VYCHOD VSFZ', 'M4 (x)' union all
select N'SLOVAKIA II LIGA SD U19 SK VYCHOD VSFZ FK', 'M4 (x)' union all
select N'SLOVAKIA II LIGA SD U19 ZSFZ', 'M4 (x)' union all
select N'SLOVAKIA SUPER LEAGUE', 'M4 (b)' union all
select N'SLOVAKIA U19 LEAGUE', 'M4 (x)' union all
select N'SLOVAKIA WOMEN I LIGA', 'M4 (x)' union all
select N'SLOVENIA 2ND DIVISION', 'M4 (x)' union all
select N'SLOVENIA 3RD DIVISION', 'M4 (x)' union all
select N'SLOVENIA LEAGUE U19', 'M4 (x)' union all
select N'SLOVENIA PRVA LIGA', 'M4 (b)' union all
select N'SLOVENIA WOMEN LEAGUE', 'M4 (x)' union all
select N'SOUTH AFRICA 1ST DIVISION', 'Blacklist' union all
select N'SOUTH AFRICA PREMIERSHIP / South Africa ABSA Premiership (sbo)', 'M4 (b)' union all
select N'SOUTH AUSTRALIA PREMIER LEAGUE', 'M4 (b)' union all
select N'SOUTH AUSTRALIA PREMIER LEAGUE RESERVE', 'M4 (x)' union all
select N'SOUTH AUSTRALIA STATE LEAGUE 1', 'M4 (x)' union all
select N'SOUTH AUSTRALIA STATE LEAGUE 1 RESERVE', 'M4 (x)' union all
select N'SOUTH AUSTRALIA STATE LEAGUE 2', 'M4 (x)' union all
select N'SOUTH AUSTRALIA SUPER LEAGUE', 'M4 (x)' union all
select N'SOUTH AUSTRALIA WOMEN PREMIER LEAGUE', 'M4 (x)' union all
select N'SOUTH AUSTRALIA WOMEN PREMIER LEAGUE RESERVE', 'M4 (x)' union all
select N'SOUTH AUSTRALIA WOMEN STATE LEAGUE', 'M4 (x)' union all
select N'SPAIN DIVISION DE HONOR U19', 'M4 (x)' union all
select N'SPAIN SEGUNDA B DIVISION', 'M4 (x)' union all
select N'SPAIN TERCERA DIVISION', 'M4 (b)' union all
select N'SPAIN WOMEN PRIMERA DIVISION', 'M4 (b)' union all
select N'SPAIN WOMEN SEGUNDA DIVISION', 'M4 (x)' union all
select N'SUDAMERICANO U17 (IN ARGENTINA)', 'M4 (x)' union all
select N'SUDAMERICANO WOMEN', 'M4 (x)' union all
select N'SUDAMERICANO WOMEN U17 (IN VENEZUELA)', 'M4 (b)' union all
select N'SUDAMERICANO WOMEN U20 (IN BRAZIL)', 'M4 (x)' union all
select N'SWEDEN 3RD DIVISION', 'M4 (x)' union all
select N'SWEDEN ALLSVENSKAN U19 / SWEDEN U19 ALLSVENSKAN', 'M4 (x)' union all
select N'SWEDEN ALLSVENSKAN U21', 'M4 (x)' union all
select N'SWEDEN DIVISION 1 U19', 'M4 (x)' union all
select N'SWEDEN DIVISION 1 U19 GOTALAND', 'M4 (x)' union all
select N'SWEDEN DIVISION 1 U19 SVEALAND', 'M4 (x)' union all
select N'SWEDEN SUPERETTAN U21', 'Blacklist' union all
select N'SWEDEN U18 LEAGUE', 'M4 (x)' union all
select N'SWEDEN WOMEN 1ST DIVISION NORTH', 'M4 (x)' union all
select N'SWEDEN WOMEN 1ST DIVISION SOUTH', 'M4 (x)' union all
select N'SWEDEN WOMEN DAMALLSVENSKAN', 'M4 (b)' union all
select N'SWEDEN WOMEN DIVISION 2', 'M4 (x)' union all
select N'SWEDEN WOMEN ELITETTAN', 'M4 (x)' union all
select N'SWITZERLAND 1ST LIGA CLASSIC', 'M4 (x)' union all
select N'SWITZERLAND LEAGUE U18', 'M4 (x)' union all
select N'SWITZERLAND PROMOTION LEAGUE', 'M4 (x)' union all
select N'SWITZERLAND WOMEN NATIONAL LIGA A', 'M4 (x)' union all
select N'SYRIAN 2ND DIVISION', 'M4 (x)' union all
select N'SYRIAN LEAGUE', 'M4 (x)' union all
select N'THAILAND LEAGUE 1', 'M4 (x)' union all
select N'THAILAND LEAGUE 2', 'Blacklist' union all
select N'THAILAND LEAGUE U19', 'M4 (x)' union all
select N'THREE NATIONS TOURNAMENT WOMEN U20 (IN PAPUA NEW GUINEA)', 'M4 (x)' union all
select N'THREE NATIONS WOMEN TOURNAMENT (IN NORWAY)', 'M4 (x)' union all
select N'TORNEO VIAREGGIO (IN ITALY)', 'M4 (x)' union all
select N'TORNEO VICTORIA MEMORIAL MONCHO RIVERA', 'M4 (x)' union all
select N'TORNEO VILLA DE LAREDO (IN SPAIN)', 'M4 (x)' union all
select N'TRINIDAD AND TOBAGO PRO BOWL', 'M4 (x)' union all
select N'TRINIDAD AND TOBAGO TT PRO LEAGUE', 'M4 (x)' union all
select N'TROFEO ANGELO DOSSENA U19 (IN ITALY)(2X40 MINS)', 'M4 (a)' union all
select N'TUNISIAN LEAGUE', 'M4 (x)' union all
select N'TUNISIAN LEAGUE 2', 'M4 (x)' union all
select N'TUNISIAN U21', 'M4 (x)' union all
select N'TURKEY FIRST LEAGUE', 'M4 (b)' union all
select N'TURKEY SECOND LEAGUE', 'M4 (a)' union all
select N'TURKEY FIRST LEAGUE U21', 'M4 (x)' union all
select N'TURKEY SUPER LEAGUE U21', 'M4 (b)' union all
select N'TURKEY THIRD LEAGUE', 'M4 (x)' union all
select N'TURKEY U18 LEAGUE', 'Blacklist' union all
select N'TURKEY WOMEN FIRST LEAGUE', 'M4 (x)' union all
select N'UAE 1ST DIVISION', 'M4 (x)' union all
select N'UAE ETISALAT RESERVE LEAGUE', 'Blacklist' union all
select N'UAE LEAGUE U18', 'M4 (x)' union all
select N'UAE LEAGUE U21', 'M4 (x)' union all
select N'UAE U17 LEAGUE', 'Blacklist' union all
select N'UAE U19 LEAGUE', 'M4 (x)' union all
select N'UEFA U17 CHAMPIONSHIP 2019 (IN IRELAND)', 'M4 (a)' union all
select N'UEFA U17 CHAMPIONSHIP QUALIFIERS / UEFA European U17 Championship Qualifiers', 'M4 (x)' union all
select N'UEFA U19 CHAMPIONSHIP QUALIFIERS / UEFA European U19 Championship Qualifiers', 'LGL' union all
select N'UEFA WOMEN U17 CHAMPIONSHIP (IN CZECH REPUBLIC)(2X40 MINS)', 'M4 (x)' union all
select N'UEFA WOMEN U17 CHAMPIONSHIP QUALIFIERS', 'M4 (x)' union all
select N'UEFA WOMEN U19 CHAMPIONSHIP (IN SCOTLAND)', 'M4 (x)' union all
select N'UKRAINE 1ST LEAGUE / Ukraine First League', 'Blacklist' union all
select N'UKRAINE 1ST LEAGUE U19', 'Blacklist' union all
select N'UKRAINE 2ND LEAGUE', 'Blacklist' union all
select N'UKRAINE PREMIER LEAGUE', 'M4 (x)' union all
select N'UKRAINE WOMEN MAJOR LEAGUE', 'M4 (x)' union all
select N'UKRAINE YOUTH CHAMPIONSHIP U19', 'Blacklist' union all
select N'UKRAINE YOUTH CHAMPIONSHIP U21 / U‌‌k‌r‌‌‌‌‌a‌i‌‌‌‌n‌‌‌‌‌‌‌‌e‌‌‌‌‌‌ ‌‌‌‌‌‌‌‌‌Youth Championship U21/UKRAINE LEAGUE U21(SB)', 'Blacklist' union all
select N'UNITED SOCCER LEAGUE ', 'M4 (b)' union all
select N'UNITED SOCCER LEAGUE CHAMPIONSHIP', 'M4 (x)' union all
select N'UNITED SOCCER LEAGUE ONE', 'M4 (x)' union all
select N'UNITED SOCCER LEAGUE TWO', 'M4 (x)' union all
select N'UNITED WOMENS SOCCER', 'M4 (x)' union all
select N'URUGUAY CAMPEONATO B U19', 'M4 (x)' union all
select N'URUGUAY CAMPEONATO U19', 'M4 (x)' union all
select N'URUGUAY PRIMERA DIVISION', 'M4 (b)' union all
select N'URUGUAY RESERVE LEAGUE', 'M4 (x)' union all
select N'URUGUAY SEGUNDA DIVISION', 'M4 (x)' union all
select N'URUGUAY TORNEO INTERMEDIO', 'M4 (x)' union all
select N'USA NATIONAL WOMEN SOCCER LEAGUE', 'M4 (x)' union all
select N'USA RESERVE LEAGUE', 'M4 (x)' union all
select N'USA WOMENS PREMIER SOCCER LEAGUE', 'M4 (x)' union all
select N'USA WOMENS PROFESSIONAL SOCCER', 'M4 (x)' union all
select N'USA WOMENS W-LEAGUE', 'M4 (x)' union all
select N'UZBEKISTAN LEAGUE', 'M4 (x)' union all
select N'UZBEKISTAN PRO LEAGUE A / UZBEKISTAN 1ST DIVISION', 'Blacklist' union all
select N'UZBEKISTAN PRO LEAGUE B', 'Blacklist' union all
select N'UZBEKISTAN SUPER LEAGUE / Uzbekistan Professional Football League', 'M4 (x)' union all
select N'UZBEKISTAN U23 LEAGUE', 'Blacklist' union all
select N'UZBEKISTAN WOMEN CHAMPOINSHIP', 'M4 (x)' union all
select N'VENEZUELA PRIMERA DIVISION', 'Blacklist' union all
select N'VENEZUELA SEGUNDA DIVISION', 'Blacklist' union all
select N'VENEZUELA TERCERA DIVISION', 'Blacklist' union all
select N'VIETNAM CHAMPIONSHIP U19', 'Blacklist' union all
select N'VIETNAM SECOND LEAGUE', 'Blacklist' union all
select N'VIETNAM U21 CHAMPIONSHIP', 'Blacklist' union all
select N'VIETNAM U21 CHAMPIONSHIP QUALIFIERS', 'Blacklist' union all
select N'VIETNAM V LEAGUE', 'Blacklist' union all
select N'VIETNAM V LEAGUE 2', 'Blacklist' union all
select N'VIETNAM WOMEN NATIONAL CHAMPIONSHIP', 'Blacklist' union all
select N'MONTENEGRO FIRST LEAGUE', 'Blacklist' union all
select N'MALTA FA TROPHY', 'Blacklist' union all
select N'KUWAIT YOUTH LEAGUE', 'Blacklist' union all
select N'MONGOLIA PREMIER LEAGUE', 'Blacklist' union all
select N'WALES FIRST DIVISION', 'M4 (b)' union all
select N'WALES PREMIER LEAGUE', 'M4 (b)' union all
select N'WEIFANG INTERNATIONAL WOMEN FOOTBALL TOURNAMENT (IN CHINA)', 'M4 (x)' union all
select N'WEST ASIAN FOOTBALL FEDERATION CHAMPIONSHIP (IN IRAQ)', 'M4 (a)' union all
select N'WESTERN AUSTRALIA BAM CREATIVE NIGHT SERIES', 'M4 (x)' union all
select N'WESTERN AUSTRALIA DIVISION ONE NIGHT SERIES', 'M4 (x)' union all
select N'WESTERN AUSTRALIA NATIONAL PREMIER LEAGUE NIGHT SERIES', 'M4 (x)' union all
select N'WESTERN AUSTRALIA NATIONAL PREMIER LEAGUE U20', 'M4 (x)' union all
select N'WESTERN AUSTRALIA STATE LEAGUE DIVISION 1', 'M4 (x)' union all
select N'WESTERN AUSTRALIA STATE LEAGUE DIVISION 1 RESERVE', 'M4 (x)' union all
select N'WESTERN AUSTRALIA STATE LEAGUE DIVISION 2', 'M4 (x)' union all
select N'WESTERN AUSTRALIA STATE LEAGUE NIGHT SERIES', 'M4 (x)' union all
select N'WESTERN AUSTRALIA WOMEN PREMIER LEAGUE', 'M4 (x)' union all
select N'WESTERN AUSTRALIA WOMEN STATE LEAGUE NIGHT SERIES', 'M4 (x)' union all
select N'WESTERN AUSTRALIA WOMENS PREMIER NIGHT SERIES', 'M4 (x)' union all
select N'WOMEN FOUR NATIONS TOURNAMENT U18', 'M4 (x)' union all
select N'WOMEN FOUR NATIONS TOURNAMENT U23', 'M4 (x)' union all
select N'WOMEN THREE NATIONS TOURNAMENT U18 (IN AZERBAIJAN)', 'M4 (x)' union all
select N'WOMEN THREE NATIONS TOURNAMENT U23', 'M4 (x)' union all
select N'YEMEN 1ST DIVISION', 'M4 (x)' union all
select N'YEMEN 2ND DIVISION', 'M4 (x)' union all
select N'BRAZIL CAMPEONATO PAULISTA B U20', 'M4 (x)' union all
select N'CZECH REPUBLIC 4TH DIVISION CFL', 'M4 (x)' union all
select N'CZECH REPUBLIC 4TH DIVISION MSFL', 'M4 (x)' union all
select N'ESTONIA ESILIIGA', 'M4 (x)' union all
select N'ESTONIA ESILIIGA B', 'M4 (x)' union all
select N'ESTONIA ESILIIGA U19', 'M4 (x)' union all
select N'GEORGIA EROVNULI LIGA 2', 'M4 (x)' union all
select N'GEORGIA LIGA 3', 'M4 (x)' union all
select N'INDIA BANGALORE SUPER DIVISION', 'M4 (x)' union all
select N'INDIA CALCUTTA PREMIER DIVISION', 'M4 (x)' union all
select N'INDIA CALCUTTA PREMIER DIVISION A', 'M4 (x)' union all
select N'INDIA DELHI SENIOR DIVISION', 'M4 (x)' union all
select N'INDIA GOA FIRST DIVISION', 'M4 (x)' union all
select N'INDIA GOA PROFESSIONAL LEAGUE', 'M4 (x)' union all
select N'INDIA KERALA PREMIER LEAGUE', 'M4 (x)' union all
select N'INDIA MIZORAM PREMIER LEAGUE', 'M4 (x)' union all
select N'INDIA PUNJAB STATE SUPER FOOTBALL LEAGUE', 'M4 (x)' union all
select N'INDIA SHILLONG PREMIER LEAGUE', 'M4 (x)' union all
select N'INDIA SHILLONG PREMIER LEAGUE U18', 'M4 (x)' union all
select N'INDIAN I LEAGUE 2ND DIVISION', 'M4 (x)' union all
select N'INDIAN I LEAGUE U18', 'M4 (x)' union all
select N'INDIAN I LEAGUE U19', 'M4 (x)' union all
select N'INDONESIA LIGA 1 U20', 'M4 (x)' union all
select N'INDONESIA SOCCER CHAMPIONSHIP', 'M4 (x)' union all
select N'INDONESIA SOCCER CHAMPIONSHIP B', 'M4 (x)' union all
select N'INDONESIA SOCCER CHAMPIONSHIP U21', 'M4 (x)' union all
select N'INTERNATIONAL CLUB FOOTBALL TOURNAMENT (IN JAPAN)', 'M4 (x)' union all
select N'PAKISTAN PREMIER LEAGUE', 'M4 (x)' union all
select N'PANAMA LIGA FUTBOL', 'M4 (x)' union all
select N'PANAMA LIGA NACIONAL ASCENSO', 'M4 (x)' union all
select N'SAN MARINO CHAMPIONSHIP', 'M4 (x)' union all
select N'SAUDI PREMIER LEAGUE U19', 'M4 (x)' union all
select N'SOUTH AFRICA RESERVE LEAGUE', 'M4 (x)' union all
select N'SRI LANKA CHAMPIONS LEAGUE', 'M4 (x)' union all
select N'TORNEO ARGENTINO A', 'M4 (x)' union all
select N'TURKEY ELITE FIRST LEAGUE U19', 'M4 (x)' union all
select N'TURKEY ELITE SUPER LEAGUE U19 / TURKEY ELIT LEAGUE A U19', 'M4 (x)' union all
select N'TURKEY LEAGUE U19', 'M4 (x)' union all
select N'TURKEY YOUTH LEAGUE', 'M4 (x)' union all
select N'UAE 2ND DIVISION', 'M4 (x)' union all
select N'UAE RESERVE LEAGUE', 'M4 (x)' union all
select N'UAE YOUTH LEAGUE', 'M4 (x)' union all
select N'BRAZIL CAMPEONATO MINEIRO WOMEN', 'M4 (x)' union all
select N'BRAZIL CAMPEONATO PARAENSE U20', 'M4 (x)'

update t
set t.leagueid = l.leagueid
	,t.groupid = lg.groupid
from #league t
	inner join bodb02.dbo.League l with (nolock) on t.leaguename = l.leaguename
	inner join dbo.rmLeagueGroup lg with (nolock) on t.groupname = lg.groupname

insert into dbo.rmLeague (LeagueId, GroupId)
select LeagueId, GroupId from #league
where leagueId is not null and groupid is not null

drop table #league
