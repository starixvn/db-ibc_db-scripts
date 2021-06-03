use bodb_Licensee
go

declare @LicenseeRateSetting table (LicenseeName varchar(50), Rate float)
insert into @LicenseeRateSetting (LicenseeName, Rate)
select '11bet', 0.1 union all
select '12Bet', 0.1 union all
select '18Luck', 0.08 union all
select '24AVIA', 0.08 union all
select '365online', 0.08 union all
select '368Cash', 0.1 union all
select '396Club', 0.1 union all
select '3ge888', 0.1 union all
select '3star88', 0.08 union all
select '568Win', 0.07 union all
select '633esports', 0.07 union all
select '7kplatform', 0.1 union all
select '818Bet', 0.1 union all
select '88Macao', 0.1 union all
select '9Club', 0.1 union all
select 'A1game', 0.07 union all
select 'ab6688', 0.1 union all
select 'Abcasino', 0.1 union all
select 'Ae88', 0.1 union all
select 'AEUG', 0.08 union all
select 'AG', 0.1 union all
select 'allwincity', 0.1 union all
select 'ALPHA88', 0.1 union all
select 'Alphalota', 0.08 union all
select 'ANGbet', 0.1 union all
select 'AnvoFH', 0.1 union all
select 'AOGcasino', 0.1 union all
select 'awc', 0.1 union all
select 'awc2', 0.1 union all
select 'B24VN', 0.1 union all
select 'Baji', 0.1 union all
select 'HAIFA', 0.05 union all
select 'BBIN2', 0.05 union all
select 'BBIN3', 0.05 union all
select 'bdtt', 0.1 union all
select 'BETSUN', 0.1 union all
select 'BigGaming', 0.1 union all
select 'Bobo88', 0.085 union all
select 'BOG22', 0.1 union all
select 'Boma365', 0.1 union all
select 'Bonanza88', 0.1 union all
select 'Boying', 0.1 union all
select 'BPLE', 0.1 union all
select 'Bsdbet', 0.1 union all
select 'BWGaming', 0.1 union all
select 'Callmeboss', 0.1 union all
select 'CGame', 0.1 union all
select 'CGame4', 0.1 union all
select 'Champion', 0.1 union all
select 'Comebet', 0.1 union all
select 'Datang001', 0.1 union all
select 'Dawoo', 0.1 union all
select 'DBP', 0.1 union all
select 'Debet', 0.1 union all
select 'DEWA', 0.1 union all
select 'DF88', 0.1 union all
select 'Diamond', 0.07 union all
select 'DingTai', 0.07 union all
select 'dj888', 0.1 union all
select 'e8casino', 0.1 union all
select 'ECBet88', 0.1 union all
select 'ECLBET', 0.08 union all
select 'erhaozhan', 0.1 union all
select 'Fabet', 0.1 union all
select 'FB88', 0.1 union all
select 'Five88', 0.1 union all
select 'asiabet88', 0.07 union all
select 'GAMEBee', 0.08 union all
select 'GamingSoft', 0.08 union all
select 'Gampag', 0.1 union all
select 'Gaobet', 0.1 union all
select 'gbkj', 0.1 union all
select 'GESAB', 0.1 union all
select 'GMASTER', 0.1 union all
select 'GPIGAME', 0.1 union all
select 'HC6YAYOU', 0.1 union all
select 'Heaven', 0.1 union all
select 'Hecbet', 0.1 union all
select 'Happy1668', 0.1 union all
select 'Hejiyongle', 0.1 union all
select 'hjccasino', 0.1 union all
select 'HL8', 0.1 union all
select 'HonorW', 0.1 union all
select 'HOT99', 0.1 union all
select 'HuangMa', 0.1 union all
select 'iBET', 0.1 union all
select 'ID88', 0.1 union all
select 'IGPTech', 0.08 union all
select 'INSERTGAME', 0.08 union all
select 'IONclub', 0.1 union all
select 'JIBET', 0.1 union all
select 'JZFortune', 0.1 union all
select 'IBO', 0.07 union all
select 'Kzing2', 0.07 union all
select 'Leng4D', 0.1 union all
select 'Liga', 0.1 union all
select 'liv66', 0.1 union all
select 'KeenOcean', 0.1 union all
select 'Lode88', 0.1 union all
select 'Lucky88', 0.1 union all
select 'M8Credit', 0.1 union all
select 'ManCity', 0.1 union all
select 'MARS', 0.1 union all
select 'MAX88', 0.1 union all
select 'Mayayule', 0.1 union all
select 'MICL', 0.1 union all
select 'Monaco', 0.1 union all
select 'Mopgaming', 0.07 union all
select 'MTech', 0.07 union all
select 'mtegames', 0.07 union all
select 'Mybet88', 0.08 union all
select 'MYGAME', 0.07 union all
select 'N88', 0.1 union all
select 'N8B', 0.1 union all
select 'N8BK', 0.1 union all
select 'N8G', 0.1 union all
select 'Nbbet', 0.08 union all
select 'Nbet', 0.1 union all
select 'OCMS', 0.1 union all
select 'Okada', 0.1 union all
select 'OLE777', 0.1 union all
select 'One88', 0.1 union all
select 'Onegaming', 0.1 union all
select 'OPEBET', 0.1 union all
select 'OXbet', 0.1 union all
select 'OYO', 0.1 union all
select 'Pinbo', 0.1 union all
select 'PKbet', 0.1 union all
select 'pmwint', 0.07 union all
select 'Raisetech', 0.07 union all
select 'Red88', 0.1 union all
select 'Royal', 0.1 union all
select 'SDY', 0.08 union all
select 'Senibet', 0.1 union all
select 'shengboyun', 0.07 union all
select 'Sin88', 0.1 union all
select 'Sky88', 0.1 union all
select 'Soon88', 0.1 union all
select 'spondemo', 0.12 union all
select 'Sunriseb2b', 0.1 union all
select 'Sunwin', 0.1 union all
select 'SV88', 0.1 union all
select 'TangChao', 0.1 union all
select 'TaoCai', 0.1 union all
select 'TCbet', 0.1 union all
select 'TGO', 0.08 union all
select 'TLC', 0.07 union all
select 'TopGame', 0.07 union all
select 'Tripleone', 0.1 union all
select 'TSEnter', 0.07 union all
select 'TT128', 0.1 union all
select 'txwl002', 0.07 union all
select 'TYCgame', 0.1 union all
select 'US8YAYOU', 0.1 union all
select 'Uwoniwin', 0.1 union all
select 'VCBA', 0.1 union all
select 'VN88', 0.1 union all
select 'W88', 0.1 union all
select 'WABET', 0.1 union all
select 'Wanbo', 0.07 union all
select 'WBS', 0.1 union all
select 'weicai', 0.07 union all
select 'win365', 0.1 union all
select 'Winbox', 0.09 union all
select 'WINCLUB88', 0.08 union all
select 'WKCUR', 0.1 union all
select 'WKPHIL', 0.1 union all
select 'wmcasino', 0.1 union all
select 'Xinbo', 0.1 union all
select 'XTDGT', 0.1 union all
select 'Xtu168', 0.08 union all
select 'Yibo', 0.1 union all
select 'YongBao', 0.1 union all
select 'YTX', 0.08 union all
select 'Yunji', 0.08 union all
select 'Zbet', 0.1 union all
select 'ZFRT081', 0.07 union all
select 'ZFRT082', 0.07 union all
select 'ZFRT125', 0.07 union all
select 'ZFRT132', 0.07 union all
select 'ZFRT133', 0.07 union all
select 'ZFRT142', 0.07 union all
select 'ZFRT150', 0.07 union all
select 'NewFuture', 0.07 union all
select 'ZhiFeng009', 0.07 union all
select 'ZhiFeng012', 0.07 union all
select 'ZhiFeng021', 0.07 union all
select 'ZhiFeng032', 0.07 union all
select 'ZhiFeng035', 0.07 union all
select 'ZhiFeng036', 0.07 union all
select 'ZhiFeng040', 0.07 union all
select 'Zowin', 0.1 union all
select 'zt828', 0.09

select FromParty as PartyId, ToParty as ParentId
into #PartyList
from dbo.OAS_ChargeInfo with (nolock)
where ProductId = 0
	and ToParty in (1, 9, 11, 98)
	and ToDate >= '2021-06-01'

insert into dbo.OAS_ChargeInfo (ProductId, FromParty, ToParty, ParentChargeId, Rate, ChargeType, FromDate, ToDate, BasisOfBilling)
select 63 as ProductId, p.PartyId as FromParty, pl.ParentId as ToParty, 0 AS ParentChargeId, ls.Rate, 1 as ChargeType
	,'2021-05-27' as FromDate, '2050-01-01' as ToDate
	,case pd.InvoiceLanguage
		when 'en-US' then convert(varchar(10), ls.Rate * 100.0) + '% of Gross Win, effective from 27 May 2021'
		when 'zh-CN' then N'授权费为: ' + convert(varchar(10), ls.Rate * 100.0) + N'%, 从2021年5月27号开始'
		else '' end as BasisOfBilling
from @LicenseeRateSetting ls
	inner join dbo.Licensees l with (nolock) on ls.LicenseeName = l.LicenseeName
	inner join dbo.OAS_Party p with (nolock) on l.LicenseeId = p.OldRefId
	inner join dbo.OAS_PartyDetail pd with (nolock) on p.PartyId = pd.PartyId
	inner join #PartyList pl on p.PartyId = pl.PartyId

drop table #PartyList

insert into dbo.LA_ChargeInfo_SystemMapping (ChargeId, SystemId)
select c.ChargeId, 2
from dbo.OAS_ChargeInfo c with (nolock)
	left join dbo.LA_ChargeInfo_SystemMapping s with (nolock) on c.ChargeId = s.ChargeId and s.SystemId = 2
where c.ProductId = 63 and c.ToParty in (1, 9, 11, 98)
	and s.ChargeId is null
