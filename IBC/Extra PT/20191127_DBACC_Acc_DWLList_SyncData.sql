use bodb_ACC
go

/*
	Created: 20191127@Percy
	DB: SIT - DBACC.bodb_ACC
	Task: Sync data from PRO
*/

alter table dbo.Acc_DWLList drop constraint PK_Acc_DWLList
go

alter table dbo.Acc_DWLList add constraint PK_Acc_DWLList primary key clustered
(
	custid asc
	,product asc
)with (pad_index = off, statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on) on [accdata]
go

delete dbo.Acc_DWLList -- with (rowlock, updlock)

insert into Acc_DWLList (custid, product, seq, ProductId, IsDeleted)
select 0, 'Total Balance', 0, 1, 0 union all
select 6911909, 'SPL', 1, 1, 0 union all
select 6911911, 'SPNL', 2, 1, 0 union all
select 6911913, 'Parlay', 3, 1, 0 union all
select 6911914, 'Outright', 4, 1, 0 union all
select 35739415, 'Bet Builder', 5, 1, 0 union all
select 35999735, 'Bet Builder (Due To Partners)', 6, 1, 1 union all
select 6911916, 'Casino', 8, 6, 0 union all
select 6911917, 'Live Casino', 9, 4, 1 union all
select 28601563, 'Casino (Amount due to Jackpot Pool)', 9, 6, 0 union all
select 6911918, 'Number Game', 10, 3, 0 union all
select 6911919, 'Racing', 11, 2, 1 union all
select 7723121, 'Racing (Due to Partners)', 12, 2, 1 union all
select 8158305, 'Virtual Sports', 13, 5, 0 union all
select 26513859, 'Virtual Sports 2', 14, 27, 0 union all
select 14054918, 'RNG Keno', 15, 8, 0 union all
select 26513853, 'Lottery', 16, 28, 0 union all
select 18188766, 'AG Casino', 17, 11, 0 union all
select 18188815, 'Macau', 18, 14, 0 union all
select 18123445, 'Gold Deluxe', 19, 12, 0 union all
select 18123442, 'Metric Gaming - Super Live', 20, 1, 0 union all
select 18256397, 'Microgaming - Live Casino', 21, 13, 1 union all
select 19692521, 'Microgaming - RNG Casino', 22, 17, 1 union all
select 18371760, 'Bettrade', 23, 1, 0 union all
select 19236210, 'Colossus Bets', 24, 15, 0 union all
select 20174356, 'Muay Thai', 25, 1, 0 union all
select 20664406, 'Allbet', 27, 21, 0 union all
select 21535688, 'Macau Games', 28, 22, 0 union all
select 23765766, 'NG2', 29, 23, 0 union all
select 24569216, 'Fishing World', 30, 24, 0 union all
select 25477229, 'Cash Out', 31, 25, 0 union all
select 27233199, 'Lucky 3', 32, 26, 1 union all
select 28435541, 'Exchange', 33, 31, 0 union all
select 27602556, 'Bullfighting', 34, 30, 1 union all
select 29712506, 'PP', 35, 32, 0 union all
select 35999728, 'PP (Due To Partners)', 36, 32, 1 union all
select 32131757, 'Poker Games', 37, 33, 1 union all
select 32131917, 'Poker Games (Due To Partners)', 38, 33, 1 union all
select 37499112, 'Card Club', 39, 34, 0 union all
select 37639217, 'CN88 SPL', 101, 1, 0 union all
select 37639217, 'CN88 SPNL', 102, 1, 0 union all
select 37639217, 'CN88 Parlay', 103, 1, 0 union all
select 37639217, 'CN88 Outright', 104, 1, 0 union all
select 37639217, 'CN88 Muay Thai', 105, 1, 0 union all
select 37639217, 'CN88 Number Game', 110, 3, 0 union all
select 37639217, 'CN88 Virtual Sports', 113, 5, 0 union all
select 37639217, 'CN88 Virtual Sports 2', 114, 27, 0 union all
select 37639217, 'CN88 RNG Keno', 115, 8, 0 union all
select 37639217, 'CN88 Lottery', 116, 28, 0

go

alter table dbo.Acc_DWLList_xtest drop constraint PK_Acc_DWLList_xtest
go

alter table dbo.Acc_DWLList_xtest add constraint PK_Acc_DWLList_xtest primary key clustered
(
	custid asc
	,product asc
)with (pad_index = off, statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on) on [accdata]
go

delete dbo.Acc_DWLList_xtest -- with (rowlock, updlock)

insert into Acc_DWLList_xtest (custid, product, seq, ProductId, IsDeleted)
select 0, 'Total Balance', 0, 1, 0 union all
select 9398886, 'SPL', 1, 1, 0 union all
select 12005466, 'SPNL', 2, 1, 0 union all
select 12005470, 'Parlay', 3, 1, 0 union all
select 12005483, 'Outright', 4, 1, 0 union all
select 35898387, 'Bet Builder', 5, 1, 0 union all
select 35898466, 'Bet Builder (Due To Partners)', 6, 1, 1 union all
select 12017095, 'Casino', 8, 6, 0 union all
select 12962878, 'Live Casino', 9, 4, 1 union all
select 29313344, 'Casino (Amount due to Jackpot Pool)', 9, 6, 0 union all
select 13062600, 'Number Game', 10, 3, 0 union all
select 13062602, 'Racing', 11, 2, 1 union all
select 13062630, 'Racing (Due to Partners)', 12, 2, 1 union all
select 13062615, 'Virtual Sports', 13, 5, 0 union all
select 27234475, 'Virtual Sports 2', 14, 27, 0 union all
select 13062664, 'RNG Keno', 15, 8, 0 union all
select 27234433, 'Lottery', 16, 28, 0 union all
select 18254399, 'AG Casino', 17, 11, 0 union all
select 18254404, 'Macau', 18, 14, 0 union all
select 18254395, 'Gold Deluxe', 19, 12, 0 union all
select 18254387, 'Metric Gaming - Super Live', 20, 1, 0 union all
select 18377344, 'Microgaming - Live Casino', 21, 13, 1 union all
select 19741787, 'Microgaming - RNG Casino', 22, 17, 1 union all
select 18377348, 'Bettrade', 23, 1, 0 union all
select 19235780, 'Colossus Bets', 24, 15, 0 union all
select 20174451, 'Muay Thai', 25, 1, 0 union all
select 20805826, 'Allbet', 27, 21, 0 union all
select 21526102, 'Macau Games', 28, 22, 0 union all
select 23766923, 'NG2', 29, 23, 0 union all
select 24567778, 'Fishing World', 30, 24, 0 union all
select 25440545, 'Cash Out', 31, 25, 0 union all
select 27234218, 'Lucky 3', 32, 26, 1 union all
select 28435564, 'Exchange', 33, 31, 0 union all
select 27602457, 'Bullfighting', 34, 30, 1 union all
select 29712538, 'PP', 35, 32, 0 union all
select 35883280, 'PP (Due To Partners)', 36, 32, 1 union all
select 32131993, 'Poker Games', 37, 33, 1 union all
select 32132063, 'Poker Games (Due To Partners)', 38, 33, 1 union all
select 37498893, 'Card Club', 39, 34, 0 union all
select 38242456, 'CN88 SPL', 101, 1, 0 union all
select 38242456, 'CN88 SPNL', 102, 1, 0 union all
select 38242456, 'CN88 Parlay', 103, 1, 0 union all
select 38242456, 'CN88 Outright', 104, 1, 0 union all
select 38242456, 'CN88 Muay Thai', 105, 1, 0 union all
select 38242456, 'CN88 Number Game', 110, 3, 0 union all
select 38242456, 'CN88 Virtual Sports', 113, 5, 0 union all
select 38242456, 'CN88 Virtual Sports 2', 114, 27, 0 union all
select 38242456, 'CN88 RNG Keno', 115, 8, 0 union all
select 38242456, 'CN88 Lottery', 116, 28, 0