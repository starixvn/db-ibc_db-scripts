/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210603@Percy
	DB: DBCUST-bodb_Licensee
	Task: Update Fisrt Billing Date of Sports Lottery
	https://nexdev.net/issues/156412
*/

use bodb_Licensee
go

declare @LicenseeRateSetting table (LicenseeName varchar(50))
insert into @LicenseeRateSetting (LicenseeName)
select '11bet' union all
select '12Bet' union all
select '18Luck' union all
select '24AVIA' union all
select '365online' union all
select '368Cash' union all
select '396Club' union all
select '3ge888' union all
select '3star88' union all
select '568Win' union all
select '633esports' union all
select '7kplatform' union all
select '818Bet' union all
select '88Macao' union all
select '9Club' union all
select 'A1game' union all
select 'ab6688' union all
select 'Abcasino' union all
select 'Ae88' union all
select 'AEUG' union all
select 'AG' union all
select 'allwincity' union all
select 'alog' union all
select 'ALPHA88' union all
select 'Alphalota' union all
select 'ANGbet' union all
select 'AnvoFH' union all
select 'AOGcasino' union all
select 'asiabet88' union all
select 'B24VN' union all
select 'Baji' union all
select 'BBIN2' union all
select 'BBIN3' union all
select 'bdtt' union all
select 'BETSUN' union all
select 'BigGaming' union all
select 'Bobbet' union all
select 'Bobo88' union all
select 'BOG22' union all
select 'Boma365' union all
select 'Bonanza88' union all
select 'Boying' union all
select 'BPLE' union all
select 'Bsdbet' union all
select 'BWGaming' union all
select 'Callmeboss' union all
select 'CGame' union all
select 'CGame4' union all
select 'Champion' union all
select 'Comebet' union all
select 'Datang001' union all
select 'Dawoo' union all
select 'DBP' union all
select 'Debet' union all
select 'DEWA' union all
select 'DF88' union all
select 'Diamond' union all
select 'DingTai' union all
select 'dj888' union all
select 'e8casino' union all
select 'ECBet88' union all
select 'ECLBET' union all
select 'erhaozhan' union all
select 'Fabet' union all
select 'FB88' union all
select 'Five88' union all
select 'GAMEBee' union all
select 'GamingSoft' union all
select 'Gampag' union all
select 'Gaobet' union all
select 'gbkj' union all
select 'GESAB' union all
select 'GGBOOK' union all
select 'GMASTER' union all
select 'GPIGAME' union all
select 'HAIFA' union all
select 'Happy1668' union all
select 'HC6YAYOU' union all
select 'Heaven' union all
select 'Hecbet' union all
select 'Hejiyongle' union all
select 'hjccasino' union all
select 'HL8' union all
select 'HonorW' union all
select 'HOT99' union all
select 'HuangMa' union all
select 'iBET' union all
select 'IBO' union all
select 'ID88' union all
select 'IGPTech' union all
select 'INSERTGAME' union all
select 'IONclub' union all
select 'JIBET' union all
select 'JZFortune' union all
select 'KeenOcean' union all
select 'Kzing2' union all
select 'Leng4D' union all
select 'Liga' union all
select 'liv66' union all
select 'Lode88' union all
select 'Lucky88' union all
select 'M8Credit' union all
select 'MANBETX' union all
select 'ManCity' union all
select 'MARS' union all
select 'MAX88' union all
select 'Mayayule' union all
select 'Mayibet' union all
select 'MICL' union all
select 'Monaco' union all
select 'Mopgaming' union all
select 'MTech' union all
select 'mtegames' union all
select 'Mybet88' union all
select 'MYGAME' union all
select 'N88' union all
select 'N8B' union all
select 'N8BK' union all
select 'N8G' union all
select 'Nbbet' union all
select 'Nbet' union all
select 'NewFuture' union all
select 'OCMS' union all
select 'Okada' union all
select 'OLE777' union all
select 'One88' union all
select 'Onegaming' union all
select 'OneSports' union all
select 'OPEBET' union all
select 'OSUSDT' union all
select 'OXbet' union all
select 'OYO' union all
select 'pinbo' union all
select 'PKbet' union all
select 'pmwint' union all
select 'Raisetech' union all
select 'Red88' union all
select 'Royal' union all
select 'SDY' union all
select 'Senibet' union all
select 'shengboyun' union all
select 'Sin88' union all
select 'Sky88' union all
select 'Soon88' union all
select 'spondemo' union all
select 'Sunriseb2b' union all
select 'Sunwin' union all
select 'SV88' union all
select 'TangChao' union all
select 'TaoCai' union all
select 'TCbet' union all
select 'TGO' union all
select 'Tianbo' union all
select 'TLC' union all
select 'TopGame' union all
select 'Tripleone' union all
select 'TSEnter' union all
select 'TT128' union all
select 'txwl002' union all
select 'TYCgame' union all
select 'US8YAYOU' union all
select 'Uwoniwin' union all
select 'VCBA' union all
select 'VN88' union all
select 'W88' union all
select 'WABET' union all
select 'Wanbo' union all
select 'WBS' union all
select 'weicai' union all
select 'win365' union all
select 'Winbox' union all
select 'WINCLUB88' union all
select 'WKCUR' union all
select 'WKPHIL' union all
select 'wmcasino' union all
select 'Xinbo' union all
select 'XTDGT' union all
select 'Xtu168' union all
select 'Yibo' union all
select 'YongBao' union all
select 'YTX' union all
select 'Yunji' union all
select 'Zbet' union all
select 'ZFRT081' union all
select 'ZFRT082' union all
select 'ZFRT125' union all
select 'ZFRT132' union all
select 'ZFRT133' union all
select 'ZFRT142' union all
select 'ZFRT150' union all
select 'ZhiFeng009' union all
select 'ZhiFeng012' union all
select 'ZhiFeng021' union all
select 'ZhiFeng032' union all
select 'ZhiFeng035' union all
select 'ZhiFeng036' union all
select 'ZhiFeng040' union all
select 'Zowin' union all
select 'zt828'

select FromParty as PartyId, ToParty as ParentId
into #PartyList
from dbo.OAS_ChargeInfo with (nolock)
where ProductId = 0
	and ToParty in (9, 11, 98)
	and ToDate >= '2021-06-01'

insert into dbo.LA_InvoiceSetting (FromPartyId, ToPartyId, ProductId, InvTypeId, InvTempId, BankId, ActiveAddress)
select sb.FromPartyId, sb.ToPartyId, 63 ProductId, sb.InvTypeId, sb.InvTempId, sb.BankId, sb.ActiveAddress
from dbo.LA_InvoiceSetting sb with (nolock)
	left join dbo.LA_InvoiceSetting lt with (nolock) on sb.FromPartyId = lt.FromPartyId and sb.ToPartyId = lt.ToPartyId and lt.ProductId = 63
where sb.ProductId = 0 and sb.ToPartyId not in (116, 221) -- OEnterprise, Testing Biller
	and sb.FromPartyId in (
		select p.PartyId
		from @LicenseeRateSetting ls
			inner join dbo.Licensees l with (nolock) on l.LicenseeName = ls.LicenseeName
			inner join dbo.OAS_Party p with (nolock) on p.OldRefId = l.LicenseeId
			inner join #PartyList pl with (nolock) on p.PartyId = pl.PartyId
	)
	and lt.FromPartyId is null

drop table #PartyList