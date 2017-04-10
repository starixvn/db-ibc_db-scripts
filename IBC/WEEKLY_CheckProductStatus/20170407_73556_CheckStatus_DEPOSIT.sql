/*
Created: 20170328@Helen
Task: Monthly check Status setting for credit/deposit customers - [Redmine:73556]
DB: DB054.CheckResultDB
Revisions:
For products using table custinfo to manage status	
*/
USE CheckResultDB
GO
------------------------------------ #1: Number Game	161	81	3	CustInfo.DisableNumber ---------------------------------------------------------
EXEC [DBA_CheckStatus_Deposit] @sportType=161, @bettype = 81, @DisableTable = 'CustInfo', @DisableColumnName = 'DisableNumber', @HiddenTable='', @HiddenColumnName='',@SynTable='',@SynColumnName = ''

------------------------------------ #2: Live Casino	162	1101	4		CustInfo.DisableLiveCasino	custinfo.SyncLiveCasino ---------------------------------------------------------
EXEC [DBA_CheckStatus_Deposit] @sportType=161, @bettype = 81,@DisableTable = 'CustInfo', @DisableColumnName = 'DisableLiveCasino', @HiddenTable='', @HiddenColumnName='',@SynTable='CustInfo',@SynColumnName = 'SyncLiveCasino'

------------------------------------ #3: "VirtualSports(SportType:180 BetType: 1201	180	1201	5		CustInfo.DisableVirtualSports	CustInfo.HideVirtualSports ---------------------------------------------------------
EXEC [DBA_CheckStatus_Deposit] @sportType=180, @bettype = 1201, @DisableTable = 'CustInfo', @DisableColumnName = 'DisableVirtualSports', @HiddenTable='CustInfo', @HiddenColumnName = 'HideVirtualSports',@SynTable='',@SynColumnName = ''

------------------------------------ #4: Gold Deluxe	255	1700	12		CustInfo.DisableGoldDeluxe	CustInfo.HideGoldDeluxe ---------------------------------------------------------
EXEC [DBA_CheckStatus_Deposit] @sportType=255, @bettype = 1700, @DisableTable = 'CustInfo', @DisableColumnName = 'DisableGoldDeluxe', @HiddenTable='CustInfo', @HiddenColumnName = 'HideGoldDeluxe',@SynTable='',@SynColumnName = ''

------------------------------------ #5: Microgaming Live Casino	203	2001	13	CustInfo.DisableMicrogameLC ---------------------------------------------------------
EXEC [DBA_CheckStatus_Deposit] @sportType=203, @bettype = 2001, @DisableTable = 'CustInfo', @DisableColumnName = 'DisableMicrogameLC', @HiddenTable='', @HiddenColumnName = '',@SynTable='',@SynColumnName = ''

------------------------------------ #6: Microgaming RNG Casino 205	2008	17		CustInfo.DisableMicrogameRNG ---------------------------------------------------------
EXEC [DBA_CheckStatus_Deposit] @sportType=203, @bettype = 2001, @DisableTable = 'CustInfo', @DisableColumnName = 'DisableMicrogameRNG', @HiddenTable='', @HiddenColumnName = '',@SynTable='',@SynColumnName = ''

------------------------------------ #7: ColossusBet	204	18001	15		CustInfo.DisableColossusBet	Custinfo.HideColossusBet ---------------------------------------------------------
EXEC [DBA_CheckStatus_Deposit] @sportType=204, @bettype = 18001, @DisableTable = 'CustInfo', @DisableColumnName = 'DisableColossusBet', @HiddenTable='CustInfo', @HiddenColumnName = 'HideColossusBet',@SynTable='',@SynColumnName = ''

------------------------------------ #8: HorseRacing	151	31	2		Custinfo.DisableHorseRacing ---------------------------------------------------------
EXEC [DBA_CheckStatus_Deposit] @sportType=151, @bettype = 31, @DisableTable = 'CustInfo', @DisableColumnName = 'DisableHorseRacing', @HiddenTable='', @HiddenColumnName = '',@SynTable='',@SynColumnName = ''

------------------------------------#9: Casino	251	71	6		Custinfo.DisableCasino ---------------------------------------------------------
EXEC [DBA_CheckStatus_Deposit] @sportType=251, @bettype = 71, @DisableTable = 'CustInfo', @DisableColumnName = 'DisableCasino', @HiddenTable='', @HiddenColumnName = '',@SynTable='CustInfo',@SynColumnName = 'SyncCasino'

------------------------------------ #10: E-Sports	43	1	1		CustInfo.DisableEsports	N/A	N/A ---------------------------------------------------------
EXEC [DBA_CheckStatus_Deposit] @sportType=43, @bettype = 1, @DisableTable = 'CustInfo', @DisableColumnName = 'DisableEsports', @HiddenTable='', @HiddenColumnName = '',@SynTable='',@SynColumnName = ''

------------------------------------ #11: Metric Gaming - SuperLive	1	801	1		CustInfo.DisableSuperLive ---------------------------------------------------------
EXEC [DBA_CheckStatus_Deposit] @sportType=1, @bettype = 801, @DisableTable = 'CustInfo', @DisableColumnName = 'DisableSuperLive', @HiddenTable='', @HiddenColumnName = '',@SynTable='',@SynColumnName = ''

------------------------------------ #12 Keno ---------------------------------------------------------
-- Hidden: from custinfo
EXEC [DBA_CheckStatus_Deposit] @sportType=202, @bettype = 1501, @DisableTable = '', @DisableColumnName = '', @HiddenTable='CustInfo', @HiddenColumnName = 'HideKeno',@SynTable='',@SynColumnName = ''

-- Disable FROM CustGameType
EXEC [DBA_CheckStatus_Keno_Deposit] @Sporttype = 202,@Bettype = 1501, @DisableTable = 'CustGameType', @DisableColumnName = 'IsDisabled'
EXEC [DBA_CheckStatus_Keno_Deposit] @Sporttype = 202,@Bettype = 1502, @DisableTable = 'CustGameType', @DisableColumnName = 'IsDisabled'
EXEC [DBA_CheckStatus_Keno_Deposit] @Sporttype = 202,@Bettype = 1503, @DisableTable = 'CustGameType', @DisableColumnName = 'IsDisabled'
EXEC [DBA_CheckStatus_Keno_Deposit] @Sporttype = 202,@Bettype = 1504, @DisableTable = 'CustGameType', @DisableColumnName = 'IsDisabled'
EXEC [DBA_CheckStatus_Keno_Deposit] @Sporttype = 202,@Bettype = 1505, @DisableTable = 'CustGameType', @DisableColumnName = 'IsDisabled'
EXEC [DBA_CheckStatus_Keno_Deposit] @Sporttype = 202,@Bettype = 1506, @DisableTable = 'CustGameType', @DisableColumnName = 'IsDisabled'
EXEC [DBA_CheckStatus_Keno_Deposit] @Sporttype = 202,@Bettype = 1507, @DisableTable = 'CustGameType', @DisableColumnName = 'IsDisabled'
EXEC [DBA_CheckStatus_Keno_Deposit] @Sporttype = 202,@Bettype = 1508, @DisableTable = 'CustGameType', @DisableColumnName = 'IsDisabled'
EXEC [DBA_CheckStatus_Keno_Deposit] @Sporttype = 202,@Bettype = 1509, @DisableTable = 'CustGameType', @DisableColumnName = 'IsDisabled'
EXEC [DBA_CheckStatus_Keno_Deposit] @Sporttype = 202,@Bettype = 1511, @DisableTable = 'CustGameType', @DisableColumnName = 'IsDisabled'
EXEC [DBA_CheckStatus_Keno_Deposit] @Sporttype = 202,@Bettype = 1513, @DisableTable = 'CustGameType', @DisableColumnName = 'IsDisabled'
EXEC [DBA_CheckStatus_Keno_Deposit] @Sporttype = 202,@Bettype = 1514, @DisableTable = 'CustGameType', @DisableColumnName = 'IsDisabled'
EXEC [DBA_CheckStatus_Keno_Deposit] @Sporttype = 202,@Bettype = 1515, @DisableTable = 'CustGameType', @DisableColumnName = 'IsDisabled'
GO
